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

# Build with optimization flags
export CFLAGS="-O2 -pipe"
export CXXFLAGS="-O2 -pipe"

mkdir build && cd build
../configure \
    --prefix=${GCC_PREFIX} \
    --enable-languages=${GCC_LANGUAGES} \
    --disable-multilib \
    --disable-bootstrap \
    --disable-nls \
    --enable-checking=release \
    --with-system-zlib

make -j$(nproc) STAGE1_CFLAGS="-O2" BOOT_CFLAGS="-O2"
make install-strip

# Remove unnecessary files to reduce size
rm -rf ${GCC_PREFIX}/share/info
rm -rf ${GCC_PREFIX}/share/man
rm -rf ${GCC_PREFIX}/share/locale
rm -rf ${GCC_PREFIX}/share/gcc-*/python
find ${GCC_PREFIX} -name '*.la' -delete

# Strip remaining libraries that install-strip might have missed
find ${GCC_PREFIX}/lib* -name '*.a' -exec strip --strip-debug {} \; 2>/dev/null || true
find ${GCC_PREFIX}/lib* -name '*.so*' -exec strip --strip-unneeded {} \; 2>/dev/null || true
find ${GCC_PREFIX}/libexec -type f -executable -exec strip --strip-unneeded {} \; 2>/dev/null || true

# Verify
${GCC_PREFIX}/bin/gcc --version
${GCC_PREFIX}/bin/g++ --version

# Cleanup
cd /tmp
rm -rf gcc-${GCC_VERSION}*

echo "GCC ${GCC_VERSION} installed successfully to ${GCC_PREFIX}"
