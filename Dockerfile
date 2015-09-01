FROM tsilenzio/php:5.4-fpm

MAINTAINER Taylor Silenzio <tsilenzio@gmail.com>

# Copy the new PHP settings
ADD conf.d/ /tmp/

# Enable the service
ADD service/ /etc/service/

# Update package manager repositories
RUN apt-get update \
    # Install PHP Dependencies
    && apt-get install -y g++ \
        libbz2-dev \
        libfreetype6-dev \
        libturbojpeg \
        libpng12-dev \
        libmcrypt-dev \
        freetds-dev \
        libpq-dev \
        libsqlite3-dev \
        libxslt-dev \
        libicu-dev \
        openssl \
        libc-client-dev \
        libkrb5-dev \
        libxml2-dev \
        libgd-dev \
        libcurl4-openssl-dev \
    && docker-php-ext-configure bcmath \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install bcmath \
        bz2 \
        calendar \
        curl \
        dba \
        dom \
        exif \
        ftp \
        gd \
        gettext \
        imap \
        intl \
        mbstring \
        mcrypt \
        mysqli \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        pdo_sqlite \
        soap \
        xmlrpc \
        xsl \
        zip \
    # Install configuration files
    && mkdir -p /usr/local/etc/php-fpm.d \
    && rm -rf /usr/local/etc/php-fpm.d/www.conf.default \
    && rm -rf /usr/local/etc/php-fpm.conf \
    && mv /tmp/www.conf /usr/local/etc/php-fpm.d/www.conf \
    && mv /tmp/php-fpm.conf /usr/local/etc/php-fpm.conf \
    && mv /tmp/php.ini /usr/local/etc/php/php.ini \
    # Handle post installation clean-up
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

CMD ["/sbin/my_init"]