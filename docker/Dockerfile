FROM hysds1/pge-base-conda-isce2:20201212
#FROM hysds/isce2:latest-es1

# Set to root user
USER root

# Install necessary libraries
RUN /opt/conda/bin/conda install -y -c conda-forge jq parallel \
 && /opt/conda/bin/pip install opencv-python

# Set to ops user
USER ops

# Copy topsStack PGE into docker image
COPY . /home/ops/verdi/ops/topsstack

# add topsStack code to path
ENV PATH /opt/isce2/src/isce2/contrib/stack/topsStack/:/home/ops/verdi/ops/topsstack/topsStack:${PATH}

# Change to work directory
WORKDIR /home/ops

# Run shell
CMD ["/bin/bash", "--login"]
