#!/bin/bash
set -ex

# Script to install redis from url to /bin
# $1 - source-bin-name
# $2 - target-bin-name
# $3 - url

# download & extract
wget "$3" -O arch.tar.gz -q
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
mv $REDIS_ROOT/src/$1 /bin/$2

# Cleanup
rm -rf out
rm -rf arch.tar.gz
