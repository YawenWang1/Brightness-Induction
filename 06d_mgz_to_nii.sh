#! /bin/bash
################################################################################
# Define directories
# ------------------------------------------------------------------------------
anatPth='/media/g/P04/Data/BIDS/sub-12/ses-002/anat/fs/sub-12/mri/'
anatOpt=${anatPth}nii/
mkdir ${anatOpt}

# Convert mgz to nii
mri_binarize --i ${anatPth}ribbon.mgz --match 2 --binval 3 --o ${anatPth}wm_lh.mgz
mri_binarize --i ${anatPth}ribbon.mgz --match 41 --binval 3 --o ${anatPth}wm_rh.mgz
mri_binarize --i ${anatPth}ribbon.mgz --match 2 41 --binval 3 --o ${anatPth}wm_both.mgz
mri_binarize --i ${anatPth}ribbon.mgz --match 3 --binval 2 --o ${anatPth}gm_lh.mgz
mri_binarize --i ${anatPth}ribbon.mgz --match 42 --binval 2 --o ${anatPth}gm_rh.mgz
mri_binarize --i ${anatPth}ribbon.mgz --match 3 42 --binval 2 --o ${anatPth}gm_both.mgz
mri_binarize --i ${anatPth}ribbon.mgz --match 3 42 --binval 100 --merge ${anatPth}wm_both.mgz --o ${anatPth}wm_gm_both.mgz

# Convert mgz to nii
mri_convert ${anatPth}wm_lh.mgz ${anatOpt}wm_lh.nii.gz -rt nearest
mri_convert ${anatPth}wm_rh.mgz ${anatOpt}wm_rh.nii.gz -rt nearest
mri_convert ${anatPth}wm_both.mgz ${anatOpt}wm_both.nii.gz -rt nearest
mri_convert ${anatPth}gm_lh.mgz ${anatOpt}gm_lh.nii.gz -rt nearest
mri_convert ${anatPth}gm_rh.mgz ${anatOpt}gm_rh.nii.gz -rt nearest
mri_convert ${anatPth}gm_both.mgz ${anatOpt}gm_both.nii.gz -rt nearest
mri_convert ${anatPth}ribbon.mgz ${anatOpt}gm_both_c.nii.gz -rt nearest
mri_convert ${anatPth}brainmask.mgz ${anatOpt}brainmask.nii.gz -rt nearest
mri_convert ${anatPth}wm_gm_both.mgz ${anatOpt}wm_gm_both.nii.gz -rt nearest

mri_convert ${anatPth}brain.finalsurfs.mgz ${anatOpt}brain.finalsurfs.nii.gz -rt cubic
#
# covert subject native space to freesurfer anatomical native space
mri_convert /media/g/P04/Data/BIDS/sub-12/ses-002/anat/spm_bf_correction/mINV2_brainmask.nii.gz \
# ${anatOpt}sub-12_ses-002_brainmask_fs.nii.gz --conform_min  --resample_type nearest

mri_convert /media/g/P04/Data/BIDS/sub-12/ses-002/anat/spm_bf_correction/mINV1_corrected.nii \
${anatOpt}sub-12_ses-002_INV1_fs.nii.gz --conform_min  --resample_type cubic

mri_convert /media/g/P04/Data/BIDS/sub-12/ses-002/anat/spm_bf_correction/mINV2_corrected.nii \
${anatOpt}sub-12_ses-002_INV2_fs.nii.gz --conform_min  --resample_type cubic

# Binarize brainmask.nii.gz
mri_binarize --i ${anatOpt}brainmask.nii.gz --min 0.5 --o ${anatOpt}brainmask.nii.gz
# Transform from freesurfer space to native space
# mri_vol2vol --mov ${anatPth}brain.finalsurfs.mgz --targ rawavg.mgz --regheader --o brain_in_native.mgz --no-save-reg
