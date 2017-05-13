#!/bin/bash
# WordPress docker control script
# Not intended to be secure, just get a quick environment setup
# Written by: James Golovich <james@gnuinter.net>
#
# Set COMPOSE_PROJECT_NAME in .env if you want the project/hostname to be something other than the current directory name
#

#Check if root and bail
if [[ $EUID -ne 0 ]]; then
	echo "This code needs to be run as root" 
	exit 1
fi

if [ -f .env ]; then
	source .env
fi

if [ -e $COMPOSE_PROJECT_NAME ]; then
	# Set project name to directory, I know docker-compose will do this for me
	# but I want the name available in this script
	export COMPOSE_PROJECT_NAME=${PWD##*/}
fi

if [ -e $DWP_SUFFIX ]; then
	# Need a safe suffix for default
	export DWP_SUFFIX=local
fi

export DWP_DOMAIN="$COMPOSE_PROJECT_NAME"."$DWP_SUFFIX"

wp_setup () {
	if [ ! -f "wordpress/wp-config.php" ]; then
		echo "WordPress config file not found. Installing..."
		DIR_UID=`stat -c '%u' wordpress`
		docker-compose exec phpfpm usermod -u $DIR_UID www-data
		docker-compose exec --user www-data phpfpm wp core download
		# Need to wait for mysql to be setup?
		while ! docker-compose exec phpfpm mysql -h mysql -u wordpress --password=password ${COMPOSE_PROJECT_NAME} -e 'SELECT @@version' >/dev/null 2>&1;
		do
			echo Waiting for MySQL
			sleep 1
		done
		docker-compose exec --user www-data phpfpm wp core config --dbhost=mysql --dbname=$COMPOSE_PROJECT_NAME --dbuser=wordpress --dbpass=password
		docker-compose exec --user www-data phpfpm wp core install --url=$DWP_DOMAIN --title=$DWP_DOMAIN --admin_user=admin --admin_password=password --admin_email=admin@example.com
	fi
}

wp_cli () {
	docker-compose exec --user www-data phpfpm "$@"
}

dns_add () {
	if [ -f /etc/hosts ]; then
		echo "Services available:"
		# Nginx (aka WordPress)
		NGINX_IP=`docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" "$COMPOSE_PROJECT_NAME"_nginx_1`
		echo "$NGINX_IP www.$DWP_DOMAIN $DWP_DOMAIN" >> /etc/hosts
		echo "WordPress: http://www.$DWP_DOMAIN ($NGINX_IP)"
		
		# PhpMyAdmin
		PHPMYADMIN_IP=`docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" "$COMPOSE_PROJECT_NAME"_phpmyadmin_1`
		echo "$PHPMYADMIN_IP phpmyadmin.$DWP_DOMAIN" >> /etc/hosts
		echo "PhpMyAdmin: http://phpmyadmin.$DWP_DOMAIN ($PHPMYADMIN_IP)"

		# MySQL
		MYSQL_IP=`docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" "$COMPOSE_PROJECT_NAME"_mysql_1`
		echo "$MYSQL_IP mysql.$DWP_DOMAIN" >> /etc/hosts
		echo "MySQL: mysql.$DWP_DOMAIN:3306 ($MYSQL_IP)"
		
		# ElasticSearch
		ES_IP=`docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" "$COMPOSE_PROJECT_NAME"_elasticsearch_1`
		echo "$ES_IP elasticsearch.$DWP_DOMAIN" >> /etc/hosts
		echo "Elastic Search: http://elasticsearch.$DWP_DOMAIN:9200 ($ES_IP)"
	else
		echo No /etc/hosts found, cannot automatically setup hostname mapping
	fi
}

dns_remove () {
        if [ -f /etc/hosts ]; then
            cp /etc/hosts /tmp/hosts.orig
            sed -i "/$DWP_DOMAIN/d" /etc/hosts
        fi
}

dns_update () {
	# Easiest to just remove old entries before adding new ones
	dns_remove
	dns_add
}

case "$1" in
	start|up)
		docker-compose up -d && wp_setup && dns_update
		;;
	stop)
		docker-compose stop
		dns_remove
		;;
	bash|shell|ssh)
		docker-compose exec --user root phpfpm bash
		;;
	wp)
		wp_cli $@
		;;
	mysql)
		docker-compose exec mysql mysql -u root --password=password $COMPOSE_PROJECT_NAME
		;;
	*)
		echo "Usage: $0 [start|stop|bash|wp]" >&2
		exit 3
		;;
esac
