# syntax=docker/dockerfile:1
FROM fedora:30

COPY ./install_boost.sh /tmp/

RUN dnf install -y automake  gcc-c++ git cmake libtool make ninja-build  \
     openssl-devel libunwind-devel autoconf-archive patch wget bzip2 \
     openssl-static zlib-devel gdb ccache flatbuffers-devel

RUN dnf install -y bison libzstd-static --releasever=32 \
     && dnf clean all && rm -rf /var/cache/yum

RUN /tmp/install_boost.sh