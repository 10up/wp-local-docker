#!/bin/bash
# helper function
# prints the username defined on docker-compose.override.yml
# used on wp.sh and setup.sh to define the container user
wp_docker_user() {
    # move into the root folder
    called_path=$('pwd')
    parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")"; pwd -P )
    cd "$parent_path"
    cd ..

    # read user from file
    if [ -f docker-compose.override.yml ]; then
        WP_DOCKER_USER="$(grep WP_DOCKER_USER docker-compose.override.yml | tr -d '[:space:]' | tr -d 'WP_DOCKER_USER:')"

        # If the information is invalid or non-existent, fallback to the www-data user
        if [ -z $WP_DOCKER_USER ]; then
          WP_DOCKER_USER="www-data"
        fi;
    else
        WP_DOCKER_USER="www-data"
    fi;

    echo $WP_DOCKER_USER

    # move back where called
    cd "$called_path"
}
