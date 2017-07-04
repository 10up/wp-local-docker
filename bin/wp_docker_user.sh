#!/bin/bash
# helper function
# prints the username defined on docker-compose.override.yml
# used on wp.sh and setup.sh to define the container user
wp_docker_user() {
    echo "$(grep WP_DOCKER_USER docker-compose.override.yml | tr -d '[:space:]' | tr -d 'WP_DOCKER_USER:')"
}
