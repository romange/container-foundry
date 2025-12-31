#!/bin/bash
set -ex

BINUTILS_VERSION="${BINUTILS_VERSION:-2.42}"
BINUTILS_PREFIX="${BINUTILS_PREFIX:-/opt/gcc-14}"

cd /tmp

# Download binutils source
wget -nv https://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VERSION}.tar.xz
tar -xf binutils-${BINUTILS_VERSION}.tar.xz
cd binutils-${BINUTILS_VERSION}

# Build with optimization flags
export CFLAGS="-O2 -pipe"
export CXXFLAGS="-O2 -pipe"

./configure \
    --prefix=${BINUTILS_PREFIX} \
    --disable-nls \
    --disable-werror \
    --disable-gdb \
    --disable-gdbserver \
    --disable-libdecnumber \
    --disable-readline \
    --disable-sim \
    --enable-deterministic-archives \
    --with-system-zlib

make -j$(nproc)
make install-strip

# Remove unnecessary files to reduce size
rm -rf ${BINUTILS_PREFIX}/share/info
rm -rf ${BINUTILS_PREFIX}/share/man
rm -rf ${BINUTILS_PREFIX}/share/locale
find ${BINUTILS_PREFIX} -name '*.la' -delete
find ${BINUTILS_PREFIX}/lib* -name '*.a' -exec strip --strip-debug {} \; 2>/dev/null || true

# Verify
${BINUTILS_PREFIX}/bin/ld --version
${BINUTILS_PREFIX}/bin/as --version

# Cleanup
cd /tmp
rm -rf binutils-${BINUTILS_VERSION}*

echo "Binutils ${BINUTILS_VERSION} installed successfully to ${BINUTILS_PREFIX}"
