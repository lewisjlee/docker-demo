# 빌드 스테이지
FROM node:24.4-alpine AS builder

# 작업 디렉토리 설정
WORKDIR /app

# package.json과 package-lock.json만 먼저 복사하여 캐시 활용
COPY package*.json ./

# 의존성 설치, --only=production 옵션을 사용하여 개발 의존성 제거
RUN npm ci --only=production

# 소스 코드 복사
COPY --chown=nodejs:nodejs . /app

# 사용자 변경
USER nodejs

# 애플리케이션 실행
CMD ["node", "index.js"]

# 포트 노출
EXPOSE 3000
