@echo off

if exist "./wordpress/wp-config.php" (
	echo "WordPress config file found."
) else (
	echo "WordPress config file not found. Installing..."
	docker-compose exec --user www-data phpfpm wp core download
	docker-compose exec --user www-data phpfpm wp core config --dbhost=mysql --dbname=wordpress --dbuser=root --dbpass=password

	REM Install WordPress
	docker-compose exec --user www-data phpfpm wp db create
	docker-compose exec --user www-data phpfpm wp core install --url=localhost --prompt=title,admin_user,admin_email

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
	docker-compose exec --user www-data phpfpm wp plugin install developer

	echo "Installation done."
	start "" http://localhost/wp-login.php
)