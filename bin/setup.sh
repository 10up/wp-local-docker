#!/bin/bash

if [ -f "./wordpress/wp-config.php" ]; then
	echo "WordPress config file found."
	exit 1
fi

echo "WordPress config file not found. Installing..."
docker-compose exec --user www-data phpfpm wp core download
docker-compose exec -T --user www-data phpfpm wp core config

# Install WordPress
docker-compose exec --user www-data phpfpm wp db create
ADMIN_PASSWORD=$(docker-compose exec --user www-data phpfpm wp core install --url=localhost --title="$1" --admin_user="$2" --admin_email="$3")

# Adjust settings
docker-compose exec --user www-data phpfpm wp rewrite structure "/%postname%/"

# Ask to remove default content ?
echo -n "Do you want to remove the default content? [y/n]"
read REMOVE_DEFAULT_CONTENT

if [ "y" = $REMOVE_DEFAULT_CONTENT ]
then
	# Remove all posts, comments, and terms
	docker-compose exec --user www-data phpfpm wp site empty --yes

	# Remove plugins and themes
	docker-compose exec --user www-data phpfpm wp plugin delete hello
	docker-compose exec --user www-data phpfpm wp plugin delete akismet
	docker-compose exec --user www-data phpfpm wp theme delete twentyfifteen
	docker-compose exec --user www-data phpfpm wp theme delete twentysixteen

	# Remove widgets
	docker-compose exec --user www-data phpfpm wp widget delete recent-posts-2
	docker-compose exec --user www-data phpfpm wp widget delete recent-comments-2
	docker-compose exec --user www-data phpfpm wp widget delete archives-2
	docker-compose exec --user www-data phpfpm wp widget delete search-2
	docker-compose exec --user www-data phpfpm wp widget delete categories-2
	docker-compose exec --user www-data phpfpm wp widget delete meta-2
fi

# Ask to install Monster Widget plugin
echo -n "Do you want to install the Monster Widget plugin? [y/n]"
read INSTALL_MONSTER_WIDGET

if [ "y" = $INSTALL_MONSTER_WIDGET ]
then
	docker-compose exec --user www-data phpfpm wp plugin install monster-widget --activate
	docker-compose exec --user www-data phpfpm wp widget add monster sidebar-1
fi

# Install additional plugins
docker-compose exec --user www-data phpfpm wp plugin install gutenberg --activate
docker-compose exec --user www-data phpfpm wp plugin install developer --activate

echo "Installation done."
echo "------------------"
echo "Admin username: $2"
echo "$ADMIN_PASSWORD"
open http://localhost/wp-login.php
