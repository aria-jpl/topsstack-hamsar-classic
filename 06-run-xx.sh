# these are kept for reference. may be useful later.

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
