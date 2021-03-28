#!/bin/bash -eEx
set -o pipefail

SCRIPT_DIR="$(
    cd "$(dirname "$0")"
    pwd -P
)"
cd "${SCRIPT_DIR}"
. "${SCRIPT_DIR}/env.sh"

TORCH_UCC_MODE="$1"
HOSTFILE="$2"

if [ "${TORCH_UCC_MODE}" != "ucc" ] && [ "${TORCH_UCC_MODE}" != "xccl" ]; then
    echo "ERROR: unsupported or empty TORCH_UCC_MODE (${TORCH_UCC_MODE}), supported values: ucc, xccl"
    exit 1
fi

if [ -z "$HOSTFILE" ]; then
    echo "ERROR: HOSTFILE is not specified"
    exit 1
fi

export PATH="/usr/lib64/openmpi/bin:$PATH"
export LD_LIBRARY_PATH="/usr/lib64/openmpi/lib:${LD_LIBRARY_PATH}"

HEAD_NODE=$(head -1 "$HOSTFILE")
export HEAD_NODE
export MASTER_ADDR=${HEAD_NODE}

NP=$(wc --lines "$HOSTFILE" | awk '{print $1}')

# shellcheck disable=SC2086
mpirun \
    -np $NP \
    --hostfile ${HOSTFILE} \
    --map-by node \
    --allow-run-as-root \
    --mca plm_rsh_args '-p 12345' \
    -x PATH \
    -x LD_LIBRARY_PATH \
    hostname

# shellcheck disable=SC2086
mpirun \
    -np $NP \
    --hostfile ${HOSTFILE} \
    --map-by node \
    --allow-run-as-root \
    --mca plm_rsh_args '-p 12345' \
    -x PATH \
    -x LD_LIBRARY_PATH \
    cat /proc/1/cgroup

# shellcheck disable=SC2086
mpirun \
    -np $NP \
    --hostfile ${HOSTFILE} \
    --map-by node \
    --allow-run-as-root \
    --mca plm_rsh_args '-p 12345' \
    -x PATH \
    -x LD_LIBRARY_PATH \
    -x MASTER_ADDR \
    -x TORCH_UCC_MODE \
    /opt/nvidia/torch-ucc/src/.ci/scripts/run_dlrm_s_pytorch.sh

#ssh -p 12345 swx-clx01 /opt/nvidia/torch-ucc/src/.ci/scripts/run_dlrm_s_pytorch.sh

#mpirun ${MPIRUN_OPTIONS} python dlrm_s_pytorch.py \
#    --mini-batch-size=2048 \
#    --test-mini-batch-size=16384 \
#    --test-num-workers=0 \
#    --num-batches=100 \
#    --data-generation=random \
#    --arch-mlp-bot=$bot_mlp \
#    --arch-mlp-top=$top_mlp \
#    --arch-sparse-feature-size=$emb_dim \
#    --arch-embedding-size=$emb_size \
#    --num-indices-per-lookup=$emb_lookup \
#    --num-indices-per-lookup-fixed=$emb_lookup_fixed \
#    --arch-interaction-op=dot \
#    --numpy-rand-seed=727 \
#    --print-freq=1 \
#    --loss-function=$loss_func \
#    --round-targets=$round_targets \
#    --learning-rate=$lr \
#    --print-time \
#    --dist-backend=ucc \
#    --use-gpu
