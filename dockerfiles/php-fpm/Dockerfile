FROM johnpbloch/phpfpm:7.0

RUN curl -L https://phar.phpunit.de/phpunit.phar > /tmp/phpunit.phar \
    && chmod +x /tmp/phpunit.phar \
    && mv /tmp/phpunit.phar /usr/local/bin/phpunit

RUN apt-get update && apt-get install -y \
        git \
        subversion \
        wget \
	libxml2-dev \
        ssmtp


RUN docker-php-ext-install soap
RUN echo "mailhub=mailcatcher:1025\nUseTLS=NO\nFromLineOverride=YES" > /etc/ssmtp/ssmtp.conf

# Read the user information from docker-compose.yml
ARG WP_DOCKER_USER
ARG WP_DOCKER_UID

# If there is valid user information, create a user with matching
# name and UID and add it to the www-data group
RUN if [ ! -z ${WP_DOCKER_UID} ] && [ ! -z ${WP_DOCKER_USER} ]; then \
        useradd -s /bin/bash -u ${WP_DOCKER_UID} -G $(id -g www-data) ${WP_DOCKER_USER}; \
    fi;

CMD ["php-fpm"]

EXPOSE 9000
