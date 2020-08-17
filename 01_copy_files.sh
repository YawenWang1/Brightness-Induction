#!/bin/bash
##copy the files from BU Server to the destination Directory####################
# Go to the Directory of Dicoms in Scannexus
PrPth='/media/h/P04/Data/'
subjID='sub-03'
mkdir ${PrPth}${subjID}
PrSrcPth='/run/user/1000/gvfs/smb-share:server=busrv0001,share=backedupdata/Yawen.Wang/20200722_SES01/'
cp -a ${PrSrcPth}. ${PrPth}${subjID}/
# BIDSCOIN
# Activate bidscoin
conda activate bidscoin
# Sort the dicoms into different folders
dicomsort /media/h/P04/Data/${subjID}
# Rename / Re-catogrize
bidsmapper /media/h/P04/Data/ /media/h/P04/Data/BIDS
# Convert Dicom to Nii
bidscoiner /media/h/P04/Data/ /media/h/P04/Data/BIDS


# make a new directory for ope funs
sesID='ses-001'
subjID='sub-03'
mkdir ${PrPth}BIDS/${subjID}/${sesID}/func/func_ope
PrPth='/media/h/P04/Data/'
funPth=${PrPth}BIDS/${subjID}/${sesID}/func/
funOpePth=${PrPth}BIDS/${subjID}/${sesID}/func/func_ope/



for runid in {1..4};
do
cp ${funPth}sub-03_ses-001_task-pRF_acq-EP3D_dir-LR_run-${runid}_echo-1_bold.json ${funOpePth}sub-03_ses-001_task-pRF_acq-EP3D_dir-LR_run-${runid}_echo-1_bold.json
cp ${funPth}sub-03_ses-001_task-pRF_acq-EP3D_dir-LR_run-${runid}_echo-1_bold.nii.gz ${funOpePth}sub-03_ses-001_task-pRF_acq-EP3D_dir-LR_run-${runid}_echo-1_bold.nii.gz

done

for runid in {1..4};
do
rm -f ${funPth}sub-03_ses-001_task-pRF_acq-EP3D_dir-LR_run-${runid}_echo-1_bold.json
rm -f ${funPth}sub-03_ses-001_task-pRF_acq-EP3D_dir-LR_run-${runid}_echo-1_bold.nii.gz
done

#-------------------------------------------------------------------------------
PrSrcPth='/run/user/1000/gvfs/smb-share:server=busrv0001,share=backedupdata/Yawen.Wang/20200723_S09_SES02'
PrPth='/media/h/P04/Data/'
subjID='sub-03'
mkdir ${PrPth}${subjID}
cp -a ${PrSrcPth}. ${PrPth}${subjID}/

# BIDSCOIN
# Activate bidscoin
conda activate bidscoin
# Sort the dicoms into different folders
dicomsort /media/h/P04/Data/${subjID}
# Rename / Re-catogrize
bidsmapper /media/h/P04/Data/ /media/h/P04/Data/BIDS
# Convert Dicom to Nii
bidscoiner /media/h/P04/Data/ /media/h/P04/Data/BIDS


sesID='ses-002'
subjID='sub-03'
mkdir ${PrPth}BIDS/${subjID}/${sesID}/func/func_ope
PrPth='/media/h/P04/Data/'
funPth=${PrPth}BIDS/${subjID}/${sesID}/func/
funOpePth=${PrPth}BIDS/${subjID}/${sesID}/func/func_ope/








