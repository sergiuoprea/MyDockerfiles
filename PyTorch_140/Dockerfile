FROM nvidia/cuda:10.1-base-ubuntu16.04

LABEL maintainer="Sergiu Oprea <soprea@dtic.ua.es>"

# Install basic utilities such as curl, git and sudo
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    sudo \
    git \
    bzip2 \
    libx11-6 \
 && rm -rf /var/lib/apt/lists/*

# Install miniconda
ADD https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh tmp/Miniconda3-latest-Linux-x86_64.sh
RUN bash tmp/Miniconda3-latest-Linux-x86_64.sh -b
ENV PATH $PATH:/root/miniconda3/bin/

# Usefull to solve errors when Conda need to be updated
RUN conda update conda -y

# This is a list of packages and dependencies we need to work with. We copy the given file to the docker instance. Is a good option if we will create a conda environment
COPY dependencies.yml .

# We create an environment with those dependencies called carnd-term1
RUN conda env create -f dependencies.yml --name pytorch

# cleanup tarballs and downloaded package files
RUN conda clean -tp -ya 

# Create and set the workdir
RUN mkdir /src
WORKDIR "/src"

# Visdom
EXPOSE 8097

## Two Birds, One Stone
# 1. sources conda environment
# 2. prevents the zombie container issue when started as pid 1
COPY run.sh /
RUN chmod +x /run.sh
ENTRYPOINT ["/run.sh"]