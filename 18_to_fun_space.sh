#! /bin/bash

# Register pRF to anatomy
#--------------------------------------------------------------------------------------

# Define all the pRF files
trfPth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/TRFs/'
funPth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/'
prfPth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/Anat_space/pRF/ROI/'
# mskPth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/Anat_space/Masks/final/'
mskPth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/Anat_space/Masks/'

moving_fun=${funPth}sub-02_ses-002_task-BI_acq-EP3D_dir-RL_run-1_echo-1_bold_fixed_dc_template0.nii.gz

strPathOrig=$PWD
cd ${prfPth}
# Get all the pRF overlay results
mskFiles=( $(ls | grep pRF_results_ovrlp_mask_50prct_ | grep .nii.gz) )
numMsk=${#mskFiles[@]}
numMsk=$(($numMsk - 1))
echo ${numMsk}
# -----------------------------------------------------------------------------
cd ${strPathOrig}




for i in $(seq 0 ${numMsk}); do

  interp01=$(cut -d '.' -f 1 <<< ${mskFiles[${i}]})


  $ANTSPATH/antsApplyTransforms -d 3 \
  -i ${prfPth}${mskFiles[${i}]} \
  -o ${mskPth}final/fun_space/${interp01}_reg2run.nii.gz \
  -n GenericLabel \
  -r ${moving_fun} \
  -t [${trfPth}sub-02_ses-002_fun_to_fs_0GenericAffine.mat,1] \
  -v
done

# for i in {1..3}; do
#   $ANTSPATH/antsApplyTransforms -d 3 \
#   -i /media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/Anat_space/Masks/sub-02_ses-002_v${i}.nii.gz \
#   -o ${mskPth}fun_space/sub-02_ses-002_v${i}_reg2run.nii.gz \
#   -n GenericLabel \
#   -r ${moving_fun} \
#   -t [${trfPth}sub-02_ses-002_fun_to_fs_0GenericAffine.mat,1] \
#   -v
# done



# Look at the data from freeview
# freeview -f $SUBJECTS_DIR/S04/surf/lh.inflated:overlay=./results_227vols_polar_angle_reg2anat_lh.nii.gz:label=/media/h/P04/Data/S04/Ses01/03_GLM/00_Ana/S04/label/lh.benson14atlas.V1.label:label=/media/h/P04/Data/S04/Ses01/03_GLM/00_Ana/S04/label/lh.benson14atlas.V2.label
