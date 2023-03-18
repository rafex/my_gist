#!/bin/bash

DOCKERFILE=Dockerfile_graalvm
SRC_PATH=/src
PATH_IN_DOCKER=/src2
NAME_BUILD=graalvm_example:v01

docker build . -t $NAME_BUILD -f $DOCKERFILE

docker run -it --rm --mount type=bind,source="$PWD"$SRC_PATH,target=$PATH_IN_DOCKER $NAME_BUILD bash
# docker run -it --rm $NAME_BUILD bash