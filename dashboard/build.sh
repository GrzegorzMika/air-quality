#!/bin/bash

source ../credentials.sh
docker build --rm -t dashboard -f Dockerfile .
docker run -d \
          --network=host \
          -p 3838:3838 \
          -e MYSQL_USER=${DB_USER} \
          -e MYSQL_PASSWORD=${DB_PASSWORD} \
          -e MYSQL_HOST=${MYSQL_HOST} \
          dashboard
