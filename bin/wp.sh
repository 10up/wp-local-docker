#!/bin/bash

# Read user information from docker-compose.override.yml
source "$(dirname "$0")/wp_docker_user.sh";
WP_DOCKER_USER="$(wp_docker_user)";

docker-compose exec --user $WP_DOCKER_USER:www-data phpfpm wp "$@"