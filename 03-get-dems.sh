#!/usr/bin/env bash

set -e 

echo dem.py -a stitch -b $MINLAT_LO $MAXLAT_HI $MINLON_LO $MAXLON_HI -r -s 1 -c -f
dem.py -a stitch -b $MINLAT_LO $MAXLAT_HI $MINLON_LO $MAXLON_HI -r -s 1 -c -f >&1 | tee dem.txt

# Find wgs84 file
if [[ -f dem.txt ]]; 
then
    WGS84=`awk '/wgs84/ {print $NF;exit}' dem.txt`
    if [[ -f "${WGS84}" ]]; 
    then
	echo "Found wgs84 file: ${WGS84}"
        echo "fixImageXml.py -f -i ${WGS84}"
        fixImageXml.py -f -i ${WGS84}
    else
        echo "NO WGS84 FILE FOUND" 
        exit 1
    fi
fi
