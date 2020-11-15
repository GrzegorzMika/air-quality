#!/bin/bash

source ../credentials.sh
docker volume create air_logs
docker build --rm -t air -f Dockerfile .
docker run -d \
        --privileged \
        --network=host \
        -v air_logs:/home/pi/logs \
        -e MYSQL_USER=${MYSQL_USER} \
        -e MYSQL_PASSWORD=${MYSQL_PASSWORD} \
        -e MYSQL_HOST=${MYSQL_HOST} \
        air