FROM ubuntu:18.04 as os
RUN apt-get update && apt-get install -y --no-install-recommends \
	vim \
	python-pip
ENV export SINGULARITY_DOCKER_USERNAME='$oauthtoken'
ENV export SINGULARITY_DOCKER_PASSWORD=dG5zcmUyNWFsMWllMnRlaW12ZWFiaGhpazU6NmE5YzlmN2ItMGNiNi00MThlLWEyZmQtM2JlM2MzY2NhZWQy
FROM nvcr.io/hpc/candle:20180326 as candle
WORKDIR /opt
RUN rm candle_setup.sh
RUN pip install --upgrade pip && \
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
rm -rf /var/lib/apt/lists/* && \
wget http://swift-lang.github.io/swift-t-downloads/1.4/swift-t-1.4.tar.gz && \
tar -zxvf swift-t-1.4.tar.gz && \
$BUILD_DIR/swift-t-1.4/dev/build/init-settings.sh && \
sed -i  's@^export SWIFT_T_PREFIX=.*@export SWIFT_T_PREFIX=/opt/swift-t@' ./swift-t-1.4/dev/build/swift-t-settings.sh && \
sed -i  's@.*ENABLE_PYTHON=1@ENABLE_PYTHON=1@' ./swift-t-1.4/dev/build/swift-t-settings.sh && \
sed -i  's@.*ENABLE_R=1@ENABLE_R=1@' ./swift-t-1.4/dev/build/swift-t-settings.sh && \
sed -i  's@.*R_INSTALL=.*@R_INSTALL=/usr/share/R/@' ./swift-t-1.4/dev/build/swift-t-settings.sh && \
$BUILD_DIR/swift-t-1.4/dev/build/build-all.sh && \
export TURBINE_PATH=$BUILD_DIR/swift-t/turbine && \
chmod +x $TURBINE_PATH/bin/turbine && \
sed -i  's@\${TURBINE_LAUNCHER} \${OPTIONS} \${=VALGRIND} @\${TURBINE_LAUNCHER} \${OPTIONS} \${=VALGRIND} \${TURBINE_HOME}/bin/gpurunscript.sh @' $TURBINE_PATH/bin/turbine && \
cp /gpurunscript.sh $TURBINE_PATH/bin && \
chmod +x $TURBINE_PATH/bin/gpurunscript.sh && \
export PATH=$BUILD_DIR/swift-t/stc/bin/:$TURBINE_PATH/bin:$PATH && \
export TURBINE_LAUNCH_OPTIONS=--allow-run-as-root 
RUN wget https://cran.r-project.org/src/base/R-3/R-3.4.3.tar.gz && \
./configure --prefix=$BUILD_DIR/R-3.4.3 --without-ICU --enable-R-shlib && \
make -j 4 && \
make install
RUN git clone https://github.com/emews/EQ-R.git && \
cd $BUILD_DIR/EQ-R/src && \
./bootstrap && \
echo $'
#R install local install\n\
R_HOME=$BUILD_DIR/R-3.4.3\n\
R_INCLUDE=$R_HOME/lib/R/include\n\
R_LIB=$R_HOME/lib/R/lib\n\
R_INSIDE=$R_HOME/lib/R/library/RInside\n\
RCPP=$R_HOME/lib/R/library/Rcpp\n\
# System-wide Tcl, such as Ubuntu\n\
TCL_INCLUDE=/usr/include/tcl8.6\n\
TCL_LIB=/usr/lib/tcl8.6\n\
TCL_LIBRARY=tcl8.6\n\
' > settings.sh && \
ls && \
sed -i 's@^TCL_INCLUDE=.*@TCL_INCLUDE=/usr/include/tcl@' ./settings.sh && \
sed -i 's@^TCL_LIB=.*@TCL_LIB=/usr/lib@' ./settings.sh && \
bash -c 'source settings.sh && ./configure --prefix=/opt/EQ-R && make install && make clean' && \
echo 'clean install'