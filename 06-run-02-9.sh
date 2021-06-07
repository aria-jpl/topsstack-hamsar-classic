# 20201028, xing
# to discard subswaths that are in boundary condition of sometimes being included per polygon
start=`date +%s`
echo "discard subswaths not to be used"
#find ./master -type d; find ./slaves -type d
python ${PGE_BASE}/clean_IW_dirs.py
#find ./master -type d; find ./slaves -type d
end=`date +%s`
runtimeDiscardSubswaths=$((end-start))
echo $runtimeDiscardSubswaths

