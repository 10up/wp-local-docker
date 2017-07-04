#!/bin/bash

source "$(dirname "$0")/wp_docker_user.sh";
WP_DOCKER_USER="$(wp_docker_user)";

if [ -z $WP_DOCKER_USER ]; then
  WP_DOCKER_USER="www-data"
fi;

docker-compose exec --user $WP_DOCKER_USER:www-data phpfpm wp "$@"