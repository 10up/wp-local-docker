@echo off
if exist "./wordpress/wp-config.php" (
	echo "WordPress config file found."

	SET /P REINSTALL= "Do you want to reinstall? [y/n] "

	if "y" = "%REINSTALL%" (
		docker-compose exec --user www-data phpfpm wp db reset --yes
	) else (
		echo "Installation aborted."
		exit 5
	)
)

REM Ask for the site title
SET /P TITLE=[Site title: ]

REM Ask for the user name
SET /P ADMIN_USER=[Username: ]

REM Ask for the user password
SET /P ADMIN_WP_PASSWORD=[Password: ]

REM Ask for the user email
SET /P ADMIN_EMAIL=[Your Email: ]

REM Ask for the type of installation
SET /P MULTISITE=[Do you want a multisite installation? [y/n] ]

REM Install WordPress
docker-compose exec --user www-data phpfpm wp core download --force
docker-compose exec --user www-data phpfpm wp core config --force

REM Set default admin user if none was provided
if "" == "%ADMIN_USER%" (
	SET ADMIN_USER="admin"
)

REM Set default admin password if none was provided
if "" == "%ADMIN_WP_PASSWORD%" (
	SET ADMIN_PASSWORD="password"
)

if "y" == "%MULTISITE%" (
	SET ADMIN_PASSWORD=$(docker-compose exec --user www-data phpfpm wp core multisite-install --url=localhost --title="%TITLE%" --admin_user="%ADMIN_USER%" --admin_email="%ADMIN_EMAIL%" --admin_password="%ADMIN_WP_PASSWORD%")
) else (
	SET ADMIN_PASSWORD=$(docker-compose exec --user www-data phpfpm wp core install --url=localhost --title="%TITLE%" --admin_user="%ADMIN_USER%" --admin_email="%ADMIN_EMAIL%" --admin_password="%ADMIN_WP_PASSWORD%")
)

REM Adjust settings
docker-compose exec --user www-data phpfpm wp rewrite structure "/%postname%/"

REM Ask to remove default content ?
SET /P EMPTY_CONTENT=[Do you want to remove the default content? [y/n] ]

if "y" == "%EMPTY_CONTENT%" (
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

REM Ask to install the Monster Widget plugin
SET /P INSTALL_MONSTER_WIDGET_PLUGIN=[Do you want to install the Monster Widget plugin? [y/n] ]
if "y" = "%INSTALL_MONSTER_WIDGET_PLUGIN%" (
	docker-compose exec --user www-data phpfpm wp plugin install monster-widget --activate
	docker-compose exec --user www-data phpfpm wp widget add monster sidebar-1
)

REM Ask to install the Gutenberg plugin
SET /P INSTALL_GUTENBERG_PLUGIN=[Do you want to install the Gutenberg plugin? [y/n] ]
if "y" = "%INSTALL_GUTENBERG_PLUGIN%" (
	docker-compose exec --user www-data phpfpm wp plugin install gutenberg --activate
)

REM Ask to install the Developer plugin
SET /P INSTALL_DEVELOPER_PLUGIN=[Do you want to install the Developer plugin? [y/n] ]
if "y" = "%INSTALL_DEVELOPER_PLUGIN%" (
	docker-compose exec --user www-data phpfpm wp plugin install developer --activate
)

echo "Installation done."
echo "------------------"
echo "Admin Username: %ADMIN_USER%"
echo "Admin Password: %ADMIN_WP_PASSWORD%"
start "" http://localhost/wp-login.php
