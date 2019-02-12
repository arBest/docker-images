FROM ubuntu:18.04 as ubuntu
RUN apt-get update && apt-get install -y \
    vim
FROM tensorflow/tensorflow:1.12.0-gpu as tensorflow
ENV export SINGULARITY_DOCKER_USERNAME='$oauthtoken'
ENV export SINGULARITY_DOCKER_PASSWORD=dG5zcmUyNWFsMWllMnRlaW12ZWFiaGhpazU6NmE5YzlmN2ItMGNiNi00MThlLWEyZmQtM2JlM2MzY2NhZWQy
FROM nvcr.io/hpc/candle:20180326 as candle
FROM python:3.6.4 as python
WORKDIR .
RUN pwd 
RUN python3 -m pip install --user --upgrade pip