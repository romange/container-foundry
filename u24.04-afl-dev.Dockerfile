FROM ubuntu:24.04

LABEL org.opencontainers.image.source="https://github.com/romange/container-foundry"

COPY ./get_mold.sh ./get_afl.sh /tmp/

# To avoid tzdata reconfigure
ENV DEBIAN_FRONTEND=noninteractive

# Install base development packages + AFL++ dependencies
RUN apt update && apt install -y autoconf-archive bison clang cmake curl gdb git libssl-dev \
    libunwind-dev libfl-dev ninja-build libtool \
    libboost-context-dev libpcre2-dev libxml2-dev zip ccache libzstd-dev \
    debhelper moreutils pip jq lsof lcov libflatbuffers-dev wget \
    # AFL++ dependencies
    clang-18 llvm-18 llvm-18-dev lld-18 \
    build-essential python3-dev automake flex libglib2.0-dev libpixman-1-dev \
    gnuplot-nox && \
    rm -rf /var/lib/apt/lists/*

RUN /tmp/get_mold.sh && /tmp/get_afl.sh

RUN mkdir -p ~/.config/gdb && echo 'set history save on' >> ~/.config/gdb/gdbinit \
    && echo 'set debuginfod enabled off' >> ~/.config/gdb/gdbinit
