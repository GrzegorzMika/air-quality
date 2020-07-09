docker build --rm -t dashboard -f Dockerfile .
docker run -d \
          --network=host \
          -p 3838:3838 \
          -e MYSQL_USER='dashboard' \
          -e MYSQL_PASSWORD='dashboard' \
          -e MYSQL_HOST='192.168.1.103' \
          dashboard
