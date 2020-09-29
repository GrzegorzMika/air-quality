#!/bin/bash

docker volume create air_logs
docker build --rm -t air -f Dockerfile .
docker run -d \
        --privileged \
        --network=host \
        -v air_logs:/home/pi/logs \
        -e MYSQL_USER='grzegorz' \
        -e MYSQL_PASSWORD='loldupa77.' \
        -e MYSQL_HOST='192.168.1.100' \
        air