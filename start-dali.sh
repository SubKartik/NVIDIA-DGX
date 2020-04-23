#!/bin/bash
# Start the NVIDIA standard build for their deep learning software.
# Includes tensorflow-gpu. python3, NVIDIA Dali, and lot of other stuff
#
docker run -it --shm-size=1g --ulimit memlock=-1 -v ~/imagenet-scratch:/imagenet-scratch -v ~/aug:/aug  nvcr.io/nvidia/tensorflow:19.12-tf1-py3  bash
