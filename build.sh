#!/bin/bash

echo "build.sh started..."

time docker build . -t thesheff17/docker_dev:latest

echo "build.sh completed."
