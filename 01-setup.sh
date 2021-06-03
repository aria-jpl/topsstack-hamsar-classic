#!/usr/bin/env bash

source $HOME/.bash_profile

PGE_BASE=$(cd `dirname ${BASH_SOURCE}`; pwd)
export PGE_BASE

# Get user's bounding box coordinates and outer box with integer coordinates
TOKENS=$(python ${PGE_BASE}/get_bbox.py _context.json)
IFS=" "
read MINLAT MAXLAT MINLON MAXLON MINLAT_LO MAXLAT_HI MINLON_LO MAXLON_HI <<< $TOKENS

echo "Coords:"
echo $MINLAT $MAXLAT $MINLON $MAXLON $MINLAT_LO $MAXLAT_HI $MINLON_LO $MAXLON_HI

export MINLAT MAXLAT MINLON MAXLON
export MINLAT_LO MAXLAT_HI MINLON_LO MAXLON_HI

# allowing use of the gdal_translate command
#export PATH="$PATH:/opt/conda/bin/"

# needed for Jungkyo's GNU parallel options at some steps
# 20200918, xing
# make sure gnu parallel does not invoke threads stepping on each other
#gnuParallelOptions="-j+10 --eta --load 100%"
gnuParallelOptions="-j2 --eta --load 50%"
