# ornably-react/Dockerfile

# 노드 22버전 사용함
FROM node:22-alpine AS builder

# /app에서 빌드
WORKDIR /app

# package를 업데이트. 현재 작업 폴더에서 진행.
COPY package*.json ./
# 정확한 빌드를 위한 package-lock.json 사용을 위한 `npm ci`
RUN npm ci

# 빌드에 필요한 src/ public/ 등등 복사
COPY . .

# docker build \
#   --build-arg VITE_API_BASE_URL=http://example.com \
#   --build-arg VITE_PORTONE_STORE_ID=store-id \
#   --build-arg VITE_PORTONE_CHANNEL_KEY=channel-key \
#   -t ornably-frontend .
ARG VITE_API_BASE_URL=
ARG VITE_PORTONE_STORE_ID=
ARG VITE_PORTONE_CHANNEL_KEY=

ENV VITE_API_BASE_URL=$VITE_API_BASE_URL
ENV VITE_PORTONE_STORE_ID=$VITE_PORTONE_STORE_ID
ENV VITE_PORTONE_CHANNEL_KEY=$VITE_PORTONE_CHANNEL_KEY

# build 시작
RUN npm run build

# nginx에 위에서 만든 /app/dist 넣어서 만들기
FROM nginx:1.27-alpine

# 루트폴더에 존재하는 nginx.conf설정을 빌드될 이미지의 default.conf에 복사해주기
COPY nginx.conf /etc/nginx/conf.d/default.conf
# dist 파일을 html에 넣어주기
COPY --from=builder /app/dist /usr/share/nginx/html

# 80(http포트)으로 사용될 것임을 알려주기
EXPOSE 80

# nginx 
CMD ["nginx", "-g", "daemon off;"]