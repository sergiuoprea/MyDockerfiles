FROM nvidia/cuda:9.0-cudnn7-runtime-ubuntu16.04
MAINTAINER Sergiu Oprea <soprea@dtic.ua.es>

RUN apt-get update --fix-missing

# Supress warnings about missing front-end. As recommended at:
# http://stackoverflow.com/questions/22466255/is-it-possibe-to-answer-dialog-questions-when-installing-under-docker
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y --no-install-recommends apt-utils

# Developer Essentials
RUN apt-get install -y --no-install-recommends git curl vim unzip wget

# Build tools
RUN apt-get install -y --no-install-recommends build-essential cmake pkg-config software-properties-common

# OpenBLAS
RUN apt-get install -y --no-install-recommends libopenblas-dev

######################################
# OpenCV dependencies ################
######################################

# RUN apt install -y libsm6 libxext6

RUN apt-get install -y --no-install-recommends \
   libjpeg8-dev libtiff5-dev libjasper-dev libpng12-dev \
   libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libgtk2.0-dev \
   liblapacke-dev checkinstall

#######################################
# Python 3.6 ##########################
#######################################

RUN add-apt-repository ppa:jonathonf/python-3.6
RUN apt-get update
RUN apt-get install -y --no-install-recommends python3.6 python3.6-dev python3.6-distutils

# Pip
RUN curl https://bootstrap.pypa.io/get-pip.py | python3.6

RUN pip install --no-cache-dir --upgrade pip setuptools

# Aliases
RUN echo "alias python='python3'" >> /root/.bash_aliases
RUN echo "alias pip='pip3'" >> /root/.bash_aliases

# Pillow and it's dependencies
RUN apt-get install -y --no-install-recommends libjpeg-dev zlib1g-dev
RUN pip --no-cache-dir install Pillow

# Other libraries
RUN pip --no-cache-dir install \
    numpy scipy sklearn scikit-image pandas matplotlib h5py opencv-python scikit-learn seaborn moviepy keras
 

#######################################
# Anaconda ############################
#######################################
# ADD https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh tmp/Miniconda3-latest-Linux-x86_64.sh
# RUN bash tmp/Miniconda3-latest-Linux-x86_64.sh -b
# ENV PATH $PATH:/root/miniconda3/bin/


#######################################
# Jupyter Notebook ####################
#######################################
RUN pip --no-cache-dir install jupyter

# Set up our notebook config.
COPY jupyter_notebook_config.py /root/.jupyter/

#######################################
# Tensorflow GPU ######################
#######################################
RUN pip install --no-cache-dir --upgrade tensorflow-gpu 


#######################################
# OpenCV from sources #################
#######################################

# Get source from github
# RUN git clone -b 3.2.0 --depth 1 https://github.com/opencv/opencv.git /usr/local/src/opencv
# Compile
# RUN cd /usr/local/src/opencv && mkdir build && cd build && \
#    cmake -D CMAKE_INSTALL_PREFIX=/usr/local \
#          -D BUILD_TESTS=OFF \
#          -D BUILD_PERF_TESTS=OFF \
#          -D PYTHON_DEFAULT_EXECUTABLE=$(which python3) \
#          .. && \
#    make -j"$(nproc)" && \
#    make install


#######################################
# Keras ###############################
#######################################
RUN pip install --no-cache-dir --upgrade h5py pydot_ng keras


#######################################
# PyTorch 0.4.0 ########################
#######################################
RUN pip install http://download.pytorch.org/whl/cu90/torch-0.4.0-cp36-cp36m-linux_x86_64.whl   
RUN pip install torchvision

#######################################
# Visdom ##############################
#######################################
RUN pip install visdom

#######################################
# Screen ##############################
#######################################
RUN apt-get install screen

#######################################
# Cleanup #############################
#######################################
RUN apt-get clean && \
    apt-get autoremove


# Setting our workdir
RUN mkdir /src
WORKDIR "/src"

# Make sure CUDNN is detected
ENV LD_LIBRARY_PATH /usr/local/cuda/lib64/:$LD_LIBRARY_PATH
RUN ln -s /usr/local/cuda/lib64/libcudnn.so.5 /usr/local/cuda/lib64/libcudnn.so

# For CUDA profiling, Tensorflow requires CUPTI
ENV LD_LIBRARY_PATH /usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH

# VISDOM
EXPOSE 8097
# Jupyter
EXPOSE 8888

COPY run.sh /
RUN chmod +x /run.sh
ENTRYPOINT ["/run.sh"]
