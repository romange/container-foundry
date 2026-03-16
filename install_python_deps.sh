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
    tomli
    wrapt    
    pytest-repeat
    pytest-emoji
    pytest-icdiff
    pytest-timeout
    pymemcache
    meta_memcache
    prometheus_client
    aiohttp
    pytest-json-report
    psutil
    boto3
    asyncio
    PyYAML
    testcontainers
    valkey
)

# Try installing without --break-system-packages first
if ! pip install --no-cache-dir "${PACKAGES[@]}" 2>/dev/null; then
    echo "Standard pip install failed, retrying with --break-system-packages..."
    pip install --no-cache-dir --break-system-packages "${PACKAGES[@]}"
fi
