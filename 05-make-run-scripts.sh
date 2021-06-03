echo "**********************************"
# creating run2.5 run file
cmd="stackSlcDn_run2.5.sh $MINLAT $MAXLAT $MINLON $MAXLON"
echo "Making read_calibration_slc.py runfile: $cmd"
eval $cmd
echo "**********************************"
