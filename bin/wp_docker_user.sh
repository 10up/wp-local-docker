#!/bin/bash
# reads the username defined on docker-compose.override.yml
wp_docker_user() {
    echo "$(grep WP_DOCKER_USER docker-compose.override.yml | tr -d '[:space:]' | tr -d 'WP_DOCKER_USER:')"
}
