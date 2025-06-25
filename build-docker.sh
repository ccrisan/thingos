#!/bin/bash

DOCKER_BUILDER_IMAGE="ccrisan/thingos-builder"
ENV_FILE=$(mktemp)

function cleanup() {
    rm -f ${ENV_FILE}
}

trap cleanup EXIT

cd $(dirname "$0")
printenv | grep -E ^THINGOS > ${ENV_FILE}

args="${@}"
docker run --privileged -it --rm -u $(id -u):$(id -g) \
       -v "$(pwd)":/os \
       -e TB_CUSTOM_CMD="./build.sh ${args}" \
       --env-file ${ENV_FILE} \
       "${DOCKER_BUILDER_IMAGE}"
