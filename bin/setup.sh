#!/bin/bash
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)

TITLE="WP-Docker-Construct"
ADMIN_EMAIL="engenharia@log.pt"
REPOSITORY="git@github.com:log-oscon/WP-Construct.git"

echo "-----------------------------"
echo "${TITLE}"
echo "-----------------------------"

read -p "Write your domain: " site_url
URL="${site_url// /-}.local";

read -p "is Multisite (y/n)? default n: " is_multisite
case "$is_multisite" in 
  y|Y ) MULTISITE=1;;
  n|N ) MULTISITE=0;;
  * ) MULTISITE=0;;
esac

## CHECKOUT PROJECT ##
if [ ! -z "$REPOSITORY" ] && [ ! -d "./wordpress/.git" ]; then
	echo "No local repository found. Downloading boilerplate / project from GIT..."
  cd "$ROOT/wordpress"
	git clone $REPOSITORY .
  cd "$ROOT"
fi

## PROJECT DEPENDENCIES ##
echo "Searching for project build script..."
if [ -f "./wordpress/.scripts/build.sh" ]; then
	cd "$ROOT/wordpress"
	echo " * Starting project build"
	sh .scripts/build.sh
else
	echo " * No build (.scripts/build.sh) script found."
fi

## WORDPRESS SETUP ##
if [ -f "./wordpress/wp-config.php" ]; then
	echo "WordPress config file found."
else
	echo "WordPress config file not found. Installing..."
	docker-compose exec --user www-data phpfpm wp core download
	docker-compose exec --user www-data phpfpm wp core config --dbhost=mysql --dbname=wordpress --dbuser=root --dbpass=password

# <<PHP
#   define( 'WP_DEBUG', true );
#   define( 'WP_DEBUG_LOG', true );
#   define( 'WP_DEBUG_DISPLAY', false );
#   @ini_set( 'display_errors', 0 );
#   define( 'SAVEQUERIES', false );
#   define( 'JETPACK_DEV_DEBUG', true );
#   define( 'WP_CACHE', true );
#   define( 'WP_CACHE_KEY_SALT', '$WP_CACHE_KEY_SALT' );
#   define( 'WP_ENV', 'development' );
# PHP

  if [ $MULTISITE -eq 0 ]; then
    echo " * Setting up multisite \"$TITLE\" at $URL"
    docker-compose exec --user www-data phpfpm wp core multisite-install --url="$URL" --title="$TITLE" --admin_user=admin --admin_password=password --admin_email="$ADMIN_EMAIL" --subdomains
    docker-compose exec --user www-data phpfpm wp super-admin add admin

  else
    echo " * Setting up \"$TITLE\" at $URL"
    docker-compose exec --user www-data phpfpm wp core install --url="$URL" --title="$TITLE" --admin_user=admin --admin_password=password --admin_email="$ADMIN_EMAIL"
  fi

  ## ACTIVATING COMPONENTS ##
  echo " * Activating the default theme"
  docker-compose exec --user www-data phpfpm wp theme activate ${THEME}

  # echo " * Importing test content"
  # docker-compose exec --user www-data phpfpm curl -OLs https://raw.githubusercontent.com/manovotny/wptest/master/wptest.xml
  # docker-compose exec --user www-data phpfpm wp import wptest.xml --authors=create
  # docker-compose exec --user www-data phpfpm rm wptest.xml
fi

## UPDATING COMPONENTS ##
echo "Updating WordPress"
docker-compose exec --user www-data phpfpm wp core update
docker-compose exec --user www-data phpfpm wp core update-db

read -p "Write URL: $URL on hosts (y/n)? default n: " write_hosts
case "$write_hosts" in 
  y|Y ) echo "127.0.0.1 $URL" | sudo tee -ai /private/etc/hosts;;
esac

echo "All done!"
