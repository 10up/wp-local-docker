@echo off

docker-compose exec --user www-data phpfpm wp plugin install elasticpress --activate
FOR /F "tokens=1,2 delims=/" %a IN ("docker-compose port elasticsearch 9200") DO set ip=%a&set port=%b
set "host=http://docker-local.dev:%port%"
docker-compose exec --user www-data phpfpm wp option set ep_host "%host%"
docker-compose exec --user www-data phpfpm wp elasticpress index