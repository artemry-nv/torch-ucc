#!/bin/bash -eEx
set -o pipefail

SCRIPT_DIR="$(
    cd "$(dirname "$0")"
    pwd -P
)"
cd "${SCRIPT_DIR}"
. "${SCRIPT_DIR}/env.sh"

DOCKER_SSH_PORT="12345"
DOCKER_CONTAINER_NAME="torch_ucc_ci"
# TODO debug
#DOCKER_IMAGE_NAME="${TORCH_UCC_DOCKER_IMAGE_NAME}:${BUILD_ID}"
DOCKER_IMAGE_NAME="harbor.mellanox.com/torch-ucc/0.1.0/x86_64/centos8/cuda11.2.1:175"

DOCKER_RUN_ARGS="\
--pull always \
--network=host \
--uts=host \
--ipc=host \
--ulimit stack=67108864 \
--ulimit memlock=-1 \
--security-opt seccomp=unconfined \
--cap-add=SYS_ADMIN \
--device=/dev/infiniband/ \
--gpus all \
--user root \
-it \
-d \
--rm \
--name=${DOCKER_CONTAINER_NAME} \
-v /labhome:/labhome \
-v /root/.ssh:/root/.ssh \
-p 12345:12345 \
"

while read -r HOST; do
    echo "INFO: HOST = $HOST"
    STALE_DOCKER_CONTAINER_LIST=$(sudo ssh "$HOST" "docker ps -a -q -f name=${DOCKER_CONTAINER_NAME}")
    if [ -n "${STALE_DOCKER_CONTAINER_LIST}" ]; then
        echo "WARNING: stale docker container (name: ${DOCKER_CONTAINER_NAME}) is detected on ${HOST} (to be stopped)"
        echo "INFO: Stopping stale docker container (name: ${DOCKER_CONTAINER_NAME}) on ${HOST}..."
        sudo ssh "${HOST}" docker stop ${DOCKER_CONTAINER_NAME}
        echo "INFO: Stopping stale docker container (name: ${DOCKER_CONTAINER_NAME}) on ${HOST}... DONE"
    fi

    echo "INFO: start docker container on $HOST ..."
    sudo ssh "$HOST" "docker run \
        ${DOCKER_RUN_ARGS} \
        ${DOCKER_IMAGE_NAME} \
        bash -c '/usr/sbin/sshd -p ${DOCKER_SSH_PORT}; sleep infinity'"
    echo "INFO: start docker container on $HOST ... DONE"

    echo "INFO: verify docker container on $HOST ..."
    sudo ssh "$HOST" -p ${DOCKER_SSH_PORT} hostname
    echo "INFO: verify docker container on $HOST ... DONE"
done <"$HOSTFILE"

sleep 20000

while read -r HOST; do
    echo "INFO: stop docker container on $HOST ..."
    sudo ssh "${HOST}" docker stop ${DOCKER_CONTAINER_NAME}
    echo "INFO: stop docker container on $HOST ... DONE"
done <"$HOSTFILE"