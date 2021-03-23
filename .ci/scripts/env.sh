#!/bin/bash -eEx

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd -P)"

# shellcheck disable=SC2034
DLRM_MODEL="small"

HOSTNAME=$(hostname -s)
export HOSTNAME
SRC_ROOT_DIR=$(cd "${SCRIPT_DIR}/../../" && pwd -P)
CONFIGS_DIR="${SRC_ROOT_DIR}/.ci/configs"
export HOSTFILE=${HOSTFILE:-${CONFIGS_DIR}/$HOSTNAME/hostfile.txt}

if [ ! -f "${HOSTFILE}" ]; then
    echo "ERROR: ${HOSTFILE} does not exist"
    exit 1
fi

# shellcheck disable=SC2002
HOSTS=$(cat "$HOSTFILE" | xargs | tr ' ' ',')
export HOSTS
NP=$(wc --lines "$HOSTFILE" | awk '{print $1}')
export NP

export MASTER_PORT="12346"
export DOCKER_SSH_PORT="12345"
