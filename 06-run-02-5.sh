## STEP 2.5 ##
start=`date +%s`
echo "cat run_files/run_02.5_slc_noise_calibration | parallel ${gnuParallelOptions}"
cat run_files/run_02.5_slc_noise_calibration | parallel ${gnuParallelOptions}
end=`date +%s`

runtime2x5=$((end-start))
echo $runtime2x5


