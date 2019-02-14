FROM ubuntu:18.04 as ubuntu
RUN apt-get update && apt-get install -y \
    vim
ENV export SINGULARITY_DOCKER_USERNAME='$oauthtoken'
ENV export SINGULARITY_DOCKER_PASSWORD=dG5zcmUyNWFsMWllMnRlaW12ZWFiaGhpazU6NmE5YzlmN2ItMGNiNi00MThlLWEyZmQtM2JlM2MzY2NhZWQy
FROM nvcr.io/hpc/candle:20180326 as candle
WORKDIR /opt
RUN rm candle_setup.sh
RUN echo "#!/bin/bash

pip install --upgrade pip
pip install keras && \
pip install -r /opt/pip-dependencies.txt && \
export PATH=/usr/bin:$PATH && \
export BUILD_DIR=/opt && \
cd $BUILD_DIR && \
rm -rf swift-t 2> /dev/null && \
apt-get update -y && \
apt-get install -y --no-install-recommends \
        autoconf \
    automake \
    default-jdk \
    git \
    ant \
    swig \
    zsh \
    tcl \
    tcl-dev \
    python-tk && \
" > candle_setup.sh