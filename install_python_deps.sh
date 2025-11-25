#!/bin/bash
set -e

PACKAGES=(
    async-timeout
    attrs
    Deprecated
    iniconfig
    packaging
    pluggy
    py
    pyparsing
    pytest
    redis
    tomli
    wrapt
    pytest-asyncio
    pytest-repeat
    pytest-emoji
    pytest-icdiff
    pytest-timeout
    pymemcache
    meta_memcache
    prometheus_client
    aiohttp
    numpy
    pytest-json-report
    psutil
    boto3
    asyncio
    hiredis
    PyYAML
    testcontainers
    valkey
)

# Try installing without --break-system-packages first
if ! pip install "${PACKAGES[@]}" 2>/dev/null; then
    echo "Standard pip install failed, retrying with --break-system-packages..."
    pip install --break-system-packages "${PACKAGES[@]}"
fi
