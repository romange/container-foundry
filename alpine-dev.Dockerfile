FROM alpine:latest

LABEL org.opencontainers.image.source https://github.com/romange/container-foundry

# To avoid tzdata reconfigure
# ENV DEBIAN_FRONTEND=noninteractive
# 
RUN apk --no-cache add autoconf-archive automake bash bison boost1.77-dev cmake curl ccache \
        git gcc g++ libunwind-dev libtool libxml2-dev make ninja openssl-dev patch zip \
     && rm -rf /var/cache/apk/*        
    
