# 프로덕션 스테이지
FROM node:24.4-alpine

# 보안을 위해 non-root 사용자 생성
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nodejs -u 1001

# 작업 디렉토리 설정
WORKDIR /app

# 의존성 패키지 복사
COPY --chown=nodejs:nodejs package.json ./
COPY --chown=nodejs:nodejs node_modules ./node_modules

# 소스 코드 복사
COPY --chown=nodejs:nodejs index.js ./
COPY --chown=nodejs:nodejs index-db.js ./

# 사용자 변경
USER nodejs

# 포트 노출
EXPOSE 3000

# 애플리케이션 실행 (PnP 모드)
CMD ["node", "index.js"]
