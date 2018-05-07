#!/bin/bash

echo "push.sh started..."

time docker push thesheff17/docker_dev:latest-`date +"%m%d%Y"`

echo "push.sh completed."
