#! /bin/bash

# Register pRF to anatomy
#--------------------------------------------------------------------------------------

# Define all the pRF files
export SUBJECTS_DIR=/media/h/P04/Data/BIDS/sub-02/ses-001/anat/MPRAGE
export prf_namearray=(1 "polar_angle" "PE_01" "eccentricity" "R2" "SD" "x_pos" "y_pos")
trfPth='/media/h/P04/Data/BIDS/sub-02/ses-001/func/TRFs/'
funPth='/media/h/P04/Data/BIDS/sub-02/ses-001/func/'
prfPth='/media/h/P04/Data/BIDS/sub-02/ses-001/func/GLM/pRF/pRF_results/'
mskPth='/media/h/P04/Data/BIDS/sub-02/ses-001/anat/MPRAGE/sub-02/mri/nii/'
fixed_anat=${mskPth}brain_finalsurfs.nii.gz
prfsrfOptPth=${prfPth}In_surface/
mkdir ${prfsrfOptPth}
subjID='sub-02'


$ANTSPATH/antsApplyTransforms -d 3 \
-i ${funPth}sub-02_ses-001_task-pRF_acq-EP3D_dir-RL_run-1_echo-1_bold_fixedMask_brain.nii.gz \
-o ${prfPth}sub-02_ses-001_task-pRF_acq-EP3D_dir-RL_run-1_echo-1_bold_fixedMask_brain_reg2anat.nii.gz \
-n BSpline[4] \
-r ${fixed_anat} \
-t ${trfPth}P04_sub-02_ses-001_prf_to_fs_0GenericAffine.mat \
-v


mri_binarize \
--i ${prfPth}sub-02_ses-001_task-pRF_acq-EP3D_dir-RL_run-1_echo-1_bold_fixedMask_brain_reg2anat.nii.gz \
--min 0.5 \
--o ${prfPth}sub-02_ses-001_task-pRF_acq-EP3D_dir-RL_run-1_echo-1_bold_fixedMask_brain_reg2anat.nii.gz

# for i in {1..7}; do
#
# $ANTSPATH/antsApplyTransforms -d 3 \
# -i ${prfPth}results_${prf_namearray[${i}]}.nii.gz \
# -o ${prfPth}results_${prf_namearray[${i}]}_reg2anat.nii.gz \
# -n BSpline[4] \
# -r ${fixed_anat} \
# -t ${trfPth}P04_sub-02_ses-001_prf_to_fs_0GenericAffine.mat \
# -v
# done

# strPathOrig=$PWD
# echo ${strPathOrig}
# cd ${prfPth}
# # Get all the pRF overlay results
# pRF_results_overlay=( $(ls | grep _reg2anat.nii.gz) )
#
# numpRF=${#pRF_results_overlay[@]}
# numpRF=$(($numpRF - 1))
# echo ${numpRF}
#
#
# for hemi in {"lh","rh"}; do
# for i in $(seq 0 $numpRF); do
#
#   # Get the name of the current prf roi
#   interp01=$(cut -d '.' -f 1 <<< ${pRF_results_overlay[${i}]})
#   # interp02=$(cut -d '_' -f 7,8 <<< ${interp01})
#
#   # interp02=$(cut -d '_' -f 1,2,3,4,7,8 <<< ${interp01})
#
#   mri_vol2surf \
#   --mov ${prfPth}${pRF_results_overlay[${i}]} \
#   --regheader ${subjID} \
#   --hemi ${hemi} \
#   --o ${prfsrfOptPth}${interp01}_reg2anat_${hemi}.nii.gz \
#   --interp nearest
# done
# done


# Look at the data from freeview
# freeview -f $SUBJECTS_DIR/S04/surf/lh.inflated:overlay=./results_227vols_polar_angle_reg2anat_lh.nii.gz:label=/media/h/P04/Data/S04/Ses01/03_GLM/00_Ana/S04/label/lh.benson14atlas.V1.label:label=/media/h/P04/Data/S04/Ses01/03_GLM/00_Ana/S04/label/lh.benson14atlas.V2.label
