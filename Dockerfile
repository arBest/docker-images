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
        \npython-tk && \
    \nrm -rf /var/lib/apt/lists/* && \
    \nwget http://swift-lang.github.io/swift-t-downloads/1.4/swift-t-1.4.tar.gz && \
    \ntar -zxvf swift-t-1.4.tar.gz && \
    \n$BUILD_DIR/swift-t-1.4/dev/build/init-settings.sh && \
    \nsed -i  's@^export SWIFT_T_PREFIX=.*@export SWIFT_T_PREFIX=/opt/swift-t@' ./swift-t-1.4/dev/build/swift-t-settings.sh && \
    \nsed -i  's@.*ENABLE_PYTHON=1@ENABLE_PYTHON=1@' ./swift-t-1.4/dev/build/swift-t-settings.sh && \
    \nsed -i  's@.*ENABLE_R=1@ENABLE_R=1@' ./swift-t-1.4/dev/build/swift-t-settings.sh && \
    \nsed -i  's@.*R_INSTALL=.*@R_INSTALL=/usr/share/R/@' ./swift-t-1.4/dev/build/swift-t-settings.sh && \
    \n$BUILD_DIR/swift-t-1.4/dev/build/build-all.sh && \
    \nexport TURBINE_PATH=$BUILD_DIR/swift-t/turbine && \
    \nchmod +x $TURBINE_PATH/bin/turbine && \
    \nsed -i  's@\${TURBINE_LAUNCHER} \${OPTIONS} \${=VALGRIND} @\${TURBINE_LAUNCHER} \${OPTIONS} \${=VALGRIND} \${TURBINE_HOME}/bin/gpurunscript.sh @' $TURBINE_PATH/bin/turbine && \
    \ncp /gpurunscript.sh $TURBINE_PATH/bin && \
    \nchmod +x $TURBINE_PATH/bin/gpurunscript.sh && \
    \nexport PATH=$BUILD_DIR/swift-t/stc/bin/:$TURBINE_PATH/bin:$PATH && \
    \nexport TURBINE_LAUNCH_OPTIONS=--allow-run-as-root && \
    \ngit clone https://github.com/emews/EQ-R.git && \
    \ncd $BUILD_DIR/EQ-R/src && \
    \n./bootstrap && \
    \nls\n
" > candle_setup.sh
RUN cat candle_setup.sh