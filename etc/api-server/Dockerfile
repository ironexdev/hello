FROM nginx:1.20.0-alpine

COPY app /app

COPY etc/api-server/production/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80 443