#!/bin/bash
##copy the files from BU Server to the destination Directory####################
# Go to the Directory of Dicoms in Scannexus
PrPth='/media/g/P04/Data/'
subjID='sub-12'
mkdir ${PrPth}${subjID}
PrSrcPth='/run/user/1000/gvfs/smb-share:server=busrv0001,share=backedupdata/Yawen.Wang/20201102_BI_S18_SES01/'
cp -a ${PrSrcPth}. ${PrPth}${subjID}/
# BIDSCOIN
# Activate bidscoin
conda activate bidscoin
# Sort the dicoms into different folders
dicomsort /media/g/P04/Data/${subjID}
# Rename / Re-catogrize
bidsmapper /media/g/P04/Data/ /media/g/P04/Data/BIDS
# Convert Dicom to Nii
bidscoiner /media/g/P04/Data/ /media/g/P04/Data/BIDS
tar -zcvf ${PrPth}sub-12_ses-001.tar.gz ${PrPth}sub-12


# make a new directory for ope funs
sesID='ses-001'
subjID='sub-12'
mkdir ${PrPth}BIDS/${subjID}/${sesID}/func/func_ope
funPth=${PrPth}BIDS/${subjID}/${sesID}/func/
funOpePth=${PrPth}BIDS/${subjID}/${sesID}/func/func_ope/


for runid in {1..3};
do
cp ${funPth}sub-12_ses-001_task-pRF_acq-EP3D_dir-LR_run-${runid}_echo-1_bold.json ${funOpePth}sub-12_ses-001_task-pRF_acq-EP3D_dir-LR_run-${runid}_echo-1_bold.json
cp ${funPth}sub-12_ses-001_task-pRF_acq-EP3D_dir-LR_run-${runid}_echo-1_bold.nii.gz ${funOpePth}sub-12_ses-001_task-pRF_acq-EP3D_dir-LR_run-${runid}_echo-1_bold.nii.gz

done

for runid in {1..3};
do
rm -f ${funPth}sub-12_ses-001_task-pRF_acq-EP3D_dir-LR_run-${runid}_echo-1_bold.json
rm -f ${funPth}sub-12_ses-001_task-pRF_acq-EP3D_dir-LR_run-${runid}_echo-1_bold.nii.gz
done

rm -rf ${PrPth}${subjID}
#-------------------------------------------------------------------------------
PrSrcPth='/run/user/1000/gvfs/smb-share:server=busrv0001,share=backedupdata/Yawen.Wang/20201104_BI_S18_SES02/'
PrPth='/media/g/P04/Data/'
subjID='sub-12'
mkdir ${PrPth}${subjID}
cp -a ${PrSrcPth}. ${PrPth}${subjID}/

# BIDSCOIN
# Activate bidscoin
conda activate bidscoin
# Sort the dicoms into different folders
dicomsort /media/g/P04/Data/${subjID}
# Rename / Re-catogrize
bidsmapper /media/g/P04/Data/ /media/g/P04/Data/BIDS
# Convert Dicom to Nii
bidscoiner /media/g/P04/Data/ /media/g/P04/Data/BIDS


# make a new directory for ope funs
sesID='ses-002'
subjID='sub-12'
mkdir ${PrPth}BIDS/${subjID}/${sesID}/func/func_ope
PrPth='/media/g/P04/Data/'
funPth=${PrPth}BIDS/${subjID}/${sesID}/func/
funOpePth=${PrPth}BIDS/${subjID}/${sesID}/func/func_ope/


for runid in {1..6};
do
cp ${funPth}sub-12_ses-002_task-BI_acq-EP3D_dir-LR_run-${runid}_echo-1_bold.json ${funOpePth}sub-12_ses-002_task-BI_acq-EP3D_dir-LR_run-${runid}_echo-1_bold.json
cp ${funPth}sub-12_ses-002_task-BI_acq-EP3D_dir-LR_run-${runid}_echo-1_bold.nii.gz ${funOpePth}sub-12_ses-002_task-BI_acq-EP3D_dir-LR_run-${runid}_echo-1_bold.nii.gz

done

for runid in {1..6};
do
rm -f ${funPth}sub-12_ses-002_task-BI_acq-EP3D_dir-LR_run-${runid}_echo-1_bold.json
rm -f ${funPth}sub-12_ses-002_task-BI_acq-EP3D_dir-LR_run-${runid}_echo-1_bold.nii.gz
done
PrPth="/media/g/P04/Data/"
tar -zcvf ${PrPth}sub-12_ses-002.tar.gz ${PrPth}sub-12
rm -rf ${PrPth}sub-12
