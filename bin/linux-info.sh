#!/bin/bash
# move into the bin folder
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")"; pwd -P )
cd "$parent_path"

# export the current username and uid, we'll need them
export WP_DOCKER_USER=$USER
export WP_DOCKER_UID=$(id -u $USER)

# If docker-compose.override.yml does not exist, create it
# with the build arguments.
# If the file already exists print the needed arguments so
# the user can update it properly.
if [ ! -f ../docker-compose.override.yml ]; then

echo "version: '3'
services:
  phpfpm:
    build:
      args:
        WP_DOCKER_USER: $WP_DOCKER_USER
        WP_DOCKER_UID: $WP_DOCKER_UID" | dd of=../docker-compose.override.yml;

echo "The docker-compose.override.yml file was created";

else

echo "It looks like you already have a docker-compose.override.yml file.
To configure wp-local-docker properly on a linux host, please modify it
to include these instructions:";

echo "phpfpm:
  build:
    args:
      WP_DOCKER_USER: $WP_DOCKER_USER
      WP_DOCKER_UID: $WP_DOCKER_UID";

fi;

# move back where we were
cd -

