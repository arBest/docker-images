FROM ubuntu:18.04 as ubuntu
RUN uname -a
RUN apt-get update
RUN apt-get -y install vim
RUN apt-get install -y python-pip
RUN pip install --upgrade pip
RUN python --version
RUN pip --version
FROM tensorflow/tensorflow:1.12.0-gpu as tensorflow
RUN uname -a
RUN python --version
RUN pip --version
ENV export SINGULARITY_DOCKER_USERNAME='$oauthtoken'
ENV export SINGULARITY_DOCKER_PASSWORD=dG5zcmUyNWFsMWllMnRlaW12ZWFiaGhpazU6NmE5YzlmN2ItMGNiNi00MThlLWEyZmQtM2JlM2MzY2NhZWQy
FROM nvcr.io/hpc/candle:20180326 as candle
RUN uname -a
FROM python:3.6 as python
RUN python --version
RUN pip --version