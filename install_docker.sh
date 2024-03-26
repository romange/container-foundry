#!/bin/bash
set -ex

if [[ $(uname -m) == "aarch64" ]]; then
  ARCH='arm64'
else
  ARCH='amd64'
fi

apt update && apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=$ARCH] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" 
apt-get update && apt-get install -y docker-ce
