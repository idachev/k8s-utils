#!/bin/bash
[ "$1" = -x ] && shift && set -x
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source ${DIR}/igd-utils-lib.sh

POD_NAME=$1

if [[ -z "${POD_NAME}" ]]; then
  POD_NAME=${IGD_UTILS_POD_NAME}
fi

kubectl run ${POD_NAME} --labels="name=${POD_NAME}" \
  --image=idachev/k8s-utils:${IGD_UTILS_DOCKER_TAG}
