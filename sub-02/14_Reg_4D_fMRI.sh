#!/bin/bash
# This script is for register 4d fMRI data to anatomy
#--------------------------------------------------------------------------------------

# Define all the pRF files
trfPth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/TRFs/'
anatPth='/media/h/P04/Data/BIDS/sub-02/ses-002/anat/sub-02/mri/nii/'
fixed_anat=${anatPth}brain_finalsurfs.nii.gz
funPth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/'

moving_fun=${funPth}sub-02_ses-002_task-BI_acq-EP3D_dir-RL_run-1_echo-1_bold_fixed_dc_template0.nii.gz

Outpth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/Anat_space/BI/'

mkdir ${Outpth}

for i in {1..3}; do

$ANTSPATH/antsApplyTransforms -d 3 \
-i ${funPth}GLM/BI/BI_fun_0${i}_MoCo_Dist_Corr_Coreg.feat/filtered_func_data.nii.gz \
-o ${Outpth}sub-02_ses-002_BI_run_0${i}_reg2fsanat.nii.gz \
-n BSpline[4] \
-r ${fixed_anat} \
-t ${trfPth}sub-02_ses-002_fun_to_fs_0GenericAffine.mat \
-v

done

# for i in {5..6}; do
#
# $ANTSPATH/antsApplyTransforms -d 3 \
# -i ${funPth}GLM/BI/BI_fun_0${i}_MoCo_Dist_Corr_Coreg.feat/filtered_func_data.nii.gz \
# -o ${Outpth}sub-02_ses-002_BI_run_0${i}_reg2fsanat.nii.gz \
# -n BSpline[4] \
# -r ${fixed_anat} \
# -t ${trfPth}sub-02_ses-002_fun_to_fs_0GenericAffine.mat \
# -v
#
# done
