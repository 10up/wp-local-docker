#!/bin/bash

source "$(dirname "$0")/wp_docker_user.sh";
WP_DOCKER_USER="$(wp_docker_user)";

if [ -z $WP_DOCKER_USER ]; then
  WP_DOCKER_USER="www-data"
fi;

if [ -f "./wordpress/wp-config.php" ];
then
	echo "WordPress config file found."
else
	echo "WordPress config file not found. Installing..."
	docker-compose exec --user $WP_DOCKER_USER:www-data phpfpm wp core download
	docker-compose exec --user $WP_DOCKER_USER:www-data phpfpm wp core config --dbhost=mysql --dbname=wordpress --dbuser=root --dbpass=password
fi