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

# If you're on a linux host, open a terminal window and run
# $ bin/linux-info.sh
#
# Uncomment the line below and replace {USER_ID} and {USER_NAME} with the values returned
# RUN useradd -s /bin/bash -u {USER_ID} -G $(id -g www-data) {USER_NAME}

CMD ["php-fpm"]

EXPOSE 9000
