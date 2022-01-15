FROM ubuntu:20.04

LABEL org.opencontainers.image.source https://github.com/romange/container-foundry

# To avoid tzdata reconfigure
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y autoconf-archive bison cmake curl git libssl-dev \
    libunwind-dev libfl-dev ninja-build libtool \
    gcc-9 g++-9 libboost-fiber-dev libxml2-dev zip ccache \
    && rm -rf /var/lib/apt/lists/*
    
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 40  \
    --slave /usr/bin/g++ g++ /usr/bin/g++-9