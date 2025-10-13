#!/bin/bash
[ "$1" = -x ] && shift && set -x
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source ${DIR}/igd-utils-lib.sh

if [[ -z "${POD_NAME}" ]]; then
  POD_NAME=${IGD_UTILS_POD_NAME}
fi

# Default proxy port
PROXY_PORT=${1:-8888}
LOCAL_PORT=${2:-${PROXY_PORT}}

echo "=========================================="
echo "Setting up HTTP proxy through pod ${POD_NAME}"
echo "Proxy port in pod: ${PROXY_PORT}"
echo "Local port: ${LOCAL_PORT}"
echo "=========================================="
echo ""

# Check if tinyproxy is already running
echo "Checking if tinyproxy is already running..."
PROXY_RUNNING=$(kubectl exec "${POD_NAME}" -c "${POD_NAME}" -- bash -c "pgrep tinyproxy" 2>/dev/null)

if [[ -n "${PROXY_RUNNING}" ]]; then
  echo "Tinyproxy is already running (PID: ${PROXY_RUNNING})"
else
  echo "Starting tinyproxy in the background..."
  kubectl exec "${POD_NAME}" -c "${POD_NAME}" -- bash -c "nohup tinyproxy > /tmp/tinyproxy.log 2>&1 &"
  sleep 2

  # Verify it started
  PROXY_RUNNING=$(kubectl exec "${POD_NAME}" -c "${POD_NAME}" -- bash -c "pgrep tinyproxy" 2>/dev/null)
  if [[ -n "${PROXY_RUNNING}" ]]; then
    echo "Tinyproxy started successfully (PID: ${PROXY_RUNNING})"
  else
    echo "Failed to start tinyproxy. Check logs with:"
    echo "  kubectl exec ${POD_NAME} -c ${POD_NAME} -- cat /tmp/tinyproxy.log"
    exit 1
  fi
fi

echo ""
echo "Setting up port forwarding: localhost:${LOCAL_PORT} -> pod:${PROXY_PORT}"
echo ""
echo "To use this proxy, configure your HTTP client:"
echo "  export http_proxy=http://localhost:${LOCAL_PORT}"
echo "  export https_proxy=http://localhost:${LOCAL_PORT}"
echo ""
echo "Or use with curl:"
echo "  curl -x http://localhost:${LOCAL_PORT} https://example.com"
echo ""
echo "Press Ctrl+C to stop port forwarding"
echo "=========================================="
echo ""

kubectl port-forward "${POD_NAME}" "${LOCAL_PORT}:${PROXY_PORT}"
