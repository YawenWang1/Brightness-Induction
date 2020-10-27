#! /bin/bash

# Register pRF to anatomy
#--------------------------------------------------------------------------------------

# Define all the pRF files
export SUBJECTS_DIR='/media/h/P04/Data/BIDS/sub-02/ses-002/anat'
export prf_roi_namearray=(1 "background" "centre" "edge")
trfPth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/TRFs/'
prfPth='/media/h/P04/Data/BIDS/sub-02/ses-001/func/GLM/pRF/pRF_results/'

Outpth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/Anat_space/pRF/ROI/'
mkdir ${Outpth}

anatPth='/media/h/P04/Data/BIDS/sub-02/ses-002/anat/'
fixed_anat=${anatPth}msub-02_ses-002_acq-MP2RAGE_run-1_mod-UNI_T1w_brain.nii.gz
FunOutpth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/Fun_space/pRF/ROI/'
mkdir ${FunOutpth}

funPth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/'
moving_fun=${funPth}sub-02_ses-002_task-BI_acq-EP3D_dir-RL_run-1_echo-1_bold_fixed_dc_template0.nii.gz
Outpth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/Anat_space/pRF/ROI/'
mkdir ${Outpth}


# prfsrfOptPth=${Outpth}In_surface/
# mkdir ${prfsrfOptPth}
# subjID='sub-02'
#

for i in {1..3}; do

$ANTSPATH/antsApplyTransforms -d 3 \
-i ${prfPth}pRF_results_ovrlp_mask_90prct_${prf_roi_namearray[${i}]}.nii.gz \
-o ${Outpth}pRF_results_ovrlp_mask_90prct_${prf_roi_namearray[${i}]}_reg2anat.nii.gz \
-n GenericLabel \
-r ${fixed_anat} \
-t ${trfPth}sub-02_ses-001_prf_to_ana_0GenericAffine.mat \
-v



$ANTSPATH/antsApplyTransforms -d 3 \
-i ${prfPth}pRF_results_ovrlp_mask_90prct_${prf_roi_namearray[${i}]}.nii.gz \
-o ${FunOutpth}pRF_results_ovrlp_mask_90prct_${prf_roi_namearray[${i}]}_reg2fun.nii.gz \
-n GenericLabel \
-r ${moving_fun} \
-t [${trfPth}sub-02_ses-002_fun_to_ana_0GenericAffine.mat,1] \
-t ${trfPth}sub-02_ses-001_prf_to_ana_0GenericAffine.mat \
-v
done


# echo "Binarize stimuli roi"
# mri_binarize --i ${Outpth}stimuli_roi_ori_reg2fsanat.nii.gz --min 0.01 --o ${Outpth}stimuli_roi_ori_reg2fsanat.nii.gz

# #
# for hemi in {"lh","rh"}; do
#   # Get the name of the current prf roi
#
#
#   mri_vol2surf \
#   --mov ${Outpth}stimulus_roi_90prct_ori_reg2fsanat.nii.gz \
#   --regheader ${subjID} \
#   --hemi ${hemi} \
#   --o ${prfsrfOptPth}stimuli_roi_90prct_ori_reg2fsanat_${hemi}.nii.gz \
#   --interp nearest
# done
#
#
# for hemi in {"lh","rh"}; do
#
# for i in {1..3}; do
#
#
#   # Get the name of the current prf roi
#   interp01=results_${prf_roi_namearray[${i}]}
#   # interp02=$(cut -d '_' -f 7,8 <<< ${interp01})
#
#   # interp02=$(cut -d '_' -f 1,2,3,4,7,8 <<< ${interp01})
#
#   mri_vol2surf \
#   --mov ${Outpth}pRF_results_ovrlp_mask_90prct_${prf_roi_namearray[${i}]}_reg2fsanat.nii.gz \
#   --regheader ${subjID} \
#   --hemi ${hemi} \
#   --o ${prfsrfOptPth}pRF_results_ovrlp_mask_90prct_${prf_roi_namearray[${i}]}_reg2fsanat_${hemi}.nii.gz \
#   --interp nearest
# done
#
# done


# Look at the data from freeview
# freeview -f $SUBJECTS_DIR/S04/surf/lh.inflated:overlay=./results_227vols_polar_angle_reg2anat_lh.nii.gz:label=/media/h/P04/Data/S04/Ses01/03_GLM/00_Ana/S04/label/lh.benson14atlas.V1.label:label=/media/h/P04/Data/S04/Ses01/03_GLM/00_Ana/S04/label/lh.benson14atlas.V2.label
