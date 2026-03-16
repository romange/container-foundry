FROM ubuntu:24.04

LABEL org.opencontainers.image.source="https://github.com/romange/container-foundry"

COPY ./get_mold.sh /tmp/
COPY ./get_clang.sh /tmp/
COPY ./install_versioned_redis.sh /tmp/
COPY ./install_python_deps.sh /tmp/
COPY ./get_promtool.sh /tmp/

# To avoid tzdata reconfigure
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y autoconf-archive bison cmake curl gdb git libssl-dev \
    libunwind-dev libfl-dev ninja-build libtool \
    libboost-context-dev libpcre2-dev zip ccache libzstd-dev \
    debhelper moreutils pip jq lsof lcov libflatbuffers-dev redis-tools wget \
    && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man

RUN /tmp/get_clang.sh 22
RUN /tmp/get_mold.sh && /tmp/get_promtool.sh
RUN mkdir -p ~/.config/gdb && echo 'set history save on' >> ~/.config/gdb/gdbinit \
    && echo 'set debuginfod enabled off' >> ~/.config/gdb/gdbinit

RUN /tmp/install_python_deps.sh
RUN /tmp/install_versioned_redis.sh redis-server redis-server-6.2.11 https://github.com/redis/redis/archive/6.2.11.tar.gz
RUN /tmp/install_versioned_redis.sh redis-server redis-server-7.2.2 https://github.com/redis/redis/archive/7.2.2.tar.gz
RUN /tmp/install_versioned_redis.sh valkey-server valkey-server-8.0.1 https://github.com/valkey-io/valkey/archive/refs/tags/8.0.1.tar.gz
