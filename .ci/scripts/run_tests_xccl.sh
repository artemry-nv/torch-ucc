#!/bin/bash -eEx

export LD_LIBRARY_PATH="${MPI_DIR}/lib:${MPI_DIR}/lib/openmpi:${LD_LIBRARY_PATH}"
export PATH="${MPI_DIR}/bin:${PATH}"
#command -v mpirun
export UCX_SOCKADDR_CM_ENABLE=n
#mpirun --oversubscribe -x XCCL_TEST_TLS=hier -np 8 -H localhost:8 --bind-to none -mca coll ^hcoll ${XCCL_SRC_DIR}/test/test_mpi_allreduce
#mpirun --oversubscribe -x XCCL_TEST_TLS=hier -np 8 -H localhost:8 --bind-to none -mca coll ^hcoll ${XCCL_SRC_DIR}/test/test_mpi_bcast
#mpirun --oversubscribe -x XCCL_TEST_TLS=hier -np 8 -H localhost:8 --bind-to none -mca coll ^hcoll ${XCCL_SRC_DIR}/test/test_mpi_barrier
#
#mpirun --oversubscribe -x XCCL_TEAM_HIER_NODE_LEADER_RANK_ID=3 -x XCCL_TEST_TLS=hier -np 8 -H localhost:8 --bind-to none -mca coll ^hcoll ${XCCL_SRC_DIR}/test/test_mpi_allreduce
#mpirun --oversubscribe -x XCCL_TEAM_HIER_NODE_LEADER_RANK_ID=4 -x XCCL_TEST_TLS=hier -np 8 -H localhost:8 --bind-to none -mca coll ^hcoll ${XCCL_SRC_DIR}/test/test_mpi_bcast
#mpirun --oversubscribe -x XCCL_TEAM_HIER_NODE_LEADER_RANK_ID=5 -x XCCL_TEST_TLS=hier -np 8 -H localhost:8 --bind-to none -mca coll ^hcoll ${XCCL_SRC_DIR}/test/test_mpi_barrier
#
#mpirun --oversubscribe -x XCCL_TEAM_UCX_ALLREDUCE_ALG_ID=0 -x XCCL_TEST_TLS=ucx -np 8 -H localhost:8 --bind-to none -mca coll ^hcoll ${XCCL_SRC_DIR}/test/test_mpi_allreduce
#mpirun --oversubscribe -x XCCL_TEAM_UCX_ALLREDUCE_ALG_ID=1 -x XCCL_TEST_TLS=ucx -np 8 -H localhost:8 --bind-to none -mca coll ^hcoll ${XCCL_SRC_DIR}/test/test_mpi_allreduce
#mpirun --oversubscribe -x XCCL_TEST_TLS=ucx -np 8 -H localhost:8 --bind-to none -mca coll ^hcoll ${XCCL_SRC_DIR}/test/test_mpi_bcast
#mpirun --oversubscribe -x XCCL_TEST_TLS=ucx -np 8 -H localhost:8 --bind-to none -mca coll ^hcoll ${XCCL_SRC_DIR}/test/test_mpi_barrier
#mpirun --oversubscribe -x XCCL_TEST_TLS=ucx -np 8 -H localhost:8 --bind-to none -mca coll ^hcoll ${XCCL_SRC_DIR}/test/test_mpi_alltoall
#mpirun --oversubscribe -x XCCL_TEST_TLS=ucx -np 8 -H localhost:8 --bind-to none -mca coll ^hcoll ${XCCL_SRC_DIR}/test/test_mpi_alltoallv
#mpirun --oversubscribe -x XCCL_TEST_TLS=ucx -np 8 -H localhost:8 --bind-to none -mca coll ^hcoll ${XCCL_SRC_DIR}/test/test_mpi_allgather
#mpirun -x XCCL_TEAM_UCX_ALLTOALL_PAIRWISE_CHUNK=0 --oversubscribe -x XCCL_TEST_TLS=ucx -np 8 -H localhost:8 --bind-to none -mca coll ^hcoll ${XCCL_SRC_DIR}/test/test_mpi_alltoall
#mpirun -x XCCL_TEAM_UCX_ALLTOALL_PAIRWISE_CHUNK=0 --oversubscribe -x XCCL_TEST_TLS=ucx -np 8 -H localhost:8 --bind-to none -mca coll ^hcoll ${XCCL_SRC_DIR}/test/test_mpi_alltoallv
#mpirun --oversubscribe -x XCCL_TEST_TLS=hier -x XCCL_TEST_ITERS=500  -x XCCL_TEST_NTHREADS=4 -x XCCL_TEST_CHECK=1 -np 8 -H localhost:8 --bind-to none -mca coll ^hcoll ${XCCL_SRC_DIR}/test/test_mpi_mt
