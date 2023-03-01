# syntax=docker/dockerfile:1
FROM ubuntu:20.04

LABEL org.opencontainers.image.source https://github.com/romange/container-foundry

COPY ./get_mold.sh /tmp/
COPY ./install_versioned_redis.sh /tmp/

# To avoid tzdata reconfigure
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update 
Run apt install -y autoconf-archive bison cmake curl gdb git libssl-dev \
    libunwind-dev libfl-dev ninja-build libtool redis wget \
    gcc-9 g++-9 libboost-fiber-dev libxml2-dev zip ccache libzstd-dev 
RUN rm -rf /var/lib/apt/lists/*
    
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 40  \
    --slave /usr/bin/g++ g++ /usr/bin/g++-9

RUN /tmp/get_mold.sh
RUN /tmp/install_versioned_redis.sh redis-server-6.2.11 https://github.com/redis/redis/archive/6.2.11.tar.gz