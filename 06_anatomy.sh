#! /bin/bash
################################################################################

# This script is for analyzing anatomy
# Unzip .nii.gz to .nii
anatPth='/media/g/P04/Data/BIDS/sub-12/ses-002/anat/spm_bf_correction/'

gunzip -c ${anatPth}/INV2_corrected.nii.gz > ${anatPth}/INV2_corrected.nii
gunzip -c ${anatPth}/INV1_corrected.nii.gz > ${anatPth}/INV1_corrected.nii
gunzip -c ${anatPth}/UNI_corrected.nii.gz > ${anatPth}/UNI_corrected.nii

# 1. SPM bias correction for INV2, INV1 and UNI
# 2. FSL BET get brain_mask from INV2 and remove cerebellum
# 3. fslmaths c3 -add c4 -add c5 non-brain-mask.nii.gz
# 4. fslmaths non-brain-mask.nii.gz -sub 1 -mul -1 non_brain_mask_invert.nii.gz
# 5. fslmaths mUNI-w.nii.gz -mul brain_mask -mul non_brain_mask_invert mUNI_brain.nii.gz
# 5. freesurfer  (first export SUBJECTS_DIR)  recon-all
# 20 mins
