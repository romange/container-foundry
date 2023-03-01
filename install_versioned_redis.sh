#!/bin/bash
set -ex

# Script to install redis from url to /bin
# $1 - bin-name
# $2 - url

# download & extract
wget "$2" -O arch.tar.gz -q
rm -rf out
mkdir out
tar -xf arch.tar.gz --directory out

# Build
cd out
cd $(ls -d */|head -n 1)
REDIS_ROOT=$PWD
make
cd ../..

# Copy binary
mkdir -p bin
mv $REDIS_ROOT/src/redis-server /bin/$1

# Cleanup
rm -rf out
rm -rf arch.tar.gz
