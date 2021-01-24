# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG BASE_CONTAINER=jupyter/scipy-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

# Set when building on Travis so that certain long-running build steps can
# be skipped to shorten build time.
ARG TEST_ONLY_BUILD

# Fix DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

# Julia installation
# Default values can be overridden at build time
# (ARGS are in lower case to distinguish them from ENV)
# Check https://julialang.org/downloads/
ARG julia_version="1.5.3"
# SHA256 checksum
ARG julia_checksum="f190c938dd6fed97021953240523c9db448ec0a6760b574afd4e9924ab5615f1"

# R pre-requisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    fonts-dejavu \
    gfortran \
    gcc && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Julia dependencies
# install Julia packages in /opt/julia instead of $HOME
ENV JULIA_DEPOT_PATH=/opt/julia \
    JULIA_PKGDIR=/opt/julia \
    JULIA_VERSION="${julia_version}"

WORKDIR /tmp

# hadolint ignore=SC2046
RUN mkdir "/opt/julia-${JULIA_VERSION}" && \
    wget -q https://julialang-s3.julialang.org/bin/linux/x64/$(echo "${JULIA_VERSION}" | cut -d. -f 1,2)"/julia-${JULIA_VERSION}-linux-x86_64.tar.gz" && \
    echo "${julia_checksum} *julia-${JULIA_VERSION}-linux-x86_64.tar.gz" | sha256sum -c - && \
    tar xzf "julia-${JULIA_VERSION}-linux-x86_64.tar.gz" -C "/opt/julia-${JULIA_VERSION}" --strip-components=1 && \
    rm "/tmp/julia-${JULIA_VERSION}-linux-x86_64.tar.gz"
RUN ln -fs /opt/julia-*/bin/julia /usr/local/bin/julia

# Show Julia where conda libraries are \
RUN mkdir /etc/julia && \
    echo "push!(Libdl.DL_LOAD_PATH, \"$CONDA_DIR/lib\")" >> /etc/julia/juliarc.jl && \
    # Create JULIA_PKGDIR \
    mkdir "${JULIA_PKGDIR}" && \
    chown "${NB_USER}" "${JULIA_PKGDIR}" && \
    fix-permissions "${JULIA_PKGDIR}"

USER $NB_UID

RUN echo "Giuliano :: NB_UID = $NB_UID"
RUN echo "Giuliano :: HOME   = $HOME"

# R packages including IRKernel which gets installed globally.
RUN conda install --quiet --yes \
    'r-base=4.0.3'  \
    'r-caret=6.0*' \
    'r-crayon=1.3*' \
    'r-devtools=2.3*' \
    'r-forecast=8.13*' \ 
    'r-hexbin=1.28*' \
    'r-htmltools=0.5*' \
    'r-htmlwidgets=1.5*' \ 
    'r-irkernel=1.1*' \
    'r-nycflights13=1.0*' \
    'r-randomforest=4.6*' \
    'r-rcurl=1.98*' \
    'r-rmarkdown=2.6*' \
    'r-rsqlite=2.2*' \
    'r-shiny=1.5*' \
    'r-tidyverse=1.3*' \
    'rpy2=3.3*' 
 #\
#    && \

# R packages for dynamic "report" generation
#RUN conda install --quiet --yes -c r \
#    'r-raster' \
#    'r-sp'
# USER root
# RUN apt-get install -y libfreetype6-dev # this does not work!

USER $NB_UID
# https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwjQ746Kh5jqAhWARxUIHYf9CToQFjAAegQIARAB&url=https%3A%2F%2Ftechoverflow.net%2F2019%2F06%2F11%2Fhow-to-fix-ft2build-h-no-such-file-or-directory%2F&usg=AOvVaw3QuaoknRY9ehLgQGr4oLwy
#RUN R -e "install.packages('systemfonts',configure.args='-I=/usr/include/freetype2')" # this does not work!
#RUN R -e "install.packages('rgdal',dependencies=TRUE, repos='http://cran.rstudio.com/')"
#RUN R -e "install.packages('raster',dependencies=TRUE, repos='http://cran.rstudio.com/')"
#RUN R -e "install.packages('sp',dependencies=TRUE, repos='http://cran.rstudio.com/')"
#RUN R -e "install.packages('sf',dependencies=TRUE, repos='http://cran.rstudio.com/')"

USER root
RUN conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

#USER $NB_UID
USER root

# Add Julia packages. Only add HDF5 if this is not a test-only build since
# it takes roughly half the entire build time of all of the images on Travis
# to add this one package and often causes Travis to timeout.
#
# Install IJulia as jovyan and then move the kernelspec out
# to the system share location. Avoids problems with runtime UID change not
# taking effect properly on the .local folder in the jovyan home dir.
RUN julia -e 'import Pkg; Pkg.update()' && \
    (test $TEST_ONLY_BUILD || julia -e 'import Pkg; Pkg.add("HDF5")') && \
    julia -e "using Pkg; pkg\"add IJulia\"; pkg\"precompile\"" && \
    # move kernelspec out of home \
    mv $HOME/.local/share/jupyter/kernels/julia* $CONDA_DIR/share/jupyter/kernels/ && \
    chmod -R go+rx $CONDA_DIR/share/jupyter && \
    rm -rf $HOME/.local
 #&& \

USER root
RUN fix-permissions $JULIA_PKGDIR $CONDA_DIR/share/jupyter

# LandSupport custom pre-requisites:
RUN apt-get update && apt-get -y install gdal-bin python3-gdal libpq-dev python3-psycopg2 libgdal-dev curl php-mbstring git unzip php php-pgsql php-xml php-mbstring php-zmq

RUN pip install owslib psycopg2 numpy scipy sos sos-pbs sos-notebook matlab_kernel sos-r sos-matlab sos-python sos-bash bash_kernel

RUN pip install GDAL==$(gdal-config --version) --global-option=build_ext --global-option="-I/usr/include/gdal"

RUN pip install prettytable # to create pretty tables in python

RUN python -m bash_kernel.install
RUN python -m sos.install
RUN python -m sos_notebook.install

# Questa parte rende instabile il container – commentare – 
#RUN curl -sS https://getcomposer.org/installer -o composer-setup.php
#RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
#RUN curl -sS https://litipk.github.io/Jupyter-PHP-Installer/dist/jupyter-php-installer.phar -o jupyter-php-installer.phar
#RUN php jupyter-php-installer.phar install

USER $NB_UID
RUN conda install -y -c conda-forge wgrib
RUN conda install -y -c conda-forge wgrib2

USER root

EXPOSE 80
#CMD apachectl -D FOREGROUND

#CMD jupyter kernelspec list
#
