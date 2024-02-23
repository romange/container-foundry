# syntax=docker/dockerfile:1
FROM centos:7.9.2009

COPY ./install_boost.sh /tmp/

RUN yum update -y && yum install -y automake libtool git epel-release make \
    autoconf-archive patch wget bzip2 \
    zlib-devel centos-release-scl 

RUN yum install -y devtoolset-11-gcc-c++ cmake3 ninja-build libzstd-static
RUN echo "source /opt/rh/devtoolset-11/enable" >> /etc/bashrc
SHELL ["/bin/bash", "--login", "-c"]

RUN wget --no-check-certificate https://ftp.openssl.org/source/openssl-1.1.1w.tar.gz && \
    tar -xzvf openssl-1.1.1w.tar.gz && \
    cd openssl-1.1.1w && \
    ./config --prefix=/usr --openssldir=/etc/ssl --libdir=lib no-shared zlib-dynamic && \
    make -j $(nproc) && \
    make install && /tmp/install_boost.sh  && \
    wget --no-check-certificate https://ftp.gnu.org/gnu/bison/bison-3.7.3.tar.gz && \
    tar -xvzf bison-3.7.3.tar.gz && cd bison-3.7.3 && \
    ./configure &&  make -j$(nproc) && make install

#    export PATH=/usr/local/openssl/bin:\$PATH && \
#    export LD_LIBRARY_PATH=/usr/local/openssl/lib:\$LD_LIBRARY_PATH