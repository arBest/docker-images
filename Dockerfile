FROM ubuntu:18.04 as ubuntu
FROM python:3 as python
RUN apt-get update
RUN apt-get -y install vim
RUN apt-get install -y python-pip
FROM tensorflow/tensorflow:1.12.0-gpu as tensorflow
ENV export SINGULARITY_DOCKER_USERNAME='$oauthtoken'
ENV export SINGULARITY_DOCKER_PASSWORD=dG5zcmUyNWFsMWllMnRlaW12ZWFiaGhpazU6NmE5YzlmN2ItMGNiNi00MThlLWEyZmQtM2JlM2MzY2NhZWQy
FROM nvcr.io/hpc/candle:20180326 as candle
