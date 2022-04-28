FROM php:8.0.2-apache
RUN apt-get -y update --fix-missing
RUN apt-get upgrade -y

# Install useful tools
RUN apt-get -y install apt-utils nano wget

# Install important libraries
RUN apt-get -y install --fix-missing apt-utils build-essential git curl zip
# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN docker-php-ext-enable opcache
RUN docker-php-ext-install pdo_mysql
#RUN docker-php-ext-install pdo_sqlite
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install tokenizer
#RUN docker-php-ext-install json
RUN docker-php-ext-install exif
#RUN docker-php-ext-install -j$(nproc) intl
#RUN docker-php-ext-install zip
#RUN docker-php-ext-install soap

ARG PSR_VERSION=1.1.0
ARG PHALCON_VERSION=4.1.1
ARG PHALCON_EXT_PATH=php7/64bits

RUN wget --content-disposition --output-document /tmp/phalcon.deb https://packagecloud.io/phalcon/stable/packages/ubuntu/trusty/php7.3-phalcon_3.4.3-2+php7.3_amd64.deb/download.deb \
                && mkdir /tmp/pkg \
                && dpkg-deb -R /tmp/phalcon.deb /tmp/pkg \
                && cp /tmp/pkg/usr/lib/php/*/phalcon.so "$(php-config  --extension-dir)/phalcon.so" \
                && pecl install --force psr \
                && echo "extension=psr.so" > "$PHP_INI_DIR/conf.d/docker-php-ext-psr.ini" \
                && echo "extension=phalcon.so" > "$PHP_INI_DIR/conf.d/docker-php-ext-phalcon.ini"

RUN a2enmod rewrite
RUN service apache2 restart
