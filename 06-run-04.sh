## STEP 4 ##
start=`date +%s`
echo "cat run_files/run_04_fullBurst_geo2rdr  | parallel ${gnuParallelOptions}"
cat run_files/run_04_fullBurst_geo2rdr  | parallel ${gnuParallelOptions}
end=`date +%s`
runtime4=$((end-start))
echo $runtime4

