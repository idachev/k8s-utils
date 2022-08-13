#!/bin/bash
[ "$1" = -x ] && shift && set -x
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source ${DIR}/.env

if [[ -z "${IGD_UTILS_DOCKER_IMG}" ]]; then
  >&2 echo "Missing IGD_UTILS_DOCKER_IMG check .env and .env-template"
  exit 1
fi

if [[ -z "${IGD_UTILS_DOCKER_REMOTE_REGISTRY}" ]]; then
  >&2 echo "Missing IGD_UTILS_DOCKER_REMOTE_REGISTRY check .env and .env-template"
  exit 1
fi

if [[ -z "${IGD_UTILS_POD_NAME}" ]]; then
  >&2 echo "Missing IGD_UTILS_POD_NAME check .env and .env-template"
  exit 1
fi
