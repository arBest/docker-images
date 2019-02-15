FROM centos:6 as os
RUN yum update
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
' > candle_setup.sh
RUN cat candle_setup.sh