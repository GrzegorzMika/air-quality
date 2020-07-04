docker build --rm -t dashboard -f Dockerfile .
docker run -d --network=host -p 3838:3838 dashboard