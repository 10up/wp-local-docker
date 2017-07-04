#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")"; pwd -p )

cd "$parent_path"

if [ ! -f docker-compose.override.yml ]; then

echo "version: '3'
services:
  phpfpm:
    build:
      args:
        WP_DOCKER_USER: $USER
        WP_DOCKER_UID: $(id -u $USER)" | dd of=docker-compose.override.yml;

echo "docker-compose.override.yml file created";

else

echo "to configure wp-local-docker on a linux host, modify your docker-compose.override.yml file to include this bit:";

echo "
phpfpm:
  build:
    args:
      WP_DOCKER_USER: $USER
      WP_DOCKER_UID: $(id -u $USER)";

fi;

