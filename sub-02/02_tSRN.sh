#!/bin/bash
# calculate tSNR took in 00:02m:50s."

start_tme=$(date +%s)

# Define all the pRF files
funPth='/media/h/P04/Data/BIDS/sub-02/ses-001/func/'
export Nii_array=(1 \
"sub-02_ses-001_task-pRF_acq-EP3D_dir-RL_run-1_echo-1_bold" \
"sub-02_ses-001_task-pRF_acq-EP3D_dir-RL_run-2_echo-1_bold" \
"sub-02_ses-001_task-pRF_acq-EP3D_dir-RL_run-3_echo-1_bold" \
"sub-02_ses-001_task-pRF_acq-EP3D_dir-RL_run-4_echo-1_bold" )

numFiles=${#Nii_array[@]}
numFiles=$(($numFiles - 1))

# mskPth='/media/h/P04/Data/pRFDS/sub-02/ses-001/anat/sub-02/mri/nii/'
# fixed_anat=${mskPth}brain_finalsurfs.nii.gz
# trfPth='/media/h/P04/Data/pRFDS/sub-02/ses-001/func/TRFs/'
tSNRPth='/media/h/P04/Data/BIDS/sub-02/ses-001/func/tSNR/'
mkdir ${tSNRPth}

for i in $(seq 1 $numFiles); do

  echo "Calculate tSNR for :" ${Nii_array[${i}]}

  fslmaths ${funPth}${Nii_array[${i}]}.nii.gz -Tmean ${tSNRPth}${Nii_array[${i}]}_tmean.nii.gz
  fslmaths ${funPth}${Nii_array[${i}]}.nii.gz -Tstd ${tSNRPth}${Nii_array[${i}]}_tstd.nii.gz
  fslmaths ${tSNRPth}${Nii_array[${i}]}_tmean.nii.gz -div ${tSNRPth}${Nii_array[${i}]}_tstd.nii.gz ${tSNRPth}${Nii_array[${i}]}_tSNR.nii.gz


  # $ANTSPATH/antsApplyTransforms -d 3 \
  # -i ${funPth}${Nii_array[${i}]}_tSNR.nii.gz \
  # -o ${funPth}${Nii_array[${i}]}_tSNR_reg2anat_bs4.nii.gz \
  # -n BSpline[4] \
  # -r ${fixed_anat} \
  # -t ${trfPth}P04_sub-02_ses-001_prf_to_fs_0GenericAffine.mat -v

done




end_tme=$(date +%s)
nettme=$(expr $end_tme - $start_tme)
echo " "
echo "-----> Calculate tSNR took in $(($nettme / 3600))h:$(($nettme % 3600 / 60))m:$(($nettme % 60))s."
echo " "
