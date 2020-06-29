docker volume create air_logs
docker build --rm -t air -f Dockerfile .
docker run --privileged -d --network=host -v air_logs:/home/pi/logs air