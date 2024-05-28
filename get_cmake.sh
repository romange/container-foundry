#!/bin/bash
set -e

cd /tmp
CMAKE_VER=3.18.3
BASE_URL=https://github.com/Kitware/CMake/releases/download
wget -q ${BASE_URL}/v${CMAKE_VER}/cmake-${CMAKE_VER}.tar.gz 
tar xfz cmake-*.tar.gz && rm -f *.tar.gz && cd cmake-${CMAKE_VER}
./bootstrap && gmake -j4 cmake cpack ctest
gmake install
cd - && rm -rf cmake-*