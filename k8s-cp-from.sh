#!/bin/bash
[ "$1" = -x ] && shift && set -x
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source ${DIR}/igd-utils-lib.sh

if [[ -z "${POD_NAME}" ]]; then
  POD_NAME=${IGD_UTILS_POD_NAME}
fi

# Remove ./ prefix from remote path if present
REMOTE_PATH="${1#./}"

kubectl cp "${POD_NAME}:${REMOTE_PATH}" ${2}
