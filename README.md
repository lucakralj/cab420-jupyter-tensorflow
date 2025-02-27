# CAB420 Jupyterlabs Tensorflow container
This repository contains the source files needed to build a Docker container to meet the requirements for the CAB420 Machine Learning unit. 
This container has support to use with the Runpod service. Runpod is a cloud GPU provider. 

The Docker container can be found here on [Dockerhub](https://hub.docker.com/r/lucakralj/cab420-jupyter-tensorflow)

# Prerequisites 
  - `Docker`.
    - A docker installation is operating system dependant. Find more information [here](https://docs.docker.com/engine/) to choose the correct installation method for you.
  - `buildx`.
    - A docker bake file (docker-bake.hcl) has been included. You can remove this and build normally if you wish.
  - `Git` 
    - `Git` is needed to clone the repository in order to build the Docker image. 

# Running the Docker container locally

## Build Instructions
```
  # clone the repository 

  git clone https://github.com/lucakralj/cab420-jupyter-tensorflow

  # change directory into the cab420-jupyter-tensorflow directory
  cd cab420-jupyter-tensorflow
  
  # build the docker container
  docker buildx bake -f docker-bake.hcl
```
## Running the container locally 
```
docker run lucakralj/cab420-jupyter-tensorflow
```

# Running the container on Runpod 
1. Login to Runpod
2. Navigate to Pods
3. Deploy a Pod
4. Choose a GPU
5. Change or add a template
6. Search for the template 'cab420-jupyter-tensorflow'
7. Choose your pricing and deploy
8. Navigate to Pods to see your deployed container pull the docker containers
9. In the logs you will see the output for your Token. Copy this and use it to login to jupyterlabs.
