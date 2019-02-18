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
pip install -r /opt/pip-dependencies.txt 