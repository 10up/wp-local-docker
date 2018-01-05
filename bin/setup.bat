@echo off

if exist "./wordpress/wp-config.php" (
	echo "WordPress config file found."
) else (
	echo "WordPress config file not found. Installing..."
	docker-compose exec --user www-data phpfpm wp core download
	docker-compose exec --user www-data phpfpm wp core config

	REM Ask for the site name
	SET /P TITLE=[Enter the site title and press \[ENTER\]:]

	REM Ask for the user name
	SET /P ADMIN_USER=[Enter your username and press \[ENTER\]:]

	REM Ask for the user email
	SET /P ADMIN_EMAIL=[Enter your email and press \[ENTER\]:]

	REM Ask for the password
	SET /P ADMIN_PASSWORD=[Enter your password and press \[ENTER\]:]

	REM Install WordPress
	docker-compose exec --user www-data phpfpm wp db create
	docker-compose exec --user www-data phpfpm wp core install --url=localhost --title="%TITLE%" --admin_user="%ADMIN_USER%" --admin_email=%ADMIN_EMAIL% --admin_password="%ADMIN_PASSWORD%"

	REM Adjust settings
	docker-compose exec --user www-data phpfpm wp rewrite structure "/%postname%/"

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

	REM Install additional plugins
	docker-compose exec --user www-data phpfpm wp plugin install developer --activate
	docker-compose exec --user www-data phpfpm wp plugin install monster-widget --activate
	docker-compose exec --user www-data phpfpm wp widget add monster sidebar-1

	echo "Installation done."
	echo "------------------"
	echo "Username: %ADMIN_USER%
	echo "Password: %ADMIN_PASSWORD%"
	start "" http://localhost/wp-login.php
)