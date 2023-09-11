#!/bin/bash
[ "$1" = -x ] && shift && set -x
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source ${DIR}/igd-utils-lib.sh

if [[ -z "${POD_NAME}" ]]; then
  POD_NAME=${IGD_UTILS_POD_NAME}
fi

kubectl run ${POD_NAME} --labels="name=${POD_NAME}" \
  --image=${IGD_UTILS_DOCKER_REMOTE_REGISTRY}/${IGD_UTILS_DOCKER_IMG}:${IGD_UTILS_DOCKER_TAG} \
  --image-pull-policy=Always
