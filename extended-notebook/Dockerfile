# Copyright (c) LandSupport Project 
# Distributed under the terms of the Modified BSD License.


#FROM rocker/tidyverse:latest # this is for rstudio, I prefer cran/debian
#FROM cran/debian
## see https://hub.docker.com/r/cran/debian


#ARG BASE_CONTAINER=jupyter
FROM jupyter/datascience-notebook

LABEL maintainer="Giuliano Langella <glangella@unina.it>"

USER root

#RUN apt-get install -y libgit2-dev # usefull ?

RUN conda install -y -c conda-forge \
	libgit2 \
	udunits2 \
	unixodbc \
	proj4 \
	gdal

#RUN conda install -y -c r \
RUN conda install --quiet --yes \
	'r-sp' \
	'r-raster' \
	'r-gtools' \
	'r-rgeos' \
	'r-rgdal' \
	'r-sf' \
	'r-devtools' \
	'r-gstat' 


USER root
RUN conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER


USER root
EXPOSE 80

