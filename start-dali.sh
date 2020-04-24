#/bin/bash
nvidia-docker run -it --shm-size=1g --ulimit memlock=-1 -v ~/aug:/aug -v ~/imagenet-mini:/imagenet-mini nvcr.io/nvidia/tensorflow:19.12-tf1-py3  bash
