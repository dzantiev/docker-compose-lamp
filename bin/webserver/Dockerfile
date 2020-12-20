FROM php:7.4-apache

RUN apt-get -y update --fix-missing
RUN apt-get upgrade -y

# Install tools & libraries
RUN apt-get -y install apt-utils nano wget dialog \
    build-essential git curl libcurl4 zip

# Install important libraries
RUN apt-get -y install --fix-missing apt-utils build-essential git curl libcurl4 zip \
    libmcrypt-dev libsqlite3-dev libsqlite3-0 mariadb-client zlib1g-dev \
    libicu-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# PHP Extensions
RUN pecl install xdebug-2.9.0
RUN docker-php-ext-enable xdebug
RUN docker-php-ext-enable opcache
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install pdo_sqlite
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install tokenizer
RUN docker-php-ext-install json
RUN docker-php-ext-install exif
RUN docker-php-ext-install -j$(nproc) intl

# GD
RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/
RUN docker-php-ext-install gd

#ModPageSpeed
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y apache2 wget \
    && wget https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb -O /tmp/modpagespeed.deb \
    && dpkg -i /tmp/modpagespeed.deb

#Phalcon
    RUN wget --content-disposition --output-document /tmp/phalcon.deb https://packagecloud.io/phalcon/stable/packages/debian/stretch/php7.4-phalcon_4.0.0-861+php7.4_amd64.deb/download.deb \
        && mkdir /tmp/pkg \
        && dpkg-deb -R /tmp/phalcon.deb /tmp/pkg \
        && cp /tmp/pkg/usr/lib/php/*/phalcon.so "$(php-config  --extension-dir)/phalcon.so" \
        && pecl install --force psr 1> /dev/null \
        && echo "extension=psr.so" > "$PHP_INI_DIR/conf.d/docker-php-ext-psr.ini" \
        && echo "extension=phalcon.so" > "$PHP_INI_DIR/conf.d/docker-php-ext-phalcon.ini"

# Enable apache modules
RUN a2enmod rewrite headers

ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
