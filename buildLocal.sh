#!/bin/bash

echo "build.sh started..."

docker stop $(docker ps | grep docker_dev* | cut -f1 -d" ")
docker rm $(docker ps | grep docker_dev* | cut -f1 -d" ")
docker rmi $(docker images | grep "docker_dev" | awk "{print \$3}")

time docker build -f  Dockerfile-local . -t thesheff17/docker_dev-local:`date +"%m%d%Y"`

echo "build.sh completed."
