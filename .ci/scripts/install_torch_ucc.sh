#!/bin/bash -eEx
set -o pipefail

# UCC
echo "INFO: Install Torch-UCC (UCC version)"
export UCX_HOME=${UCX_INSTALL_DIR}
export UCC_HOME=${UCC_INSTALL_DIR}
export WITH_CUDA=${CUDA_HOME}
cd "${TORCH_UCC_SRC_DIR}"
python setup.py install bdist_wheel
pip3 list | grep torch
python -c 'import torch, torch_ucc'
cp "${TORCH_UCC_SRC_DIR}/dist/"*.whl "${TORCH_UCC_BIN_DIR}"
