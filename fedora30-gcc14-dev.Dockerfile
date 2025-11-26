# syntax=docker/dockerfile:1
FROM fedora:30

LABEL org.opencontainers.image.source="https://github.com/romange/container-foundry"

# Configure archive repositories since Fedora 30 is EOL
RUN sed -i 's|^metalink=|#metalink=|g' /etc/yum.repos.d/*.repo && \
    sed -i 's|^#baseurl=http://download.fedoraproject.org/pub/fedora/linux/|baseurl=https://archives.fedoraproject.org/pub/archive/fedora/linux/|g' /etc/yum.repos.d/*.repo && \
    sed -i 's|^#baseurl=http://download.example/pub/fedora/linux/|baseurl=https://archives.fedoraproject.org/pub/archive/fedora/linux/|g' /etc/yum.repos.d/*.repo

COPY ./install_boost.sh ./get_cmake.sh ./get_gcc14.sh /tmp/

# Install base development tools and GCC 14 build dependencies
RUN dnf install -y automake gcc-c++ git libtool make ninja-build \
     openssl-devel libunwind-devel autoconf-archive patch wget bzip2 xz tar \
     openssl-static pcre2-devel zlib-devel gdb ccache \
     gmp-devel mpfr-devel libmpc-devel flex texinfo diffutils file which

RUN dnf install -y bison libzstd-static --releasever=32

# Build and install GCC 14
RUN /tmp/get_gcc14.sh

# Set up environment to use GCC 14
ENV PATH="/opt/gcc-14/bin:${PATH}" \
    LD_LIBRARY_PATH="/opt/gcc-14/lib64:${LD_LIBRARY_PATH}" \
    CC="/opt/gcc-14/bin/gcc" \
    CXX="/opt/gcc-14/bin/g++"

# Install Boost and CMake
RUN /tmp/install_boost.sh && /tmp/get_cmake.sh

RUN mkdir -p ~/.config/gdb && echo 'set history save on' >> ~/.config/gdb/gdbinit \
    && echo 'set debuginfod enabled off' >> ~/.config/gdb/gdbinit
