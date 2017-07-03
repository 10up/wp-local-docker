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

# Uncomment the line below if you're on a linux host
# replace {USER_ID} with your regular user id: $ id -u $USER
# replace {USER_NAME} with your regular user name: $ echo $USER
# RUN useradd -s /bin/bash -u {USER_ID} -G $(id -g www-data) {USER_NAME}

CMD ["php-fpm"]

EXPOSE 9000
