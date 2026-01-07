#!/bin/bash
set -e

ARCH=$(uname -m)
case $ARCH in
    x86_64) ARCH="amd64" ;;
    aarch64) ARCH="arm64" ;;
esac

PROMTOOL_VERSION="3.8.1"
RELEASE_URL="https://github.com/prometheus/prometheus/releases/download"

cd /tmp 
curl -fL -s "${RELEASE_URL}/v${PROMTOOL_VERSION}/prometheus-${PROMTOOL_VERSION}.linux-${ARCH}.tar.gz" -o prom.tgz
mkdir prom

tar xzf prom.tgz -C prom --strip-components=1 && rm prom.tgz
mv prom/promtool /usr/local/bin

promtool --version
rm -rf prom
