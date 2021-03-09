#!/bin/bash -eEx
set -o pipefail

SCRIPT_DIR="$(
    cd "$(dirname "$0")"
    pwd -P
)"
cd "${SCRIPT_DIR}"
. "${SCRIPT_DIR}/env.sh"

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
"
DOCKER_SSH_PORT="12345"
DOCKER_CONTAINER_NAME="torch_ucc_ci"
DOCKER_IMAGE_NAME=""

while read -r HOST; do
    echo "INFO: HOST = $HOST"
    STALE_DOCKER_CONTAINER_LIST=$(sudo ssh $CUR_HOST "docker ps -a -q -f name=${DOCKER_CONTAINER_NAME}")
    if [ -n "${STALE_DOCKER_CONTAINER_LIST}" ]
    then
        echo "WARNING: stale docker container (name: ${DOCKER_CONTAINER_NAME}) is detected on ${HOST} (to be stopped)"
        echo "INFO: Stopping stale docker container (name: ${DOCKER_CONTAINER_NAME}) on ${HOST}..."
        sudo ssh "${HOST}" docker stop ${DOCKER_CONTAINER_NAME}
        echo "INFO: Stopping stale docker container (name: ${DOCKER_CONTAINER_NAME}) on ${HOST}... DONE"
    fi

    sudo ssh "$HOST" "docker run \
        ${DOCKER_RUN_ARGS} \
        ${DOCKER_IMAGE_NAME} \
        bash -c "/usr/sbin/sshd -p ${DOCKER_SSH_PORT}; sleep infinity""
done < "$HOSTFILE"
