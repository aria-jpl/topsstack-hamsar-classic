#!/bin/bash

set -e

# set up isce2 env
#export PATH=/opt/conda/lib/python3.8/site-packages/isce/applications:$PATH
export PATH=$ISCE_HOME/applications:$PATH
export PATH=$ISCE_STACK/topsStack:$PATH

#export PATH=/home/ops/run/topsstack/topsStack:$PATH
