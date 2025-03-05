# syntax=docker/dockerfile:1
FROM ubuntu:20.04

LABEL org.opencontainers.image.source="https://github.com/romange/container-foundry"

COPY ./get_mold.sh /tmp/
COPY ./install_versioned_redis.sh /tmp/

# To avoid tzdata reconfigure
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update 
RUN apt install -y autoconf-archive bison cmake curl gdb git libssl-dev \
    libunwind-dev libfl-dev ninja-build libtool libpcre2-dev redis-tools wget \
    gcc-9 g++-9 libboost-context-dev zip ccache libzstd-dev \
    debhelper moreutils pip jq lsof lcov libflatbuffers-dev pkg-config \
    && rm -rf /var/lib/apt/lists/*
    
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 40  \
    --slave /usr/bin/g++ g++ /usr/bin/g++-9

RUN /tmp/get_mold.sh
RUN /tmp/install_versioned_redis.sh redis-server redis-server-6.2.11 https://github.com/redis/redis/archive/6.2.11.tar.gz
RUN /tmp/install_versioned_redis.sh redis-server redis-server-7.2.2 https://github.com/redis/redis/archive/7.2.2.tar.gz
RUN /tmp/install_versioned_redis.sh valkey-server valkey-server-8.0.1 https://github.com/valkey-io/valkey/archive/refs/tags/8.0.1.tar.gz

RUN mkdir -p ~/.config/gdb && echo 'set history save on' >> ~/.config/gdb/gdbinit \
    && echo 'set debuginfod enabled off' >> ~/.config/gdb/gdbinit
    