toolDir=../tops-stack-processor-hamsar-develop-conda-isce2/topsstack-hamsar

source ${toolDir}/00-init.sh
source ${toolDir}/01-setup.sh

#for x in 02-get-slcs 03-get-dems 04-make-run-scripts 05-make-run-scripts 06-run-01 06-run-02.0 06-run-02.5 06-run-02.9 06-run-03 06-run-04 06-run-05 06-run-06 06-run-07

#for x in 02-get-slcs; do
#for x in 03-get-dems; do
#for x in 04-make-run-scripts; do
#for x in 05-make-run-scripts; do
for x in 06-run-01; do
    sh ${toolDir}/${x}.sh 2>&1 | tee ${x}.log
done
