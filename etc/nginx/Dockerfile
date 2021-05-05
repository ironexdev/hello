FROM nginx:1.20.0-alpine

COPY app /app

COPY etc/nginx/production/default.conf /etc/nginx/conf.d/default.conf

RUN apk add python3 python3-dev py3-pip build-base libressl-dev musl-dev libffi-dev
RUN pip3 install pip --upgrade
RUN pip3 install certbot-nginx