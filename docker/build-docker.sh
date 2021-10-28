#!/bin/bash

DOCKER_IMAGE_NAME=${1:-"rustos-builder"}
# Build the docker image
docker build -t $DOCKER_IMAGE_NAME .
