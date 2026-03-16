#!/bin/bash
set -ex

LLVM_VERSION=${1:-22}

# Get the OS codename (e.g., focal, jammy, noble)
source /etc/os-release

# Setup the repository key and source list
wget -qO- https://apt.llvm.org/llvm-snapshot.gpg.key > /etc/apt/trusted.gpg.d/apt.llvm.org.asc
echo "deb http://apt.llvm.org/${VERSION_CODENAME}/ llvm-toolchain-${VERSION_CODENAME}-${LLVM_VERSION} main" > /etc/apt/sources.list.d/llvm.list

# Update apt and install minimal clang with ASAN support
apt-get update
apt-get install -y --no-install-recommends clang-${LLVM_VERSION} libclang-rt-${LLVM_VERSION}-dev \
  && rm -rf /var/lib/apt/lists/*
