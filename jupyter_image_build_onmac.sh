#!/bin/bash

defval="jupyter"
container=${1:-$defval}

echo "Building $container container..."

# go to current jupyter repository:
cd ~/git/docker-stacks/

#==EITHER==
# build all:
#make build-all
#==OR==
# build chain step-by-step till datascience-notebook
make build/base-notebook 
make build/minimal-notebook 
make build/scipy-notebook 
make build/datascience-notebook 

# it includes changes required by landsupport in this two files:
#   - jupyter-dockerstacks/base-notebook/Dockerfile
#   - jupyter-dockerstacks/datascience-notebook/Dockerfile

# rename the image as jupyter to be coherent with the LandSupport jupyter.run file:
docker tag jupyter/datascience-notebook:latest $container
#docker rmi jupyter/datascience-notebook:latest

echo "...done!"
echo ""
echo ""


