FROM ubuntu:18.04 as ubuntu
RUN apt-get update && apt-get install -y \
    vim
ENV export SINGULARITY_DOCKER_USERNAME='$oauthtoken'
ENV export SINGULARITY_DOCKER_PASSWORD=dG5zcmUyNWFsMWllMnRlaW12ZWFiaGhpazU6NmE5YzlmN2ItMGNiNi00MThlLWEyZmQtM2JlM2MzY2NhZWQy
FROM nvcr.io/hpc/candle:20180326 as candle
WORKDIR /opt
COPY ./candle_setup.sh .
#ENTRYPOINT ./candle_setup.sh