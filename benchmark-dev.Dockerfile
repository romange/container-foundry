FROM bitnami/kubectl:1.29.4 AS kubectl

# Use the base image
FROM ghcr.io/romange/ubuntu-dev:20 AS base

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_21.x | bash - && \
    apt-get install -y nodejs

# Install Kubectl
COPY --from=kubectl /opt/bitnami/kubectl/bin/kubectl /usr/local/bin/

# Install AWS CLI
RUN pip install awscli
