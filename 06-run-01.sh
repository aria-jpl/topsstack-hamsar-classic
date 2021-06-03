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

