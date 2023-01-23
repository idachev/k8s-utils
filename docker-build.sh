#!/bin/bash
[ "$1" = -x ] && shift && set -x
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source ${DIR}/igd-utils-lib.sh

TAG=$1

if [[ -z "${TAG}" ]]; then
  TAG=${IGD_UTILS_DOCKER_TAG}
fi

LOCAL_DOCKER_IMG=${IGD_UTILS_DOCKER_IMG}:${TAG}

set -e

GIT_SHA=$(git rev-parse --short HEAD)
DATE_TIME=$(date -u +"%Y-%m-%dT%H:%M:%S-%N")

echo "${GIT_SHA}-${DATE_TIME}" > version.txt

docker build -t ${LOCAL_DOCKER_IMG} .

# date and time in env with nanoseconds
DATE_TIME=

