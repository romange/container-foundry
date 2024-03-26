# Use the base image
FROM ghcr.io/romange/ubuntu-dev:20 as base

ARG TARGETPLATFORM

# Install Node.js
RUN apt-get update && \
    apt-get install -y nodejs npm && \
    npm install -g npm

# Install Docker
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

RUN if [ ${TARGETPLATFORM} = "linux/amd64" ]; then \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"; \
    elif [ ${TARGETPLATFORM} = "linux/arm64" ]; then \
    add-apt-repository "deb [arch=armhf] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"; \
    fi

# Install Docker
RUN apt-get update && apt-get install -y docker-ce


# Install dependencies (if needed)
RUN apt-get update && apt-get install -y sudo build-essential autoconf automake libpcre3-dev libevent-dev pkg-config zlib1g-dev git

# Clone memtier_benchmark repository
RUN git clone https://github.com/RedisLabs/memtier_benchmark.git

# Build memtier_benchmark
RUN cd memtier_benchmark && autoreconf -ivf && ./configure &&  make && sudo make install
