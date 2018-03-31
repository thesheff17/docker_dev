#!/bin/bash
echo "clean.sh started..."

docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi -f $(docker images -a -q)

docker ps -a
docker images

echo "clean.sh completed."
