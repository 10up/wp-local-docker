@echo off

docker-compose exec --user www-data wpsnapshots wp %*
