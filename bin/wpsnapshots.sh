#!/bin/bash

docker-compose -f wpsnapshots-compose.yml run --rm wpsnapshots /snapshots.sh "$@"
