#!/bin/bash
set -e

AFL_VERSION=${AFL_VERSION:-v4.34c}

cd /tmp
git clone --depth=1 --branch "$AFL_VERSION" https://github.com/AFLplusplus/AFLplusplus.git

cd AFLplusplus

# Enable AFL_PERSISTENT_RECORD support
sed -i 's|// #define AFL_PERSISTENT_RECORD|#define AFL_PERSISTENT_RECORD|' include/config.h

make distrib
make install

cd /
rm -rf /tmp/AFLplusplus

afl-cc --version
