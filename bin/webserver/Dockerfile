FROM php:7.4-fpm

RUN apt-get -y update --fix-missing
RUN apt-get upgrade -y

# Install important libraries
RUN apt-get -y install --fix-missing build-essential wget git curl zip \
    zlib1g-dev libicu-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev libzip-dev libonig-dev

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# PHP Extensions
RUN pecl install xdebug-2.9.0 \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install tokenizer \
    && docker-php-ext-install json \
    && docker-php-ext-install zip \
    && docker-php-ext-install exif \
    && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-install mbstring \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

#Phalcon
RUN wget --content-disposition --output-document /tmp/phalcon.deb https://packagecloud.io/phalcon/stable/packages/debian/stretch/php7.4-phalcon_4.0.0-861+php7.4_amd64.deb/download.deb \
    && mkdir /tmp/pkg \
    && dpkg-deb -R /tmp/phalcon.deb /tmp/pkg \
    && cp /tmp/pkg/usr/lib/php/*/phalcon.so "$(php-config  --extension-dir)/phalcon.so" \
    && pecl install --force psr 1> /dev/null \
    && echo "extension=psr.so" > "/usr/local/etc/php/conf.d/docker-php-ext-psr.ini" \
    && echo "extension=phalcon.so" > "/usr/local/etc/php/conf.d/docker-php-ext-phalcon.ini"

WORKDIR /var/www

CMD ["php-fpm"]