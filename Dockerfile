FROM centos:6 as os
RUN yum update && yum install -y \
    vim
ENV export SINGULARITY_DOCKER_USERNAME='$oauthtoken'
ENV export SINGULARITY_DOCKER_PASSWORD=dG5zcmUyNWFsMWllMnRlaW12ZWFiaGhpazU6NmE5YzlmN2ItMGNiNi00MThlLWEyZmQtM2JlM2MzY2NhZWQy
FROM nvcr.io/hpc/candle:20180326 as candle
WORKDIR /opt
RUN rm candle_setup.sh
RUN printf " #!/bin/bash 
\npip install --upgrade pip \
\npip install keras && \
\npip install -r /opt/pip-dependencies.txt && \
\nexport PATH=/usr/bin:$PATH && \
\nexport BUILD_DIR=/opt && \
\ncd $BUILD_DIR && \
\nrm -rf swift-t 2> /dev/null && \
\napt-get update -y && \
\napt-get install -y --no-install-recommends \
        \nautoconf \
    \nautomake \
    \ndefault-jdk \
    \ngit \
    \nant \
    \nswig \
    \nzsh \
    \ntcl \
    \ntcl-dev \
    \npython-tk\n
" > candle_setup.sh
RUN cat candle_setup.sh