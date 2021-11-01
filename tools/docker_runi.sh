#!/usr/bin/env bash

DOCKER_PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# RUN developping tools from docker
docker_cmd="docker run -it --rm -e PATH=$DOCKER_PATH:/home/rustenv/.cargo/bin -v $PWD:/home/rustenv/workdir -w /home/rustenv/workdir rustos"

$docker_cmd $@
