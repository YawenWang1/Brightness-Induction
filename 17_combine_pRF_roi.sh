#!/bin/bash
# This script is for register 4d fMRI data to anatomy
#--------------------------------------------------------------------------------------

# Switch to the directory
cd /media/h/P04/Data/BIDS/sub-02/ses-001/func/GLM/pRF/pRF_results
fslmaths pRF_results_ovrlp_mask_75prct_edge.nii.gz -mul 2 pRF_results_ovrlp_mask_75prct_edge_mul2.nii.gz
fslmaths pRF_results_ovrlp_mask_75prct_background.nii.gz -mul 3 pRF_results_ovrlp_mask_75prct_edge_mul3.nii.gz
fslmaths pRF_results_ovrlp_mask_75prct_background.nii.gz -mul 3 pRF_results_ovrlp_mask_75prct_background_mul3.nii.gz
fslmaths pRF_results_ovrlp_mask_75prct_centre.nii.gz -add pRF_results_ovrlp_mask_75prct_edge_mul2.nii.gz -add pRF_results_ovrlp_mask_75prct_background_mul3.nii.gz stimulus_roi_75prct.nii.gz
fslmaths pRF_results_ovrlp_mask_75prct_edge.nii.gz -mul 2 pRF_results_ovrlp_mask_75prct_edge_mul2.nii.gz
fslmaths pRF_results_ovrlp_mask_75prct_background.nii.gz -mul 3 pRF_results_ovrlp_mask_75prct_background_mul3.nii.gz
fslmaths pRF_results_ovrlp_mask_75prct_centre.nii.gz -add pRF_results_ovrlp_mask_75prct_edge_mul2.nii.gz -add pRF_results_ovrlp_mask_75prct_background_mul3.nii.gz stimulus_roi_75prct.nii.gz
fslmaths pRF_results_ovrlp_mask_75prct_centre.nii.gz -add pRF_results_ovrlp_mask_75prct_edge.nii.gz -add pRF_results_ovrlp_mask_75prct_background.nii.gz stimulus_roi_75prct_ori.nii.gz


fslmaths pRF_results_ovrlp_mask_50prct_edge.nii.gz -mul 2 pRF_results_ovrlp_mask_50prct_edge_mul2.nii.gz
fslmaths pRF_results_ovrlp_mask_50prct_background.nii.gz -mul 3 pRF_results_ovrlp_mask_50prct_edge_mul3.nii.gz
fslmaths pRF_results_ovrlp_mask_50prct_background.nii.gz -mul 3 pRF_results_ovrlp_mask_50prct_background_mul3.nii.gz
fslmaths pRF_results_ovrlp_mask_50prct_centre.nii.gz -add pRF_results_ovrlp_mask_50prct_edge_mul2.nii.gz -add pRF_results_ovrlp_mask_50prct_background_mul3.nii.gz stimulus_roi_50prct.nii.gz
fslmaths pRF_results_ovrlp_mask_50prct_edge.nii.gz -mul 2 pRF_results_ovrlp_mask_50prct_edge_mul2.nii.gz
fslmaths pRF_results_ovrlp_mask_50prct_background.nii.gz -mul 3 pRF_results_ovrlp_mask_50prct_background_mul3.nii.gz
fslmaths pRF_results_ovrlp_mask_50prct_centre.nii.gz -add pRF_results_ovrlp_mask_50prct_edge_mul2.nii.gz -add pRF_results_ovrlp_mask_50prct_background_mul3.nii.gz stimulus_roi_50prct.nii.gz
fslmaths pRF_results_ovrlp_mask_50prct_centre.nii.gz -add pRF_results_ovrlp_mask_50prct_edge.nii.gz -add pRF_results_ovrlp_mask_50prct_background.nii.gz stimulus_roi_50prct_ori.nii.gz



fslmaths pRF_results_ovrlp_mask_90prct_edge.nii.gz -mul 2 pRF_results_ovrlp_mask_90prct_edge_mul2.nii.gz
fslmaths pRF_results_ovrlp_mask_90prct_background.nii.gz -mul 3 pRF_results_ovrlp_mask_90prct_edge_mul3.nii.gz
fslmaths pRF_results_ovrlp_mask_90prct_background.nii.gz -mul 3 pRF_results_ovrlp_mask_90prct_background_mul3.nii.gz
fslmaths pRF_results_ovrlp_mask_90prct_centre.nii.gz -add pRF_results_ovrlp_mask_90prct_edge_mul2.nii.gz -add pRF_results_ovrlp_mask_90prct_background_mul3.nii.gz stimulus_roi_90prct.nii.gz
fslmaths pRF_results_ovrlp_mask_90prct_edge.nii.gz -mul 2 pRF_results_ovrlp_mask_90prct_edge_mul2.nii.gz
fslmaths pRF_results_ovrlp_mask_90prct_background.nii.gz -mul 3 pRF_results_ovrlp_mask_90prct_background_mul3.nii.gz
fslmaths pRF_results_ovrlp_mask_90prct_centre.nii.gz -add pRF_results_ovrlp_mask_90prct_edge_mul2.nii.gz -add pRF_results_ovrlp_mask_90prct_background_mul3.nii.gz stimulus_roi_90prct.nii.gz
fslmaths pRF_results_ovrlp_mask_90prct_centre.nii.gz -add pRF_results_ovrlp_mask_90prct_edge.nii.gz -add pRF_results_ovrlp_mask_90prct_background.nii.gz stimulus_roi_90prct_ori.nii.gz
