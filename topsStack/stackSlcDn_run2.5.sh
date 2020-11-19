#!/bin/bash -f
#If config.txt not defined. Please define your inputs here
#Directories neccesary to create run_files
#run1File=./run_files/run_1_unpack_slc_topo_master
run1File=./run_files/run_01_unpack_topo_reference
run2File=./run_files/run_02_unpack_secondary_slc
runFile=./run_files/run_02.5_slc_noise_calibration
cali_code='read_calibration_slc.py'

#if [ "$1" == "-h" ]; then
#    echo -e "Usage: $0 <config_file>" 1>&2
#    echo -e "    - config_file: Path of config file which stores bbox"  
#    exit 1
#fi
#
#if ! [ -z $1 ];  then
#   source $1
#   runDir=$(dirname $run1)
#   run1File=$run1
#   runFile=$runDir/run_2.5_slc_noise_calibration
#   bbox="$bboxS $bboxN $bboxW $bboxE" 
#fi
bbox="$1 $2 $3 $4"

rm -f $runFile
touch $runFile
main_dir=$(dirname $(dirname $runFile))
master_dir=$main_dir/reference
slave_dir=$main_dir/secondary
# get master
masterConfig=$(grep reference $run1File | awk '{print $NF}')
echo "msterConfig : " $masterConfig

fzip=$(less $masterConfig | grep dirname | sed 's/dirname : \(\/.*\.zip\)/\1/')
echo "fzip : "$fzip

swath=$(grep swaths $masterConfig | sed 's/swaths : \(\.*\)/\1/')
echo "$cali_code -zip $fzip -ext $bbox -od $master_dir -o -t noise -n '$swath'" >> $runFile

# get slave
for file in $(grep secondary $run2File | awk '{print $NF}');do
    date=$(echo $file | sed 's/.*\/.*_\([0-9]\)/\1/')
    fzip=$(grep dirname $file | sed 's/dirname : \(\/.*\.zip\)/\1/')
    swath=$(grep swaths $file | sed 's/swaths : \(\.*\)/\1/')
    odir="$slave_dir/$date"
    echo "$cali_code -zip $fzip -ext $bbox -od $odir -o -t noise -n '$swath'" >> $runFile
done
echo "writing  $runFile"

