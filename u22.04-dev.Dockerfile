FROM ubuntu:22.04

LABEL org.opencontainers.image.source="https://github.com/romange/container-foundry"

COPY ./get_mold.sh /tmp/

# To avoid tzdata reconfigure
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y autoconf-archive bison cmake curl gdb git libssl-dev \
    libunwind-dev libfl-dev ninja-build libtool \
    gcc-11 g++-11 libboost-context-dev libpcre2-dev libxml2-dev zip ccache libzstd-dev \
    debhelper moreutils pip jq lsof lcov netcat redis-tools \
    && rm -rf /var/lib/apt/lists/*
    
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 40  \
    --slave /usr/bin/g++ g++ /usr/bin/g++-11

RUN /tmp/get_mold.sh
RUN mkdir -p ~/.config/gdb && echo 'set history save on' >> ~/.config/gdb/gdbinit \
    && echo 'set debuginfod enabled off' >> ~/.config/gdb/gdbinit