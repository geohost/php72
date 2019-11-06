FROM ubuntu:18.04
LABEL maintainer="George Draghici <george@geohost.ro>"

# Setting frontend Noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Avoid ERROR: invoke-rc.d: policy-rc.d denied execution of start.
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

# Install supervisor, mysql-client, php-fpm, composer
RUN apt-get update ; \
    apt-get install -y \
    software-properties-common ; \
    apt-get update ; \
    apt-get install -y \
    wget \
    nano \
    curl \
    unzip \
    php-redis \
    php7.2-cli \
    php7.2-fpm \
    php7.2-bz2 \
    php7.2-bcmath \
    php7.2-curl \
    php7.2-gd \
    php7.2-json \
    php7.2-mbstring \
    php7.2-xml \
    php7.2-xmlrpc \
    php7.2-zip \
    php7.2-opcache \
    php7.2-cgi \
    php7.2-xml \
    php7.2-mysql \
    php7.2-pgsql \
    php7.2-imagick \
    libmysqlclient-dev \
    mysql-client \
    imagemagick \
    mailutils \
    net-tools \
    supervisor

# Install PHP mcyrpt module
RUN apt install php-dev libmcrypt-dev gcc make autoconf libc-dev pkg-config -y
RUN yes "" | pecl install mcrypt-1.0.1
RUN echo "extension=mcrypt.so" | tee -a /etc/php/7.2/fpm/conf.d/mcrypt.ini

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# Copy php.ini file
ADD conf/php/php.ini /etc/php/7.2/fpm/php.ini
RUN mkdir -p /var/log/php
RUN touch /var/log/php/php-error.log && chown -R www-data:www-data /var/log/php

#Create docroot directory , copy code and Grant Permission to docroot
RUN mkdir -p /app
RUN chown -R www-data:www-data /app

ADD conf/php/www.conf /etc/php/7.2/fpm/pool.d/www.conf
ADD conf/supervisord.conf /etc/supervisor/supervisord.conf


# Enable www-data user shell
RUN chsh -s /bin/bash www-data

EXPOSE 9000

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

CMD ["/docker-entrypoint.sh"]
