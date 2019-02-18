FROM centos:7 as os
ENV export SINGULARITY_DOCKER_USERNAME='$oauthtoken'
ENV export SINGULARITY_DOCKER_PASSWORD=dG5zcmUyNWFsMWllMnRlaW12ZWFiaGhpazU6NmE5YzlmN2ItMGNiNi00MThlLWEyZmQtM2JlM2MzY2NhZWQy
FROM nvcr.io/hpc/candle:20180326 as candle
WORKDIR /opt
RUN rm candle_setup.sh
RUN echo $'\n\ 
#!/bin/bash\n\ 
pip install --upgrade pip \\n\
pip install keras && \\n\
pip install -r /opt/pip-dependencies.txt && \\n\
export PATH=/usr/bin:$PATH && \\n\
export BUILD_DIR=/opt && \\n\
cd $BUILD_DIR && \\n\
rm -rf swift-t 2> /dev/null && \\n\
apt-get update -y && \\n\
apt-get install -y --no-install-recommends \\n\
		autoconf \\n\
	automake \\n\
	default-jdk \\n\
	git \\n\
	ant \\n\
	swig \\n\
	zsh \\n\
	tcl \\n\
	tcl-dev \\n\
	python-tk && \\n\
rm -rf /var/lib/apt/lists/* && \\n\
wget http://swift-lang.github.io/swift-t-downloads/1.4/swift-t-1.4.tar.gz && \\n\
tar -zxvf swift-t-1.4.tar.gz && \\n\
$BUILD_DIR/swift-t-1.4/dev/build/init-settings.sh && \\n\
sed -i  's@^export SWIFT_T_PREFIX=.*@export SWIFT_T_PREFIX=/opt/swift-t@' ./swift-t-1.4/dev/build/swift-t-settings.sh && \\n\
sed -i  's@.*ENABLE_PYTHON=1@ENABLE_PYTHON=1@' ./swift-t-1.4/dev/build/swift-t-settings.sh && \\n\
sed -i  's@.*ENABLE_R=1@ENABLE_R=1@' ./swift-t-1.4/dev/build/swift-t-settings.sh && \\n\
sed -i  's@.*R_INSTALL=.*@R_INSTALL=/usr/share/R/@' ./swift-t-1.4/dev/build/swift-t-settings.sh && \\n\
$BUILD_DIR/swift-t-1.4/dev/build/build-all.sh && \\n\
export TURBINE_PATH=$BUILD_DIR/swift-t/turbine && \\n\
chmod +x $TURBINE_PATH/bin/turbine && \\n\
sed -i  's@\${TURBINE_LAUNCHER} \${OPTIONS} \${=VALGRIND} @\${TURBINE_LAUNCHER} \${OPTIONS} \${=VALGRIND} \${TURBINE_HOME}/bin/gpurunscript.sh @' $TURBINE_PATH/bin/turbine && \\n\
cp /gpurunscript.sh $TURBINE_PATH/bin && \\n\
chmod +x $TURBINE_PATH/bin/gpurunscript.sh && \\n\
export PATH=$BUILD_DIR/swift-t/stc/bin/:$TURBINE_PATH/bin:$PATH && \\n\
export TURBINE_LAUNCH_OPTIONS=--allow-run-as-root && \\n\
git clone https://github.com/emews/EQ-R.git && \\n\
cd $BUILD_DIR/EQ-R/src && \\n\
./bootstrap && \\n\
ls && \\n\
' > candle_setup.sh
RUN ./candle_setup.sh