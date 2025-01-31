# syntax=docker/dockerfile:1
FROM fedora:30

COPY ./install_boost.sh  /tmp/
COPY ./get_cmake.sh /tmp/

RUN dnf install -y automake  gcc-c++ git libtool make ninja-build  \
     openssl-devel libunwind-devel autoconf-archive patch wget bzip2 \
     openssl-static pcre2-devel zlib-devel gdb ccache

RUN dnf install -y bison libzstd-static --releasever=32

RUN /tmp/install_boost.sh && /tmp/get_cmake.sh