#!/bin/bash

nvidia-docker build --rm --tag nvidia/cuda8.0-cudnn5:torch .
