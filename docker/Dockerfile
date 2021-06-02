FROM hysds1/pge-base-conda-isce2:20201212
#FROM hysds/isce2:latest-es1

# these env vars are defined and configured by 
# base image hysds1/pge-base-conda-isce2:20201212
#ISCE_STACK=/opt/conda/share/isce2
#ISCE_HOME=/opt/conda/lib/python3.8/site-packages/isce

# Set to root user
USER root

# Install necessary libraries
RUN /opt/conda/bin/conda install -y -c conda-forge jq parallel \
 && /opt/conda/bin/pip install opencv-python

# Set to ops user
USER ops

# have a local isce2/topsStack with fetchOrbit-asf.py
# under /home/ops/verdi/ops/isce2/topsStack
RUN mkdir -p /home/ops/verdi/ops/isce2
RUN cp -ai /opt/conda/share/isce2/topsStack /home/ops/verdi/ops/isce2
RUN mv /home/ops/verdi/ops/isce2/topsStack/fetchOrbit.py /home/ops/verdi/ops/isce2/topsStack/fetchOrbit.py.ori
COPY barn/fetchOrbit-asf.py /home/ops/verdi/ops/isce2/topsStack
RUN ln -sf /home/ops/verdi/ops/isce2/topsStack/fetchOrbit-asf.py /home/ops/verdi/ops/isce2/topsStack/fetchOrbit.py

# Copy topsStack PGE into docker image
COPY . /home/ops/verdi/ops/topsstack

# add topsStack code to path
#ENV PATH /home/ops/verdi/ops/isce2/topsStack:/home/ops/verdi/ops/topsstack/topsStack:${PATH}
#ENV PATH /home/ops/verdi/ops/topsstack/topsStack:/home/ops/verdi/ops/isce2/topsStack:${ISCE_HOME}/applications:${PATH}

# Change to work directory
WORKDIR /home/ops

# Run shell
CMD ["/bin/bash", "--login"]
