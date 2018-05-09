help:
	@cat Makefile

CONTAINER_NAME=sergiu
TAG=nvidia/cuda9.0-cudnn7-keras:$(CONTAINER_NAME)
JUPYTER_PORT=8900
DATA?="${HOME}/Data"
GPU?=1
DOCKER_FILE=Dockerfile
DOCKER=GPU=$(GPU) nvidia-docker
BACKEND=tensorflow
PYTHON_VERSION?=3.6
CUDA_VERSION?=9.0
CUDNN_VERSION?=7
TEST=tests/
SRC?=$(shell dirname `pwd`)

exec:
	nvidia-docker exec -it $(CONTAINER_NAME) bash

run:
	NV_GPU=$(GPU) nvidia-docker run -it --rm -p $(JUPYTER_PORT):8888 --shm-size 8G -v $(DATA):/data --name felipe nvidia/cuda9.0-cudnn7-keras:felipe bash

image:
	docker build --rm -t $(TAG) --build-arg python_version=$(PYTHON_VERSION) --build-arg cuda_version=$(CUDA_VERSION) --build-arg cudnn_version=$(CUDNN_VERSION) -f $(DOCKER_FILE) .

bash: build
	$(DOCKER) run -it -v $(SRC):/src/workspace -v $(DATA):/data --env KERAS_BACKEND=$(BACKEND) keras bash

ipython: build
	$(DOCKER) run -it -v $(SRC):/src/workspace -v $(DATA):/data --env KERAS_BACKEND=$(BACKEND) keras ipython

notebook: build
	$(DOCKER) run -it -v $(SRC):/src/workspace -v $(DATA):/data --net=host --env KERAS_BACKEND=$(BACKEND) keras

test: build
	$(DOCKER) run -it -v $(SRC):/src/workspace -v $(DATA):/data --env KERAS_BACKEND=$(BACKEND) keras py.test $(TEST)

