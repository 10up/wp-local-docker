#!/bin/bash

# Read user information from docker-compose.override.yml
source "$(dirname "$0")/helper.sh";
WP_DOCKER_USER="$(wp_docker_user)";

if [ -f "./wordpress/wp-config.php" ];
then
	echo "WordPress config file found."
else
	echo "WordPress config file not found. Installing..."
	docker-compose exec --user $WP_DOCKER_USER:www-data phpfpm wp core download
	docker-compose exec --user $WP_DOCKER_USER:www-data phpfpm wp core config --dbhost=mysql --dbname=wordpress --dbuser=root --dbpass=password
fi