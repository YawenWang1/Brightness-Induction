#!/bin/bash
##copy the files from BU Server to the destination Directory####################
# Go to the Directory of Dicoms in Scannexus
PrPth='/media/h/P04/Data/BIDS/'
subjID='sub-02'
PrSrcPth='/run/user/1000/gvfs/smb-share:server=busrv0001,share=backedupdata/Yawen.Wang/20200713_YW_BI_S08/'
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
