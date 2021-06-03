## STEP 6 ##
start=`date +%s`
echo "sh run_files/run_06_extract_stack_valid_region"
sh run_files/run_06_extract_stack_valid_region
end=`date +%s`
runtime6=$((end-start))
echo $runtime6

