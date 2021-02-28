#!/bin/bash -eEx
set -o pipefail

# Set environment variables used by PyTorch Distributed

###############
## Get Master address and port from SLURM.
##
## Note: It has to match the address of the rank that will become RANK=0 for PyTorch Distributed to work.
## TODO: allow getting these directly from OpenMPI in case we're not running under SLURM
##
if [ -z "${MASTER_ADDR:-}" ] && [ -n "${SLURM_NODELIST:-}" ]; then
    # 'hostlist' is from the python-hostlist package.  Could use scontrol
    # here, but it's not available inside the container.
    MASTER_ADDR="$(hostlist -l 1 "${SLURM_NODELIST}")"
    export MASTER_ADDR
fi

if [ -z "${MASTER_PORT:-}" ]; then
    MASTER_PORT="$(bash -c "echo $((${SLURM_JOB_ID:-4242} % 16384 + 49152))")"
    export MASTER_PORT
fi

## Get world size from OpenMPI or alternatively from SLURM
if [ -z "${WORLD_SIZE:-}" ]; then
    if [ -n "${OMPI_COMM_WORLD_SIZE:-}" ]; then
        export WORLD_SIZE="${OMPI_COMM_WORLD_SIZE}"
    elif [ -n "${SLURM_NTASKS:-}" ]; then
        export WORLD_SIZE="${SLURM_NTASKS}"
    fi
fi

## Get (global) process ID from OpenMPI or alternatively from SLURM
if [ -z "${RANK:-}" ]; then
    if [ -n "${OMPI_COMM_WORLD_RANK:-}" ]; then
        export RANK="${OMPI_COMM_WORLD_RANK}"
    elif [ -n "${SLURM_PROCID:-}" ]; then
        export RANK="${SLURM_PROCID}"
    fi
fi

## Get local process ID from OpenMPI or alternatively from SLURM
if [ -z "${LOCAL_RANK:-}" ]; then
    if [ -n "${OMPI_COMM_WORLD_LOCAL_RANK:-}" ]; then
        export LOCAL_RANK="${OMPI_COMM_WORLD_LOCAL_RANK}"
    elif [ -n "${SLURM_LOCALID:-}" ]; then
        export LOCAL_RANK="${SLURM_LOCALID}"
    fi
fi

## Get local size from OpenMPI or alternatively from SLURM
if [ -z "${LOCAL_SIZE:-}" ]; then
    if [ -n "${OMPI_COMM_WORLD_LOCAL_SIZE:-}" ]; then
        export LOCAL_SIZE="${OMPI_COMM_WORLD_LOCAL_SIZE}"
    elif [ -n "${SLURM_NTASKS_PER_NODE:-}" ]; then
        export LOCAL_SIZE="${SLURM_NTASKS_PER_NODE}"
    fi
fi
