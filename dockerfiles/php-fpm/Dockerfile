FROM johnpbloch/phpfpm:7.0

RUN curl -L https://phar.phpunit.de/phpunit.phar > /tmp/phpunit.phar \
    && chmod +x /tmp/phpunit.phar \
    && mv /tmp/phpunit.phar /usr/local/bin/phpunit

RUN apt-get install -y git subversion wget

RUN apt-get update && \
	apt-get install -y libxml2-dev && \
	docker-php-ext-install soap

RUN apt-get update && \
	apt-get install -y ssmtp && \
	echo "mailhub=mailcatcher:1025\nUseTLS=NO\nFromLineOverride=YES" > /etc/ssmtp/ssmtp.conf

CMD ["php-fpm"]

EXPOSE 9000