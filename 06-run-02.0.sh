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
