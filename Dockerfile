FROM ubuntu:18.04 as ubuntu
FROM python:3.6 as python
RUN apt-get update
RUN apt-get -y install vim
RUN apt-get install -y python-pip
RUN pip install --upgrade pip
RUN which python
RUN python --version
RUN which pip
RUN pip --version
RUN pip install scipy