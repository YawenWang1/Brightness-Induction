#!/bin/bash
# This script is for unsamp;ing 002_fun_to_fs_InverseWarped and wm from freesurfer
#--------------------------------------------------------------------------------------

# Define all the pRF files
export SUBJECTS_DIR='/media/h/P04/Data/BIDS/sub-02/ses-002/anat'
export prf_roi_namearray=(1 "wm_both" "wm_gm_both" "wm_lh" "wm_rh")
trfPth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/TRFs/'
anatPth='/media/h/P04/Data/BIDS/sub-02/ses-002/anat/sub-02/mri/nii/'
mkdir ${anatPth}upsampling
fixed_anat=${anatPth}brain_finalsurfs.nii.gz
funPth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/'

moving_fun=${funPth}sub-02_ses-002_task-BI_acq-EP3D_dir-RL_run-1_echo-1_bold_fixed_dc_template0.nii.gz

for i in {1..4}; do

$ANTSPATH/antsApplyTransforms -d 3 \
-i ${anatPth}${prf_roi_namearray[${i}]}.nii.gz \
-o ${anatPth}${prf_roi_namearray[${i}]}_reg2fun.nii.gz \
-n GenericLabel \
-r ${moving_fun} \
-t [${trfPth}sub-02_ses-002_anat_to_fun.txt,1] \
-v
echo "upsampling"
$ANTSPATH/ResampleImage \
3 \
${anatPth}${prf_roi_namearray[${i}]}_reg2fun.nii.gz \
${anatPth}upsampling/${prf_roi_namearray[${i}]}_reg2fun_pt4.nii.gz \
0.4x0.4x0.4 \
0 \
1 \
6


done
