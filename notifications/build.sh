#!/bin/bash

docker volume create air_logs
docker build --rm -t notifications -f Dockerfile .
docker run -d \
        --network=host \
        -v air_logs:/home/pi/logs \
        -e MYSQL_USER='grzegorz' \
        -e MYSQL_PASSWORD='loldupa77.' \
        -e MYSQL_HOST='192.168.1.101' \
        -e AIR_QUALITY_USER='bestiamalinowa@gmail.com' \
        -e AIR_QUALITY_PASSWORD='Ha1357end' \
        notifications