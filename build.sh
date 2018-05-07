#!/bin/bash

echo "build.sh started..."

time docker build --build-arg CHANGEDATE=`date +"%m%d%Y"` . -t thesheff17/docker_dev:latest-`date +"%m%d%Y"`

echo "build.sh completed."
