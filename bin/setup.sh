#!/bin/bash
if [ -f "./wordpress/wp-config.php" ]; then
	echo "WordPress config file found."

	echo -n "Do you want to reinstall? [y/n] "
	read REINSTALL

	if [ "y" = "$REINSTALL" ]
	then
		docker-compose exec --user www-data phpfpm wp db reset --yes
	else
		echo "Installation aborted."
		exit 1
	fi
fi

# Ask for the type of installation
echo -n "Do you want a multisite installation? [y/n] "
read MULTISITE

# Install WordPress
docker-compose exec --user www-data phpfpm wp core download --force
docker-compose exec -T --user www-data phpfpm wp core config --force

if [ "y" = "$MULTISITE" ]
then
	docker-compose exec --user www-data phpfpm wp core multisite-install --prompt
else
	docker-compose exec --user www-data phpfpm wp core install --prompt
fi

# Adjust settings
docker-compose exec --user www-data phpfpm wp rewrite structure "/%postname%/"

# Ask to remove default content ?
echo -n "Do you want to remove the default content? [y/n] "
read EMPTY_CONTENT

if [ "y" = "$EMPTY_CONTENT" ]
then
	# Remove all posts, comments, and terms
	docker-compose exec --user www-data phpfpm wp site empty --yes

	# Remove plugins and themes
	docker-compose exec --user www-data phpfpm wp plugin delete hello akismet
	docker-compose exec --user www-data phpfpm wp theme delete twentyfifteen twentysixteen

	# Remove widgets
	docker-compose exec --user www-data phpfpm wp widget delete search-2 recent-posts-2 recent-comments-2 archives-2 categories-2 meta-2
fi

echo "Installation done."
echo "------------------"
