#!/bin/bash

echo "build.sh started..."

docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi $(docker images -q)

docker build . -t thesheff17/docker_dev:`date +"%m%d%Y"`

echo "build.sh completed."
