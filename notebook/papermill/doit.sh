#!/bin/bash

set -e


papermill python.ipynb python-out.ipynb -p lat_min 35.57793709766442 \
    -p lat_max 36.21619047354823
