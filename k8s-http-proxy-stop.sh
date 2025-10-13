#!/bin/bash
[ "$1" = -x ] && shift && set -x
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source ${DIR}/igd-utils-lib.sh

if [[ -z "${POD_NAME}" ]]; then
  POD_NAME=${IGD_UTILS_POD_NAME}
fi

echo "Stopping tinyproxy in pod ${POD_NAME}..."
kubectl exec "${POD_NAME}" -c "${POD_NAME}" -- bash -c "pkill tinyproxy"

if [ $? -eq 0 ]; then
  echo "Tinyproxy stopped successfully"
else
  echo "Failed to stop tinyproxy (it may not be running)"
fi
