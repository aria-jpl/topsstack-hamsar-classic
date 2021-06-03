# Getting MASTER_DATE environment variable
MASTER_DATE=$(python ${PGE_BASE}/get_master_date.py)

WGS84=`awk '/wgs84/ {print $NF;exit}' dem.txt`

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
