# Use the base image
FROM ghcr.io/romange/ubuntu-dev:20 as base

COPY ./install_docker.sh /tmp/

RUN /tmp/install_docker.sh

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_21.x | bash - && \
    apt-get install -y nodejs

# Install dependencies (if needed)
RUN apt-get install -y build-essential autoconf automake libpcre3-dev libevent-dev pkg-config zlib1g-dev git &&\
    rm -rf /var/lib/apt/lists/*

# Clone memtier_benchmark repository
RUN git clone https://github.com/RedisLabs/memtier_benchmark.git

# Build memtier_benchmark
RUN cd memtier_benchmark && autoreconf -ivf && ./configure &&  make && make install
