#!/bin/bash
set -ex

GCC_VERSION="${GCC_VERSION:-14.3.0}"
GCC_PREFIX="${GCC_PREFIX:-/opt/gcc-14}"
GCC_LANGUAGES="${GCC_LANGUAGES:-c,c++}"

cd /tmp

# Download GCC source
wget -nv https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.xz
tar -xf gcc-${GCC_VERSION}.tar.xz
cd gcc-${GCC_VERSION}

# Build
mkdir build && cd build
../configure \
    --prefix=${GCC_PREFIX} \
    --enable-languages=${GCC_LANGUAGES} \
    --disable-multilib \
    --disable-bootstrap

make -j$(nproc)
make install

# Verify
${GCC_PREFIX}/bin/gcc --version
${GCC_PREFIX}/bin/g++ --version

# Cleanup
cd /tmp
rm -rf gcc-${GCC_VERSION}*

echo "GCC ${GCC_VERSION} installed successfully to ${GCC_PREFIX}"
