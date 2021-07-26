FROM debian:stretch-20200414-slim

RUN apt-get update && \
apt-get install -y locales && \
apt-get install -y less && \
apt-get install -y curl wget && \
apt-get install -y jq && \
apt-get clean && rm -rf /var/lib/apt/lists/*

RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

WORKDIR /opt/bash-utils
COPY src .
