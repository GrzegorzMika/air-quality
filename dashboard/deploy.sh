docker build --rm -t dashboard_new -f Dockerfile .
docker run \
          --network=host \
          -p 3839:3839 \
          -e MYSQL_USER='dashboard' \
          -e MYSQL_PASSWORD='dashboard' \
          -e MYSQL_HOST='192.168.1.103' \
          dashboard_new
