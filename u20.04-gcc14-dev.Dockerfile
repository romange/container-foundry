# syntax=docker/dockerfile:1
FROM ubuntu:20.04

LABEL org.opencontainers.image.source="https://github.com/romange/container-foundry"

COPY ./get_mold.sh /tmp/
COPY ./get_binutils.sh /tmp/
COPY ./get_gcc14.sh /tmp/
COPY ./get_openssl.sh /tmp/
COPY ./install_versioned_redis.sh /tmp/
COPY ./install_python_deps.sh /tmp/

# To avoid tzdata reconfigure
ENV DEBIAN_FRONTEND=noninteractive

# Install base development tools and GCC 14 build dependencies
RUN apt update && apt install -y autoconf-archive bison cmake curl gdb git perl \
    libunwind-dev libfl-dev ninja-build libtool libpcre2-dev redis-tools wget \
    gcc g++ libboost-context-dev zip ccache libzstd-dev \
    debhelper moreutils pip jq lsof lcov libflatbuffers-dev pkg-config \
    # GCC 14 build dependencies
    libgmp-dev libmpfr-dev libmpc-dev flex texinfo file \
    && rm -rf /var/lib/apt/lists/*

# Build and install binutils 2.42 and GCC 14
RUN /tmp/get_binutils.sh && /tmp/get_gcc14.sh

# Set up environment to use GCC 14
ENV PATH="/opt/gcc-14/bin:${PATH}" \
    LD_LIBRARY_PATH="/opt/gcc-14/lib64:${LD_LIBRARY_PATH}" \
    CC="/opt/gcc-14/bin/gcc" \
    CXX="/opt/gcc-14/bin/g++"

RUN /tmp/get_mold.sh
RUN /tmp/install_versioned_redis.sh redis-server redis-server-6.2.11 https://github.com/redis/redis/archive/6.2.11.tar.gz
RUN /tmp/install_versioned_redis.sh redis-server redis-server-7.2.2 https://github.com/redis/redis/archive/7.2.2.tar.gz
RUN /tmp/install_versioned_redis.sh valkey-server valkey-server-8.0.1 https://github.com/valkey-io/valkey/archive/refs/tags/8.0.1.tar.gz

RUN /tmp/get_openssl.sh && /tmp/install_python_deps.sh

# Set OpenSSL path for CMake
ENV CMAKE_PREFIX_PATH=/usr/local/ssl

RUN mkdir -p ~/.config/gdb && echo 'set history save on' >> ~/.config/gdb/gdbinit \
    && echo 'set debuginfod enabled off' >> ~/.config/gdb/gdbinit
