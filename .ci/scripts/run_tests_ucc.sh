#!/bin/bash -eEx
set -o pipefail

UCC_SRC_DIR="${TORCH_UCC_SRC_DIR}/ucc"
cd "${UCC_SRC_DIR}/build"
make gtest
