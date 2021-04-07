#!/bin/bash -eEx
set -o pipefail

command -v mpirun
export UCX_WARN_UNUSED_ENV_VARS=n
ucx_info -e -u t

#==============================================================================
# CPU
#==============================================================================
echo "INFO: UCC barrier (CPU)"
/bin/bash ${TORCH_UCC_SRC_DIR}/test/start_test.sh ${TORCH_UCC_SRC_DIR}/test/torch_barrier_test.py --backend=gloo

echo "INFO: UCC alltoall (CPU)"
/bin/bash ${TORCH_UCC_SRC_DIR}/test/start_test.sh ${TORCH_UCC_SRC_DIR}/test/torch_alltoall_test.py --backend=gloo

echo "INFO: UCC alltoallv (CPU)"
/bin/bash ${TORCH_UCC_SRC_DIR}/test/start_test.sh ${TORCH_UCC_SRC_DIR}/test/torch_alltoallv_test.py --backend=gloo

echo "INFO: UCC allgather (CPU)"
/bin/bash ${TORCH_UCC_SRC_DIR}/test/start_test.sh ${TORCH_UCC_SRC_DIR}/test/torch_allgather_test.py --backend=gloo

echo "INFO: UCC allreduce (CPU)"
/bin/bash ${TORCH_UCC_SRC_DIR}/test/start_test.sh ${TORCH_UCC_SRC_DIR}/test/torch_allreduce_test.py --backend=gloo

echo "INFO: UCC broadcast (CPU)"
/bin/bash ${TORCH_UCC_SRC_DIR}/test/start_test.sh ${TORCH_UCC_SRC_DIR}/test/torch_bcast_test.py --backend=gloo
#==============================================================================
# GPU with NCCL
#==============================================================================
export UCX_IB_GID_INDEX=1

echo "INFO: UCC barrier (GPU with NCCL)"
/bin/bash ${TORCH_UCC_SRC_DIR}/test/start_test.sh ${TORCH_UCC_SRC_DIR}/test/torch_barrier_test.py --backend=gloo --use-cuda

echo "INFO: UCC alltoall (GPU with NCCL)"
/bin/bash ${TORCH_UCC_SRC_DIR}/test/start_test.sh ${TORCH_UCC_SRC_DIR}/test/torch_alltoall_test.py --backend=gloo --use-cuda

echo "INFO: UCC alltoallv (GPU with NCCL)"
/bin/bash ${TORCH_UCC_SRC_DIR}/test/start_test.sh ${TORCH_UCC_SRC_DIR}/test/torch_alltoallv_test.py --backend=gloo --use-cuda

echo "INFO: UCC allgather (GPU with NCCL)"
/bin/bash ${TORCH_UCC_SRC_DIR}/test/start_test.sh ${TORCH_UCC_SRC_DIR}/test/torch_allgather_test.py --backend=gloo --use-cuda

echo "INFO: UCC allreduce (GPU with NCCL)"
/bin/bash ${TORCH_UCC_SRC_DIR}/test/start_test.sh ${TORCH_UCC_SRC_DIR}/test/torch_allreduce_test.py --backend=gloo --use-cuda

echo "INFO: UCC broadcast (GPU with NCCL)"
/bin/bash ${TORCH_UCC_SRC_DIR}/test/start_test.sh ${TORCH_UCC_SRC_DIR}/test/torch_bcast_test.py --backend=gloo --use-cuda

unset UCX_IB_GID_INDEX
#==============================================================================
# GPU without NCCL
#==============================================================================
export UCC_TL_NCCL_COLL_SCORE=0
export UCX_IB_GID_INDEX=1

echo "INFO: UCC barrier (GPU without NCCL)"
/bin/bash ${TORCH_UCC_SRC_DIR}/test/start_test.sh ${TORCH_UCC_SRC_DIR}/test/torch_barrier_test.py --backend=gloo --use-cuda

echo "INFO: UCC alltoall (GPU without NCCL)"
/bin/bash ${TORCH_UCC_SRC_DIR}/test/start_test.sh ${TORCH_UCC_SRC_DIR}/test/torch_alltoall_test.py --backend=gloo --use-cuda

echo "INFO: UCC alltoallv (GPU without NCCL)"
/bin/bash ${TORCH_UCC_SRC_DIR}/test/start_test.sh ${TORCH_UCC_SRC_DIR}/test/torch_alltoallv_test.py --backend=gloo --use-cuda

echo "INFO: UCC allgather (GPU without NCCL)"
/bin/bash ${TORCH_UCC_SRC_DIR}/test/start_test.sh ${TORCH_UCC_SRC_DIR}/test/torch_allgather_test.py --backend=gloo --use-cuda

echo "INFO: UCC allreduce (GPU without NCCL)"
/bin/bash ${TORCH_UCC_SRC_DIR}/test/start_test.sh ${TORCH_UCC_SRC_DIR}/test/torch_allreduce_test.py --backend=gloo --use-cuda

echo "INFO: UCC broadcast (GPU without NCCL)"
/bin/bash ${TORCH_UCC_SRC_DIR}/test/start_test.sh ${TORCH_UCC_SRC_DIR}/test/torch_bcast_test.py --backend=gloo --use-cuda

unset UCC_TL_NCCL_COLL_SCORE
unset UCX_IB_GID_INDEX
#==============================================================================
