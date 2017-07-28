#!/bin/bash

# If there is valid user information, create a user with matching
# name and UID and add it to the www-data group
if [ ! -z ${WP_DOCKER_UID} ] && [ ! -z ${WP_DOCKER_USER} ]; then \
    useradd -s /bin/bash -u ${WP_DOCKER_UID} -G $(id -g www-data) ${WP_DOCKER_USER}; \
fi;

$(php-fpm);