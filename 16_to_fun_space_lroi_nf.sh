#! /bin/bash

# Register pRF to anatomy
#--------------------------------------------------------------------------------------

# Define all the pRF files
trfPth='/media/g/P04/Data/BIDS/sub-12/ses-002/func/TRFs/'
funPth='/media/g/P04/Data/BIDS/sub-12/ses-002/func/'

mskPth='/media/g/P04/Data/BIDS/sub-12/ses-002/func/GLM/Anat_space/Masks/final/'
mkdir ${mskPth}

moving_fun=${funPth}sub-12_ses-002_task-BI_acq-EP3D_dir-RL_run-1_echo-1_bold_fixed_dc_template0.nii.gz

mkdir ${mskPth}fun_space

strPathOrig=$PWD
# Define masks
# Go back to functional space
cd ${mskPth}
# Get all the pRF overlay results
mskFiles=( $(ls | grep sub-12_ses-002_lroi_nf | grep .nii.gz) )
numMsk=${#mskFiles[@]}
numMsk=$(($numMsk - 1))
echo ${numMsk}
# -----------------------------------------------------------------------------
cd ${strPathOrig}

for i in $(seq 0 ${numMsk});
do

  interp01=$(cut -d '.' -f 1 <<< ${mskFiles[${i}]})


  $ANTSPATH/antsApplyTransforms -d 3 \
  -i ${mskPth}${mskFiles[${i}]} \
  -o ${mskPth}fun_space/${interp01}_reg2run.nii.gz \
  -n GenericLabel \
  -r ${moving_fun} \
  -t [${trfPth}sub-12_ses-002_fun_to_anat_0GenericAffine.mat,1] \
  -v
done
