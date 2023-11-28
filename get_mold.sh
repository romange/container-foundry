#!/bin/bash
set -e

cd /tmp 
ARCH=`uname -m`
MOLD_VER=2.3.3
BASE_URL=https://github.com/rui314/mold/releases/download
curl -L -s $BASE_URL/v${MOLD_VER}/mold-$MOLD_VER-$ARCH-linux.tar.gz -o mold.tgz
mkdir mold 

tar xvfz mold.tgz -C mold --strip-components=1  && rm mold.tgz
mv mold/bin/* /usr/local/bin/
mv mold/libexec /usr/local/
mold --version

rm -rf mold


