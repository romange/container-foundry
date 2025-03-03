# syntax=docker/dockerfile:1
FROM fedora:41

RUN dnf install -y automake boost-devel bison ccache cmake gcc-c++ git \
     libtool make ninja-build  \
     openssl-devel libunwind-devel autoconf-archive patch \
     pcre2-devel python3-devel python3-pip zlib-devel gdb