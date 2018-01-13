FROM ubuntu:trusty

RUN \
  apt-get update && \
  apt-get install -y \
    software-properties-common && \
  apt-get update && \
  apt-get install -y \
    build-essential \
    gcc-4.8 \
    git \
    tree

COPY . /usr/src
WORKDIR /usr/src
