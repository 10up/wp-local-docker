#!/bin/bash
if [ -f "./wordpress/wp-config.php" ]; then
	echo "WordPress config file found."

	echo -n "Do you want to reinstall? [y/n] "
	read REINSTALL

	if [ "y" = "$REINSTALL" ]
	then
		docker-compose exec phpfpm su -s /bin/bash www-data -c "wp db reset --yes"
	else
		echo "Installation aborted."
		exit 1
	fi
fi

# Ask for the type of installation
echo -n "Do you want a multisite installation? [y/n] "
read MULTISITE

# Install WordPress
docker-compose exec phpfpm su -s /bin/bash www-data -c "wp core download --force"
docker-compose exec -T phpfpm su -s /bin/bash www-data -c "wp core config --force"

if [ "y" = "$MULTISITE" ]
then
	docker-compose exec phpfpm su -s /bin/bash www-data -c "wp core multisite-install --prompt"
else
	docker-compose exec phpfpm su -s /bin/bash www-data -c "wp core install --prompt"
fi

# Adjust settings
docker-compose exec phpfpm su -s /bin/bash www-data -c "wp rewrite structure "/%postname%/""

# Ask to remove default content ?
echo -n "Do you want to remove the default content? [y/n] "
read EMPTY_CONTENT

if [ "y" = "$EMPTY_CONTENT" ]
then
	# Remove all posts, comments, and terms
	docker-compose exec phpfpm su -s /bin/bash www-data -c "wp site empty --yes"

	# Remove plugins and themes
	docker-compose exec phpfpm su -s /bin/bash www-data -c "wp plugin delete hello akismet"
	docker-compose exec phpfpm su -s /bin/bash www-data -c "wp theme delete twentyfifteen twentysixteen"

	# Remove widgets
	docker-compose exec phpfpm su -s /bin/bash www-data -c "wp widget delete search-2 recent-posts-2 recent-comments-2 archives-2 categories-2 meta-2"
fi

echo "Installation done."
echo "------------------"
