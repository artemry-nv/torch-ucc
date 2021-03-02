#!/bin/bash -eEx
set -o pipefail

# Install conda
curl -LO http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -p /opt/conda -b
rm -f Miniconda3-latest-Linux-x86_64.sh
export PATH=/opt/conda/bin:${PATH}
# Install conda python
conda update -y conda
conda install -c anaconda -y \
    python \
    pip \
    setuptools \
    wheel
#pip install --no-cache-dir python-hostlist
ln -s /opt/conda/bin/python /usr/bin/python
#python3 -m pip install --user --upgrade setuptools wheel auditwheel check-wheel-contents
#python3 -m pip install --user --upgrade setuptools wheel
