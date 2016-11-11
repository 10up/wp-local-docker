FROM php:7-fpm

ARG INSTALL_XDEBUG=true
ENV INSTALL_XDEBUG ${INSTALL_XDEBUG}
RUN if [ ${INSTALL_XDEBUG} = true ]; then \
    pecl install xdebug && \
    docker-php-ext-enable xdebug \
;fi

RUN apt-get update \
	&& apt-get install -y \
		libjpeg-dev \
		libpng-dev \
		libz-dev \
		less \
    && docker-php-ext-install -j$(nproc) \
    	gd \
    	mysqli \
    	zip \
    	pdo \
    	pdo_mysql \
    && docker-php-ext-enable gd mysqli zip pdo pdo_mysql \
    && apt-get remove -u build-essential libz-dev \
    && apt-get autoremove -y \
    && apt-get clean

RUN apt-get update && apt-get -y install libmemcached11 libmemcachedutil2 libmemcached-dev git \
    && mkdir -p /opt/memcached \
    && cd /opt/memcached \
    && git clone --branch php7 https://github.com/php-memcached-dev/php-memcached \
    && cd php-memcached \
    && phpize \
    && ./configure \
    && make \
    && mv /opt/memcached/php-memcached/modules/memcached.so /opt/memcached/memcached.so \
    && cd /opt/memcached \
    && rm -r php-memcached \
    && echo "extension=/opt/memcached/memcached.so" > /usr/local/etc/php/conf.d/memcached.ini \
    && apt-get remove -y build-essential libmemcached-dev libz-dev git \
    && apt-get autoremove -y \
    && apt-get clean

RUN curl https://getcomposer.org/download/1.2.0/composer.phar > /tmp/composer.phar \
    && chmod +x /tmp/composer.phar \
    && mv /tmp/composer.phar /usr/local/bin/composer \
    && apt-get update && apt-get install -y less \
    && curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > /tmp/wp-cli.phar \
    && chmod +x /tmp/wp-cli.phar \
    && mv /tmp/wp-cli.phar /usr/local/bin/wp

CMD ["php-fpm"]

EXPOSE 9000
