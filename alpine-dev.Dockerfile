# syntax=docker/dockerfile:1
FROM alpine:3.18.12    

LABEL org.opencontainers.image.source="https://github.com/romange/container-foundry"

# to allow installing mold
# RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

# To avoid tzdata reconfigure
# ENV DEBIAN_FRONTEND=noninteractive
# 
# coreutils is needed so that mktemp will work as expected.

RUN apk add autoconf-archive automake bash bison boost-dev boost-static cmake coreutils \
        curl ccache clang flex-dev git gcc gdb g++ libunwind-dev libtool pcre2-dev make ninja \
        openssl-dev patch zip zstd-dev lsof flatbuffers-dev moreutils
RUN apk add --no-cache tar

# currently for aarch64 there is no mold
# RUN [[ $(uname -m) == "aarch64" ]] || apk add mold@testing
