FROM php:8.0.3-fpm-alpine

COPY app /app

RUN docker-php-ext-install mysqli pdo pdo_mysql

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

WORKDIR /app

RUN composer install