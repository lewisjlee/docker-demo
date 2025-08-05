# 빌드 스테이지
FROM node:24.4-alpine AS builder

# 작업 디렉토리 설정
WORKDIR /app

# Yarn Berry 설정 파일들 복사
COPY package.json yarn.lock* .yarnrc.yml ./
COPY .yarn ./.yarn

# Yarn Berry Zero-Install 활용 (의존성 설치 생략)
# .yarn/cache가 이미 포함되어 있으므로 yarn install 불필요

# 프로덕션 스테이지
FROM node:24.4-alpine AS production

# 보안을 위해 non-root 사용자 생성
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nodejs -u 1001

# 작업 디렉토리 설정
WORKDIR /app

# Yarn Berry 설정 파일들 복사
COPY --from=builder --chown=nodejs:nodejs /app/package.json ./
COPY --from=builder --chown=nodejs:nodejs /app/yarn.lock* ./
COPY --from=builder --chown=nodejs:nodejs /app/.yarnrc.yml ./
COPY --from=builder --chown=nodejs:nodejs /app/.yarn ./.yarn

# 소스 코드 복사
COPY --chown=nodejs:nodejs index.js ./
COPY --chown=nodejs:nodejs index-db.js ./

# 사용자 변경
USER nodejs

# 포트 노출
EXPOSE 3000

# 애플리케이션 실행 (Zero-Install)
CMD ["yarn", "node", "index.js"]
