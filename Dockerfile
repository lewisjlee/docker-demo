# 빌드 스테이지
FROM node:18-alpine AS builder

# 작업 디렉토리 설정
WORKDIR /app

# package.json과 package-lock.json만 먼저 복사하여 캐시 활용
COPY package*.json ./

# 의존성 설치
RUN npm ci --only=production

# 빌드 스테이지에서 불필요한 소스 코드 복사를 제거하여 빌드 스테이지 레이어 최소화 및 빌드 시간 단축

# 프로덕션 스테이지
FROM node:18-alpine AS production

# 보안을 위해 non-root 사용자 생성
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nodejs -u 1001

# 작업 디렉토리 설정
WORKDIR /app

# 빌드 스테이지에서 node_modules 복사
COPY --from=builder --chown=nodejs:nodejs /app/node_modules ./node_modules

# 소스 코드 복사
COPY --chown=nodejs:nodejs index.js ./
COPY --chown=nodejs:nodejs index-db.js ./

# 사용자 변경
USER nodejs

# 포트 노출
EXPOSE 3000

# 애플리케이션 실행
CMD ["node", "index.js"]
