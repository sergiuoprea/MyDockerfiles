FROM ubuntu:18.04

LABEL maintainer="Sergiu Oprea <soprea@dtic.ua.es>"

ADD https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh tmp/Miniconda3-latest-Linux-x86_64.sh
RUN bash tmp/Miniconda3-latest-Linux-x86_64.sh -b
ENV PATH $PATH:/root/miniconda3/bin/

# Usefull to solve errors when Conda need to be updated
#RUN conda update conda -y

# This is a list of packages and dependencies we need to work with. We copy the given file to the docker instance. Is a good option if we will create a conda environment
COPY environment.yml .

# We create an environment with those dependencies called carnd-term1
RUN conda env create -f environment.yml --name py38

# cleanup tarballs and downloaded package files
#RUN conda clean -tp -y

# Set up our notebook config.
COPY jupyter_notebook_config.py /root/.jupyter/

# Setting our workdir
RUN mkdir /src
WORKDIR "/src"

# Jupyter
EXPOSE 8888

## Two Birds, One Stone
# 1. sources conda environment
# 2. prevents the zombie container issue when started as pid 1
COPY run.sh /
RUN chmod +x /run.sh
ENTRYPOINT ["/run.sh"]