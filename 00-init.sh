#!/bin/bash

set -e

# these env vars are defined and configured by
# hysds1/pge-base-conda-isce2:20201212
# the base used by this PGE
#ISCE_STACK=/opt/conda/share/isce2
#ISCE_HOME=/opt/conda/lib/python3.8/site-packages/isce

# isce2 tools
export PATH=$ISCE_HOME/applications:$PATH
# local isce2/topsStack with fetchOrbit-asf.py
export PATH=/home/ops/verdi/ops/isce2/topsStack:$PATH
# tools from EOS
export PATH=/home/ops/verdi/ops/topsstack/topsStack:$PATH
