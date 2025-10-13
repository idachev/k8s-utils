#!/bin/bash
[ "$1" = -x ] && shift && set -x
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source ${DIR}/igd-utils-lib.sh

# Accept multiple tags as arguments
TAGS=("$@")

if [[ ${#TAGS[@]} -eq 0 ]]; then
  TAGS=("${IGD_UTILS_DOCKER_TAG}")
fi

# Use first tag for initial build
FIRST_TAG="${TAGS[0]}"
LOCAL_DOCKER_IMG=${IGD_UTILS_DOCKER_IMG}:${FIRST_TAG}

set -e

GIT_SHA=$(git rev-parse --short HEAD)
DATE_TIME=$(date -u +"%Y-%m-%dT%H:%M:%S-%N")

echo "${GIT_SHA}-${DATE_TIME}" > version.txt

# Build with first tag
echo "Building image: ${LOCAL_DOCKER_IMG}"
docker build -t ${LOCAL_DOCKER_IMG} .

# Tag with additional tags
for ((i=1; i<${#TAGS[@]}; i++)); do
  ADDITIONAL_TAG="${TAGS[$i]}"
  ADDITIONAL_IMG="${IGD_UTILS_DOCKER_IMG}:${ADDITIONAL_TAG}"
  echo "Tagging image: ${ADDITIONAL_IMG}"
  docker tag ${LOCAL_DOCKER_IMG} ${ADDITIONAL_IMG}
done

echo "Build completed with tags: ${TAGS[*]}"
