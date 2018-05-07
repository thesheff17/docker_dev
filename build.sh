#!/bin/bash

echo "build.sh started..."

time docker build . -t thesheff17/docker_dev:latest-`date +"%m%d%Y"`

echo "build.sh completed."
