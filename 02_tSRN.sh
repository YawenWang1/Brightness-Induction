#!/bin/bash
# -----> Calculate tSNR took in 0h:4m:52s.

start_tme=$(date +%s)

# Define all the pRF files
funPth='/media/g/P04/Data/BIDS/sub-12/ses-001/func/'
funPthSes02='/media/g/P04/Data/BIDS/sub-12/ses-002/func/'

export Nii_array=(1 \
"sub-12_ses-001_task-pRF_acq-EP3D_dir-RL_run-1_echo-1_bold" \
"sub-12_ses-001_task-pRF_acq-EP3D_dir-RL_run-2_echo-1_bold" \
"sub-12_ses-001_task-pRF_acq-EP3D_dir-RL_run-3_echo-1_bold")

export Nii_array_ses02=(1 \
"sub-12_ses-002_task-BI_acq-EP3D_dir-RL_run-1_echo-1_bold" \
"sub-12_ses-002_task-BI_acq-EP3D_dir-RL_run-2_echo-1_bold" \
"sub-12_ses-002_task-BI_acq-EP3D_dir-RL_run-3_echo-1_bold" \
"sub-12_ses-002_task-BI_acq-EP3D_dir-RL_run-4_echo-1_bold" \
"sub-12_ses-002_task-BI_acq-EP3D_dir-RL_run-5_echo-1_bold" \
"sub-12_ses-002_task-BI_acq-EP3D_dir-RL_run-6_echo-1_bold"
)

numFiles=${#Nii_array[@]}
numFiles=$(($numFiles - 1))

numFiles_ses02=${#Nii_array_ses02[@]}
numFiles_ses02=$(($numFiles_ses02 - 1))

tSNRPth='/media/g/P04/Data/BIDS/sub-12/ses-001/func/tSNR/'
tSNRPth_ses02='/media/g/P04/Data/BIDS/sub-12/ses-002/func/tSNR/'

mkdir ${tSNRPth}
mkdir ${tSNRPth_ses02}

for i in $(seq 1 $numFiles); do

  echo "Calculate tSNR for :" ${Nii_array[${i}]}

  fslmaths ${funPth}${Nii_array[${i}]}.nii.gz -Tmean ${tSNRPth}${Nii_array[${i}]}_tmean.nii.gz
  fslmaths ${funPth}${Nii_array[${i}]}.nii.gz -Tstd ${tSNRPth}${Nii_array[${i}]}_tstd.nii.gz
  fslmaths ${tSNRPth}${Nii_array[${i}]}_tmean.nii.gz -div ${tSNRPth}${Nii_array[${i}]}_tstd.nii.gz ${tSNRPth}${Nii_array[${i}]}_tSNR.nii.gz

done


for i in $(seq 1 $numFiles_ses02); do

  echo "Calculate tSNR for :" ${Nii_array_ses02[${i}]}

  fslmaths ${funPthSes02}${Nii_array_ses02[${i}]}.nii.gz -Tmean ${tSNRPth_ses02}${Nii_array_ses02[${i}]}_tmean.nii.gz
  fslmaths ${funPthSes02}${Nii_array_ses02[${i}]}.nii.gz -Tstd ${tSNRPth_ses02}${Nii_array_ses02[${i}]}_tstd.nii.gz
  fslmaths ${tSNRPth_ses02}${Nii_array_ses02[${i}]}_tmean.nii.gz -div ${tSNRPth_ses02}${Nii_array_ses02[${i}]}_tstd.nii.gz ${tSNRPth_ses02}${Nii_array_ses02[${i}]}_tSNR.nii.gz

done

end_tme=$(date +%s)
nettme=$(expr $end_tme - $start_tme)
echo " "
echo "-----> Calculate tSNR took in $(($nettme / 3600))h:$(($nettme % 3600 / 60))m:$(($nettme % 60))s."
echo " "
