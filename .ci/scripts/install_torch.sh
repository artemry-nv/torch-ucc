#!/bin/bash -eEx
set -o pipefail

# TODO debug
#cd /tmp
#git clone https://github.com/pytorch/pytorch.git
#cd /tmp/pytorch
#git submodule sync --recursive
#git submodule update --init --recursive
#pip install -r requirements.txt
#export TORCH_CUDA_ARCH_LIST="7.0 8.0+PTX"
#export USE_GLOO=1
#export USE_DISTRIBUTED=1
#export USE_OPENCV=0
## TODO debug
#export USE_CUDA=1
##export USE_CUDA=0
#export USE_NCCL=0
#export USE_MKLDNN=0
#export BUILD_TEST=0
#export USE_FBGEMM=0
#export USE_NNPACK=0
#export USE_QNNPACK=0
#export USE_XNNPACK=0
#export USE_KINETO=1
#export MAX_JOBS=$(($(nproc)-1))
#python setup.py install
#rm -rf /tmp/pytorch

# TODO debug
#conda install -y pytorch torchvision cpuonly -c pytorch-nightly
#conda install pytorch torchvision torchaudio cudatoolkit=11.0 -c pytorch-nightly
#conda uninstall -y pytorch torchvision
#conda install pytorch torchvision cudatoolkit=11.0 -c pytorch-nightly
#conda install pytorch cudatoolkit=11.0 -c pytorch-nightly
pip install --default-timeout=900 numpy
pip install --default-timeout=900 --pre torch -f https://download.pytorch.org/whl/nightly/cu110/torch_nightly.html
