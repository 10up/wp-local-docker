#!/bin/bash

docker-compose exec --user www-data phpfpm wp plugin install elasticpress --activate
docker-compose exec --user www-data phpfpm wp option set ep_host "http://docker-local.dev:$(docker-compose port elasticsearch 9200 | cut -f 2 -d ':')"
docker-compose exec --user www-data phpfpm wp elasticpress index
