#!/bin/bash
set -ex

# Script to install redis from url to /usr/local/bin
# $1 - source-bin-name
# $2 - target-bin-name
# $3 - url

mkdir -p out
wget -qO- "$3" | tar -xz -C out --strip-components=1
cd out
make
cp "src/$1" "/usr/local/bin/$2"
cd .. && rm -rf out
