# Set the base image to Ubuntu
FROM ubuntu:14.04

WORKDIR /opt 

# Update the repository sources list
RUN apt-get update && apt-get install --yes \
    build-essential \
    gcc-multilib \
    apt-utils \
    zlib1g-dev \
    vim-common \
    git \
    g++ \
    cmake \
    python \ 
    python-dev \ 
    libbz2-dev \
    libncurses-dev \
    libboost-math-dev \
    wget \
    aptitude
 
RUN aptitude install -y \
    libatlas-dev \
    liblapack-dev

RUN wget updates.iontorrent.com/tvc_standalone/tvc-5.2.2.tar.gz
 
ENV TVC_VERSION=tvc-5.2.2
ENV BUILD_ROOT_DIR=`mktemp -d`

RUN cp $TVC_VERSION.tar.gz $BUILD_ROOT_DIR

RUN DISTRIBUTION_CODENAME=`lsb_release -is`_`lsb_release -rs`_`uname -m` && \
TVC_INSTALL_DIR=$BUILD_ROOT_DIR/$TVC_VERSION-$DISTRIBUTION_CODENAME-binary && \
mkdir -p $TVC_INSTALL_DIR/bin/


# 4. build armadillo
RUN cd $BUILD_ROOT_DIR && \
wget http://updates.iontorrent.com/updates/software/external/armadillo-4.600.1.tar.gz && \
tar xvzf armadillo-4.600.1.tar.gz && \
cd armadillo-4.600.1/ && \
sed -i 's:^// #define ARMA_USE_LAPACK$:#define ARMA_USE_LAPACK:g' include/armadillo_bits/config.hpp && \
sed -i 's:^// #define ARMA_USE_BLAS$:#define ARMA_USE_BLAS:g'     include/armadillo_bits/config.hpp && \
cmake . && \
make -j4



# ENV PATH=$PATH:opt/tvc-5.2.2/bin
