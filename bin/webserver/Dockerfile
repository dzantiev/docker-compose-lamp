FROM php:7.1.20-apache

RUN apt-get -y update --fix-missing
RUN apt-get upgrade -y

# Install tools & libraries
RUN apt-get -y install apt-utils nano wget dialog \
    build-essential git curl libcurl3 libcurl3-dev zip

# Install important libraries
RUN apt-get -y install --fix-missing apt-utils build-essential git curl libcurl3 libcurl3-dev zip \
    libmcrypt-dev libsqlite3-dev libsqlite3-0 mysql-client zlib1g-dev \
    libicu-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# PHP Extensions
RUN pecl install xdebug-2.5.5 \
    && docker-php-ext-install opcache \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-install mcrypt \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install pdo_sqlite \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install curl \
    && docker-php-ext-install tokenizer \
    && docker-php-ext-install json \
    && docker-php-ext-install zip \
    && docker-php-ext-install exif \
    && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-install mbstring \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

#Phalcon
    WORKDIR /usr/local/src
    RUN git clone https://github.com/phalcon/cphalcon.git --branch v3.4.0 --single-branch
    WORKDIR /usr/local/src/cphalcon/build
    RUN ./install

    WORKDIR /etc/php7/mods-available
    RUN echo 'extension=phalcon.so' >> phalcon.ini
    RUN docker-php-ext-enable phalcon
    WORKDIR /var/www/html

# Enable apache modules
RUN a2enmod rewrite headers

ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]