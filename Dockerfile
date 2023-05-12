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

EXPOSE 9000
CMD ["php-fpm"]
