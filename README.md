# NVIDIA-DGX TFRecord Image Augmentation

This repository contains code to perform data augmentation of image data in TFRecord format. Much of the testing was done on the Imagenet corpus which had been transformed to TFRecord datasets. That process is outside the scope of this repository but can be found at the Google Tensorflow repository on Github below.

https://github.com/tensorflow/models/blob/master/research/inception/inception/data/build_imagenet_data.py

The data augmentation is done on systems that have NVIDIA GPUs and uses the NVIDIA DALI SDK framework, using Tensorflow 1.x Python 3.x.

https://docs.nvidia.com/deeplearning/sdk/dali-developer-guide/docs/index.html

The code in this repository is written to work in with the NVIDIA NGC prebuilt containers for Tensorflow. This work was done with the nvcr.io/nvidia/tensorflow:19.12-tf1-py3 docker container. Please see 

https://ngc.nvidia.com/catalog/containers/nvidia:tensorflow to get started.

The bash script start-dali.sh starts the 19.12-tf1-py3 Docker container, setting the DALI required environment variable, DALI_EXTRA_PATH. The command to run the container is shown below.

  $nvidia-docker run -it --shm-size=1g --ulimit memlock=-1 -e "DALI_EXTRA_PATH=/base" -v ~/aug:/aug -v /imagenet-data:/base nvcr.io/nvidia/tensorflow:19.12-tf1-py3  bash

External directories are passed into the container (using docker -v) pointing to the input/output TFRecord path (/base) and the code (/aug). The "/base" directory tree contains the input data and will hold the output data by default. The code an be modified to change that. The /aug directory tree contains the Python to read the TFRecords, augment the images, and write out the augmented TFRecord files. 

The main program here is tfdali.py which takes one option and an argument. An example of how this is invoked in the container is shown below.

  $python ./tfdali.py --mode [cpu|gpu] input-tfrecord-file

The mode "cpu" instructs all DALI functions to run only on the CPU, while mode "gpu" uses the gpu wherever possible. Note that this only affects the behavior of DALI functions. The Docker container uses tensorflow-gpu so Tensorflow itself uses the GPUs whenever possible independent of the mode chosen. The directory that tfdali.py is invoked in will also be used to create a TFRecord Index directory (idx*).

Please note that the function ImageDecoder() in the python module nvidia.dali.ops cannot be used in "gpu" mode, and only supports "cpu" or "mixed" as per the DALI documentation.The code accounts for this.

All the input data is assumed to reside in /base/input from within the container, and the output augmented TFRecords are assumed to be written to /base/output. The user may need to create these directories if they don't exist, or may choose to change this in the code.

The augmentations include resize, flips, rotations and crops of the original image - the code is self explanatory. There are other operations that are available from the DALI Library. 

As the problem of augmenting images is intrinsically an emabarassingly parallel problem, bulk transformations have been done by running several tfdali.py instances in parallel, and is limited by number of cores or GPU memory constraints, and can be extended to multiple servers with GPUs. 

This code is released under the MIT License as included in this repository. Please contact kartik@vastdata.com in case of questions or comments.
  
