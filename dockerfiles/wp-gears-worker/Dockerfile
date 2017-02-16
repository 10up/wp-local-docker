FROM johnpbloch/phpfpm:7.0

RUN apt-get update \
	&& apt-get install -y libgearman-dev unzip wget \
	&& apt-get clean \
	&& wget https://github.com/wcgallego/pecl-gearman/archive/master.zip \
	&& unzip master.zip \
	&& rm master.zip \
	&& ( \
		cd pecl-gearman-master \
		&& phpize \
		&& ./configure \
		&& make -j$(nproc) \
		&& make install \
	) \
	&& rm -r pecl-gearman-master \
	&& docker-php-ext-enable gearman

RUN apt-get update \
	&& apt-get install -y supervisor \
	&& apt-get clean

RUN mkdir -p /var/log/supervisor
RUN mkdir -p /etc/supervisord.d

CMD ["/usr/bin/supervisord", "-n"]
