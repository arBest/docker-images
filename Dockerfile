FROM ubuntu:18.04
RUN apt-get update
RUN apt-get -y install curl
RUN apt-get -y install vim
FROM tensorflow/tensorflow:1.12.0-gpu
