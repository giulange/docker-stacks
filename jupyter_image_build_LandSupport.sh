#!/bin/bash
#
# it includes changes required by landsupport in this two files:
#   - jupyter-dockerstacks/base-notebook/Dockerfile
#   - jupyter-dockerstacks/datascience-notebook/Dockerfile


defval="jupyter"
container=${1:-$defval}

echo "Building $container image..."

# go to current jupyter repository:
#cd /home/release/git/jupyter-dockerstacks/

#==EITHER==
# build all:
#make build-all

#==OR==
# build chain step-by-step till datascience-notebook
#
# -01-
make build/base-notebook 
#
# -02-
make build/minimal-notebook 
#
# -03-
make build/scipy-notebook 
#
# -04-
make build/datascience-notebook
#docker tag jupyter/datascience-notebook:latest $container
#docker rmi jupyter/datascience-notebook:latest 
#
# -05- 
cd extended-notebook/
sh build.sh
docker tag jupyter/r-extended $container
#docker rmi jupyter/r-extended
#


echo "...done!"
echo ""
echo ""


