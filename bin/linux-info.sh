#!/bin/bash

echo "Your current user is $USER and your current user ID is $(id -u $USER)";
#WWWDATAID=$(docker-compose exec --user root phpfpm bash -c "id -g www-data");
#echo "The www-data folder inside the container has the ID $WWWDATAID";
