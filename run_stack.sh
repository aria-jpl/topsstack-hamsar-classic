#!/usr/bin/env bash

source $HOME/.bash_profile
#source /opt/isce2/isce_env.sh


conda activate
export ISCE_STACK=/opt/conda/share/isce2/topsStack/stackSentinel.py
export PATH=$PATH:$ISCE_HOME/bin:$ISCE_HOME/applications:$ISCE_STACK

# Saving the processing start time for .met.json file
export PROCESSING_START=$(date +%FT%T)

set -e 
PGE_BASE=$(cd `dirname ${BASH_SOURCE}`; pwd)

# Get user's bounding box coordinates and outer box with integer coordinates
TOKENS=$(python ${PGE_BASE}/get_bbox.py _context.json)
IFS=" "
read MINLAT MAXLAT MINLON MAXLON MINLAT_LO MAXLAT_HI MINLON_LO MAXLON_HI <<< $TOKENS

echo "Coords:"
echo $MINLAT $MAXLAT $MINLON $MAXLON $MINLAT_LO $MAXLAT_HI $MINLON_LO $MAXLON_HI

# Prep SLCs
mkdir zip
mv S1*/*.zip zip

# Get DEM
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

# Getting MASTER_DATE environment variable
export MASTER_DATE=$(python ${PGE_BASE}/get_master_date.py)

# Create stack processor run scripts (after checking for MASTER DATE)
if [[ "$MASTER_DATE" ]]; then
	echo "MASTER_DATE exists: ${MASTER_DATE}"
	echo stackSentinel.py -s zip/ -d ${WGS84} -a AuxDir/ -m ${MASTER_DATE} -o Orbits -b "${MINLAT} ${MAXLAT} ${MINLON} ${MAXLON}" -W slc -C geometry
	stackSentinel.py -s zip/ -d $WGS84 -a AuxDir/ -m $MASTER_DATE -o Orbits -b "$MINLAT $MAXLAT $MINLON $MAXLON" -W slc -C geometry
else
	echo "MASTER_DATE DOES NOT EXIST"
	echo stackSentinel.py -s zip/ -d $WGS84 -a AuxDir/ -o Orbits -b "$MINLAT $MAXLAT $MINLON $MAXLON" -W slc -C geometry
	stackSentinel.py -s zip/ -d $WGS84 -a AuxDir/ -o Orbits -b "$MINLAT $MAXLAT $MINLON $MAXLON" -W slc -C geometry
fi


# allowing use of the gdal_translate command
export PATH="$PATH:/opt/conda/bin/"

echo "**********************************"
# creating run2.5 run file
cmd="stackSlcDn_run2.5.sh $MINLAT $MAXLAT $MINLON $MAXLON"
echo "Making read_calibration_slc.py runfile: $cmd"
eval $cmd
echo "**********************************"

# 20200918, xing
# make sure gnu parallel does not invoke threads stepping on each other
#gnuParallelOptions="-j+10 --eta --load 100%"
gnuParallelOptions="-j2 --eta --load 50%"


# Jungkyo's GNU parallel for running all steps
###########################################################################
## STEP 1 ##
start=`date +%s`
#echo "sh run_files/run_01_unpack_topo_master"
echo "sh run_files/run_01_unpack_topo_reference"
#sh run_files/run_01_unpack_topo_master
sh run_files/run_01_unpack_topo_reference
end=`date +%s`
runtime1=$((end-start))
echo $runtime1

## STEP 2 ##
start=`date +%s`
#Num=`cat run_files/run_02_unpack_slave_slc | wc | awk '{print $1}'`
Num=`cat run_files/run_02_unpack_secondary_slc | wc | awk '{print $1}'`
echo $Num
#echo "cat run_files/run_02_unpack_slave_slc | parallel ${gnuParallelOptions}"
echo "cat run_files/run_02_unpack_secondary_slc | parallel ${gnuParallelOptions}"
#cat run_files/run_02_unpack_slave_slc | parallel ${gnuParallelOptions}
cat run_files/run_02_unpack_secondary_slc | parallel ${gnuParallelOptions}
end=`date +%s`

runtime2=$((end-start))
echo runtime2


## STEP 2.5 ##
start=`date +%s`
echo "cat run_files/run_02.5_slc_noise_calibration | parallel ${gnuParallelOptions}"
cat run_files/run_02.5_slc_noise_calibration | parallel ${gnuParallelOptions}
end=`date +%s`

runtime2x5=$((end-start))
echo $runtime2x5


# 20201028, xing
# to discard subswaths that are in boundary condition of sometimes being included per polygon
start=`date +%s`
echo "discard subswaths not to be used"
#find ./master -type d; find ./slaves -type d
python ${PGE_BASE}/clean_IW_dirs.py
#find ./master -type d; find ./slaves -type d
end=`date +%s`
runtimeDiscardSubswaths=$((end-start))
echo $runtimeDiscardSubswaths


## STEP 3 ##
start=`date +%s`
echo "cat run_files/run_03_average_baseline | parallel ${gnuParallelOptions}"
cat run_files/run_03_average_baseline | parallel ${gnuParallelOptions}
end=`date +%s`
runtime3=$((end-start))
echo $runtime3

## STEP 4 ##
start=`date +%s`
echo "cat run_files/run_04_fullBurst_geo2rdr  | parallel ${gnuParallelOptions}"
cat run_files/run_04_fullBurst_geo2rdr  | parallel ${gnuParallelOptions}
end=`date +%s`
runtime4=$((end-start))
echo $runtime4

## STEP 5 ##
start=`date +%s`
echo "cat run_files/run_05_fullBurst_resample  | parallel ${gnuParallelOptions}"
cat run_files/run_05_fullBurst_resample  | parallel ${gnuParallelOptions}
end=`date +%s`
runtime5=$((end-start))
echo $runtime5

## STEP 6 ##
start=`date +%s`
echo "sh run_files/run_06_extract_stack_valid_region"
sh run_files/run_06_extract_stack_valid_region
end=`date +%s`
runtime6=$((end-start))
echo $runtime6

## STEP 7 ##
start=`date +%s`
echo "cat run_files/run_07_merge  | parallel ${gnuParallelOptions}"
cat run_files/run_07_merge | parallel ${gnuParallelOptions}
end=`date +%s`
runtime7=$((end-start))
echo $runtime7

### STEP 7 ##
#start=`date +%s`
#echo "cat run_files/run_7_geo2rdr_resample   | parallel ${gnuParallelOptions}"
#cat run_files/run_7_geo2rdr_resample   | parallel ${gnuParallelOptions}
#end=`date +%s`
#runtime7=$((end-start))
#echo $runtime7
#
### STEP 8##
#start=`date +%s`
#echo "sh run_files/run_8_extract_stack_valid_region"
#sh run_files/run_8_extract_stack_valid_region
#end=`date +%s`
#runtime8=$((end-start))
#echo $runtime8
#
#
### STEP 9 ##
#start=`date +%s`
#echo "cat run_files/run_9_merge  | parallel ${gnuParallelOptions}"
#cat run_files/run_9_merge  | parallel ${gnuParallelOptions}
#end=`date +%s`
#runtime9=$((end-start))
#echo $runtime9
#
### STEP 9 ##
#start=`date +%s`
#echo "cat run_files/run_10_grid_baseline  | parallel ${gnuParallelOptions}"
#cat run_files/run_10_grid_baseline  | parallel ${gnuParallelOptions}
#end=`date +%s`
#runtime10=$((end-start))
#echo $runtime10

## SUMMARY ##
echo "@@@@ SUMMARY  @@@@@@"
echo "@ Step 1:  $runtime1"
echo "@ Step 2:  $runtime2"
echo "@ Step 3:  $runtime3"
echo "@ Step 4:  $runtime4"
echo "@ Step 5:  $runtime5"
echo "@ Step 6:  $runtime6"
echo "@ Step 7:  $runtime7"
#echo "@ Step 8:  $runtime8"
#echo "@ Step 9:  $runtime9"
#echo "@ Step 10:  $runtime10"
###########################################################################


# Publishing dataset after stack processor completes
python /home/ops/verdi/ops/topsstack/create_dataset.py
