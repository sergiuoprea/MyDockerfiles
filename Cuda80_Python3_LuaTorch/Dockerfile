# From defines the base image
FROM nvidia/cuda:8.0-cudnn5-devel-ubuntu16.04

LABEL maintainer="Sergiu Oprea <soprea@dtic.ua.es>"

#Install dependencies for OpenBLAS, Jupyter, and Torch
RUN apt-get update \
 && apt-get install -y \
    build-essential git gfortran \
    python3 python3-setuptools python3-dev \
    cmake curl wget unzip libreadline-dev libjpeg-dev libpng-dev ncurses-dev \
    imagemagick gnuplot gnuplot-x11 libssl-dev libzmq3-dev graphviz \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install OpenBLAS
RUN git clone https://github.com/xianyi/OpenBLAS.git /tmp/OpenBLAS \
 && cd /tmp/OpenBLAS \
 && [ $(getconf _NPROCESSORS_ONLN) = 1 ] && export USE_OPENMP=0 || export USE_OPENMP=1 \
 && make -j $(getconf _NPROCESSORS_ONLN) NO_AFFINITY=1 \
 && make install \
 && rm -rf /tmp/OpenBLAS

# Install Jupyter
RUN easy_install3 pip \
 && pip install 'notebook==4.2.1' jupyter

# Install conda
ADD https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh tmp/Miniconda3-latest-Linux-x86_64.sh
RUN bash tmp/Miniconda3-latest-Linux-x86_64.sh -b
ENV PATH $PATH:/root/miniconda3/bin/

# This is a list of packages and dependencies we need to work with. We copy the given file to the docker instance. Is a good option if we will create a conda environment
COPY environment.yml .

# We create an environment with those dependencies called carnd-term1
RUN conda env create -f environment.yml --name pythonenv

# Install Torch
ARG TORCH_DISTRO_COMMIT=9c2ef7f185c682ea333e06654cb6e5b67dfe7cd2
RUN git clone https://github.com/torch/distro.git ~/torch --recursive \
 && cd ~/torch \
 && git checkout "$TORCH_DISTRO_COMMIT" \
 && ./install.sh

# Export environment variables manually
ENV LUA_PATH='/root/.luarocks/share/lua/5.1/?.lua;/root/.luarocks/share/lua/5.1/?/init.lua;/root/torch/install/share/lua/5.1/?.lua;/root/torch/install/share/lua/5.1/?/init.lua;./?.lua;/root/torch/install/share/luajit-2.1.0-alpha/?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua' \
    LUA_CPATH='/root/.luarocks/lib/lua/5.1/?.so;/root/torch/install/lib/lua/5.1/?.so;./?.so;/usr/local/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so' \
    PATH=/root/torch/install/bin:$PATH \
    LD_LIBRARY_PATH=/root/torch/install/lib:$LD_LIBRARY_PATH \
    DYLD_LIBRARY_PATH=/root/torch/install/lib:$DYLD_LIBRARY_PATH


RUN luarocks install cutorch

RUN luarocks install cunn

RUN luarocks install cudnn

RUN luarocks install nnx

RUN luarocks install nngraph

RUN luarocks install paths

RUN luarocks install display

RUN luarocks install torchnet

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#Set working dir
RUN mkdir /src
WORKDIR /src

# Install CuDNN with Torch bindings
RUN luarocks install https://raw.githubusercontent.com/soumith/cudnn.torch/R5/cudnn-scm-1.rockspec

# Set up notebook config
COPY jupyter_notebook_config.py /root/.jupyter/

# Jupyter port
EXPOSE 8888

#For using Tesla k40
#ENV CUDA_VISIBLE_DEVICES=0

#For using Tesla k20
#ENV CUDA_VISIBLE_DEVICES=1

COPY run.sh /
RUN chmod +x /run.sh
ENTRYPOINT ["/run.sh"]
