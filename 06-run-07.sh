## STEP 7 ##
start=`date +%s`
#echo "cat run_files/run_07_merge  | parallel ${gnuParallelOptions}"
echo "cat run_files/run_07_merge_reference_secondary_slc | parallel ${gnuParallelOptions}"
#cat run_files/run_07_merge | parallel ${gnuParallelOptions}
cat run_files/run_07_merge_reference_secondary_slc | parallel ${gnuParallelOptions}
end=`date +%s`
runtime7=$((end-start))
echo $runtime7
