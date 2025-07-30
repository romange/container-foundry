#!/bin/bash
set -e

OPENSSL_VERSION="3.0.17"
OPENSSL_DIR="/usr/local/ssl"
CONFIGURE_PARAMS="no-shared no-tests no-idea no-mdc2 no-rc5 no-zlib no-ui-console no-ssl3 no-ssl3-method enable-rfc3779 enable-cms no-capieng no-rdrand"

# Add architecture-specific parameters
if [ "$(uname -m)" = "x86_64" ]; then
    CONFIGURE_PARAMS="${CONFIGURE_PARAMS} enable-ec_nistp_64_gcc_128"
fi
echo "Configuring OpenSSL with parameters: ${CONFIGURE_PARAMS}"

# Download and extract
cd /tmp
curl -O -L https://github.com/openssl/openssl/releases/download/openssl-${OPENSSL_VERSION}/openssl-${OPENSSL_VERSION}.tar.gz
tar xzf openssl-${OPENSSL_VERSION}.tar.gz
cd openssl-${OPENSSL_VERSION}

# Configure with static linking
./Configure ${CONFIGURE_PARAMS} --prefix=${OPENSSL_DIR} --libdir=lib
make -j"$(nproc)" build_sw
make install_sw
rm -rf /tmp/openssl-*