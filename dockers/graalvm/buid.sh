#!/bin/bash

DOCKERFILE=Dockerfile_graalvm
SRC_PATH=/home/rafex/github/gist/dockers/graalvm/src
PATH_IN_DOCKER=/usr/src/graalvmExample
NAME_VOLUME=graalvm-example

docker build . -t graalvm_example:v01 -f $DOCKERFILE

docker run -it --rm --mount type=bind,source=$SRC_PATH,target=$PATH_IN_DOCKER $NAME_VOLUME