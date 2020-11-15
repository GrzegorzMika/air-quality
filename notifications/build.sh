#!/bin/bash

source ../credentials.sh
docker volume create air_logs
docker build --rm -t notifications -f Dockerfile .
docker run -d \
        --network=host \
        -v air_logs:/home/pi/logs \
        -e MYSQL_USER=${MYSQL_USER} \
        -e MYSQL_PASSWORD=${MYSQL_PASSWORD} \
        -e MYSQL_HOST=${MYSQL_HOST} \
        -e AIR_QUALITY_USER=${AIR_QUALITY_USER} \
        -e AIR_QUALITY_PASSWORD=${AIR_QUALITY_PASSWORD} \
        notifications