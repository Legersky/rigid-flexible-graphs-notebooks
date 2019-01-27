# Dockerfile for binder
# Reference: https://mybinder.readthedocs.io/en/latest/dockerfile.html#preparing-your-dockerfile

FROM sagemath/sagemath:8.4
# FROM computop/sage

ARG QD_VERSION=2.3.17
ARG PHC_VERSION=v2.4.52

COPY scripts/03_phcpy.sh .
COPY scripts/makefile_unix.patch . 

# Install wget and install/updates certificates  https://github.com/jwilder/nginx-proxy/issues/79
RUN apt-get update \
 && apt-get install -y -q --no-install-recommends \
    ca-certificates \
 && apt-get clean \
 && rm -r /var/lib/apt/lists/*

RUN wget -nv -O /tmp/tarballs/qd.tar.gz \
        http://crd.lbl.gov/~dhbailey/mpdist/qd-$QD_VERSION.tar.gz && \
    wget -nv -O /tmp/tarballs/PHC.tar.gz \
    	https://github.com/janverschelde/PHCpack/archive/$PHC_VERSION.tar.gz && \
    /bin/bash 03_phcpy.sh /sage /tmp/tarballs  && \
    sudo rm -rf /tmp/scripts/* /tmp/tarballs/* 


RUN sage -pip install jupyterlab

# Copy the contents of the repo in ${HOME}
COPY --chown=sage:sage . ${HOME}
