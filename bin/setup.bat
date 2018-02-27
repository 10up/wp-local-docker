@echo off

REM Parameters
SETLOCAL
SET TITLE=%1
SET ADMIN_USER=%2
SET ADMIN_EMAIL=%3

if not defined EMPTY_CONTENT set EMPTY_CONTENT=true
if not "%EMPTY_CONTENT%"==true SET EMPTY_CONTENT=false

if not defined MULTISITE set MULTISITE=false
if not "%MULTISITE%"==true SET MULTISITE=false

if exist "./wordpress/wp-config.php" (
	echo "WordPress config file found."

	SET /P REINSTALL= "Do you want to reinstall? [y/n]"

	if "y" = "%REINSTALL%" (
		docker-compose exec --user www-data phpfpm wp db drop --yes
	else
		echo "Installation aborted."
		exit 5
	fi
)

REM Install WordPress
docker-compose exec --user www-data phpfpm wp core download --force
docker-compose exec --user www-data phpfpm wp core config --force
docker-compose exec --user www-data phpfpm wp db create

if true == "%EMPTY_CONTENT%" (
	SET ADMIN_PASSWORD=$(docker-compose exec --user www-data phpfpm wp core multisite-install --url=localhost --title="%TITLE%" --admin_user="%ADMIN_USER%" --admin_email="%ADMIN_EMAIL%")
) else (
	SET ADMIN_PASSWORD=$(docker-compose exec --user www-data phpfpm wp core install --url=localhost --title="%TITLE%" --admin_user="%ADMIN_USER%" --admin_email="%ADMIN_EMAIL%")
)

REM Adjust settings
docker-compose exec --user www-data phpfpm wp rewrite structure "/%postname%/"

REM Remove default content
if true == "%EMPTY_CONTENT%" (
	REM Remove all posts, comments, and terms
	docker-compose exec --user www-data phpfpm wp site empty --yes

	REM Remove plugins and themes
	docker-compose exec --user www-data phpfpm wp plugin delete hello
	docker-compose exec --user www-data phpfpm wp plugin delete akismet
	docker-compose exec --user www-data phpfpm wp theme delete twentyfifteen
	docker-compose exec --user www-data phpfpm wp theme delete twentysixteen

	REM Remove widgets
	docker-compose exec --user www-data phpfpm wp widget delete search-2
	docker-compose exec --user www-data phpfpm wp widget delete recent-posts-2
	docker-compose exec --user www-data phpfpm wp widget delete recent-comments-2
	docker-compose exec --user www-data phpfpm wp widget delete archives-2
	docker-compose exec --user www-data phpfpm wp widget delete categories-2
	docker-compose exec --user www-data phpfpm wp widget delete meta-2
)

REM Ask to install Monster Widget plugin
SET /P INSTALL_MONSTER_WIDGET=[Do you want to install the Monster Widget plugin? [y/n]]

if "y" = $INSTALL_MONSTER_WIDGET (
	docker-compose exec --user www-data phpfpm wp plugin install monster-widget --activate
	docker-compose exec --user www-data phpfpm wp widget add monster sidebar-1
)

REM Install additional plugins
docker-compose exec --user www-data phpfpm wp plugin install gutenberg --activate
docker-compose exec --user www-data phpfpm wp plugin install developer --activate

echo "Installation done."
echo "------------------"
echo "Admin Username: %ADMIN_USER%"
echo "%ADMIN_PASSWORD%"
start "" http://localhost/wp-login.php
