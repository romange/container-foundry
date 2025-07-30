#!/bin/bash
set -e

OPENSSL_VERSION="3.0.17"
OPENSSL_DIR="/usr/local/ssl"

# Remove installed version
apt remove -y openssl

# Download and extract
cd /tmp
curl -O -L https://github.com/openssl/openssl/releases/download/openssl-${OPENSSL_VERSION}/openssl-${OPENSSL_VERSION}.tar.gz
tar xzf openssl-${OPENSSL_VERSION}.tar.gz
cd openssl-${OPENSSL_VERSION}

# Configure with static linking
./Configure linux-x86_64 no-shared --prefix=${OPENSSL_DIR} 
make -j"$(nproc)"
make install

ln -s /usr/local/ssl/lib64/libcrypto.a /usr/lib/x86_64-linux-gnu/
ln -s /usr/local/ssl/lib64/libssl.a /usr/lib/x86_64-linux-gnu/
cp -r /usr/local/ssl/include/openssl /usr/include/