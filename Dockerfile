FROM php:8.2.5-fpm-alpine

RUN apk update && apk add --update --no-cache \
    autoconf g++ libtool make build-base freetype-dev libpng-dev jpeg-dev \
    libjpeg-turbo-dev freetype-dev oniguruma-dev libzip-dev zip jpegoptim \
    optipng pngquant gifsicle vim unzip git curl wget mysql-client supervisor

RUN rm /var/cache/apk/*

RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/
RUN docker-php-ext-install opcache bcmath pdo_mysql mbstring zip exif pcntl gd
RUN docker-php-ext-configure opcache --enable-opcache

RUN mkdir -p /usr/src/php/ext/redis; \
	curl -fsSL https://pecl.php.net/get/redis --ipv4 | tar xvz -C "/usr/src/php/ext/redis" --strip 1; \
	docker-php-ext-install redis;

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN addgroup -g 1000 www
RUN adduser -u 1000 www -G www -D

RUN touch /var/log/php.log && chmod 777 /var/log/php.log
RUN touch /var/log/schedule.log && chmod 777 /var/log/schedule.log
RUN touch /var/log/queue.log && chmod 777 /var/log/queue.log
RUN touch /var/log/supervisord.log && chmod 777 /var/log/supervisord.log
RUN touch /var/run/supervisord.pid && chmod 777 /var/run/supervisord.pid

EXPOSE 9000
CMD ["php-fpm"]
