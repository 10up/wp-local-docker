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

# Ask for the site title
echo -n "Site title: "
read TITLE

# Ask for the user name
echo -n "Username: "
read ADMIN_USER

# Ask for the user password
echo -n "Password: "
read ADMIN_PASSWORD

# Ask for the user email
echo -n "Your Email: "
read ADMIN_EMAIL

# Ask for the type of installation
echo -n "Do you want a multisite installation? [y/n] "
read MULTISITE

# Install WordPress
docker-compose exec --user www-data phpfpm wp core download --force
docker-compose exec -T --user www-data phpfpm wp core config --force

# Set default admin user if none was provided
if [ "" = "$ADMIN_USER" ]
then
	ADMIN_USER="admin"
fi

# Set default admin password if none was provided
if [ "" = "$ADMIN_PASSWORD" ]
then
	ADMIN_PASSWORD="password"
fi

if [ "y" = "$MULTISITE" ]
then
	docker-compose exec --user www-data phpfpm wp core multisite-install --url=localhost --title="$TITLE" --admin_user="$ADMIN_USER" --admin_email="$ADMIN_EMAIL" --admin_password="$ADMIN_PASSWORD"
else
	docker-compose exec --user www-data phpfpm wp core install --url=localhost --title="$TITLE" --admin_user="$ADMIN_USER" --admin_email="$ADMIN_EMAIL" --admin_password="$ADMIN_PASSWORD"
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

echo "Installation done."
echo "------------------"
echo "Admin username: $ADMIN_USER"
echo "Admin password: $ADMIN_PASSWORD"
open http://localhost/wp-login.php
