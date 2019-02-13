FROM ubuntu:18.04 as ubuntu
RUN apt-get update && apt-get install -y \
    vim
FROM continuumio/miniconda3
RUN conda create -n env python=3.6
RUN echo "source activate env" > ~/.bashrc
ENV PATH /opt/conda/envs/env/bin:$PATH