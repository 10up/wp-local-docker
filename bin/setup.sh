#!/bin/bash
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)

TITLE="WP-Docker-Construct"
ADMIN_EMAIL="engenharia@log.pt"
URL="docker-local.dev"
THEME="genesis-starter"
SINGLE_SITE=1


echo "-----------------------------"
echo "${TITLE}"
echo "-----------------------------"

## PROJECT DEPENDENCIES ##
echo "Building project dependencies..."

cd "$ROOT/wordpress"
echo " * Installing Composer dependencies..."
composer install

echo " * Installing NPM dependencies..."
npm install

echo " * Building theme..."
cd "$ROOT/wp-content/themes/genesis-starter"
composer install
npm install
npm run build


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

  if [ $SINGLE_SITE -eq 0 ]; then
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

echo "All done!"
