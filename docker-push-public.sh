#!/bin/bash
[ "$1" = -x ] && shift && set -x
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source ${DIR}/igd-utils-lib.sh

# Accept multiple tags as arguments
TAGS=("$@")

if [[ ${#TAGS[@]} -eq 0 ]]; then
  TAGS=("${IGD_UTILS_DOCKER_TAG}")
fi

set -e

# Tag and push each tag
for TAG in "${TAGS[@]}"; do
  LOCAL_DOCKER_IMG=${IGD_UTILS_DOCKER_IMG}:${TAG}
  REMOTE_DOCKER_IMG=idachev/k8s-utils:${TAG}

  echo "Tagging for public: ${REMOTE_DOCKER_IMG}"
  docker tag ${LOCAL_DOCKER_IMG} ${REMOTE_DOCKER_IMG}

  echo "Pushing: ${REMOTE_DOCKER_IMG}"
  docker push ${REMOTE_DOCKER_IMG}
done

echo "Push completed for tags: ${TAGS[*]}"
