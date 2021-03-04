#!/bin/bash -eEx
set -o pipefail

# TODO debug
exit 0

SCRIPT_DIR="$(
    cd "$(dirname "$0")"
    pwd -P
)"
cd "${SCRIPT_DIR}"
. "${SCRIPT_DIR}/set-env-dist.sh"

index=$LOCAL_RANK
export OMPI_COMM_WORLD_SIZE=$WORLD_SIZE
export OMPI_COMM_WORLD_LOCAL_SIZE=$LOCAL_SIZE
export OMPI_COMM_WORLD_RANK=$RANK
export OMPI_COMM_WORLD_LOCAL_RANK=$LOCAL_RANK

case $index in
"0")
    export UCX_NET_DEVICES=mlx5_0:1
    NUMA="numactl --physcpubind=48-63 --membind=3 "
    ;;
"1")
    export UCX_NET_DEVICES=mlx5_1:1
    NUMA="numactl --physcpubind=48-63 --membind=3 "
    ;;
"2")
    export UCX_NET_DEVICES=mlx5_2:1
    NUMA="numactl --physcpubind=16-31 --membind=1 "
    ;;
"3")
    export UCX_NET_DEVICES=mlx5_3:1
    NUMA="numactl --physcpubind=16-31 --membind=1 "
    ;;
"4")
    export UCX_NET_DEVICES=mlx5_6:1
    NUMA="numactl --physcpubind=112-127 --membind=7 "
    ;;
"5")
    export UCX_NET_DEVICES=mlx5_7:1
    NUMA="numactl --physcpubind=112-127 --membind=7 "
    ;;
"6")
    export UCX_NET_DEVICES=mlx5_8:1
    NUMA="numactl --physcpubind=80-95 --membind=5 "
    ;;
"7")
    export UCX_NET_DEVICES=mlx5_9:1
    NUMA="numactl --physcpubind=80-95 --membind=5 "
    ;;
esac

export XCCL_TEAM_UCX_NET_DEVICES=$UCX_NET_DEVICES
export XCCL_TEAM_HIER_NET_DEVICES=$UCX_NET_DEVICES

if [ "$DLRM_MODEL" = "big" ]; then
    emb_size="1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000-1000"
    emb_dim="256"
    emb_lookup="100"
    bot_mlp="512-512-256"
    top_mlp="1024-1024-1024-1"
    loss_func="mse"
    round_targets="False"
    lr="0.01"
    #mb_size="2048"
    emb_lookup_fixed="0"
elif [ "$DLRM_MODEL" = "small" ]; then
    emb_size="1000-1000-1000-1000-1000-1000-1000-1000"
    emb_dim="64"
    emb_lookup="100"
    bot_mlp="512-512-64"
    top_mlp="1024-1024-1024-1"
    loss_func="mse"
    round_targets="False"
    lr="0.01"
    #mb_size="2048"
    emb_lookup_fixed="0"
fi

if [ "$OMPI_COMM_WORLD_RANK" = "1" ]; then
    echo "MODEL: $DLRM_MODEL"
fi

$NUMA python dlrm_s_pytorch.py \
    --mini-batch-size=2048 \
    --test-mini-batch-size=16384 \
    --test-num-workers=0 \
    --num-batches=100 \
    --data-generation=random \
    --arch-mlp-bot=$bot_mlp \
    --arch-mlp-top=$top_mlp \
    --arch-sparse-feature-size=$emb_dim \
    --arch-embedding-size=$emb_size \
    --num-indices-per-lookup=$emb_lookup \
    --num-indices-per-lookup-fixed=$emb_lookup_fixed \
    --arch-interaction-op=dot \
    --numpy-rand-seed=727 \
    --print-freq=1 \
    --loss-function=$loss_func \
    --round-targets=$round_targets \
    --learning-rate=$lr \
    --print-time "$@"
