#!/bin/bash
echo "clean.sh started..."

docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi $(docker images -a -q)

echo "clean.sh completed."
