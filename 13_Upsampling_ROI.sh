#!/bin/bash
# This script is for unsamp;ing 002_fun_to_fs_InverseWarped and wm from freesurfer
#--------------------------------------------------------------------------------------

# Define all the pRF files
roiPth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/Fun_space/pRF/ROI/'
export Files=(1 "pRF_results_ovrlp_mask_50prct_background_reg2fun" \
"pRF_results_ovrlp_mask_50prct_centre_reg2fun" \
"pRF_results_ovrlp_mask_50prct_edge_reg2fun" \
"pRF_results_ovrlp_mask_75prct_background_reg2fun" \
"pRF_results_ovrlp_mask_75prct_centre_reg2fun" \
"pRF_results_ovrlp_mask_75prct_edge_reg2fun" \
"pRF_results_ovrlp_mask_90prct_background_reg2fun" \
"pRF_results_ovrlp_mask_90prct_centre_reg2fun" \
"pRF_results_ovrlp_mask_90prct_edge_reg2fun" \
"pRF_results_ovrlp_mask_95prct_background_reg2fun" \
"pRF_results_ovrlp_mask_95prct_centre_reg2fun" \
"pRF_results_ovrlp_mask_95prct_edge_reg2fun" \
)
Outpth=${roiPth}upsampling
mkdir ${Outpth}

for i in {1..12}; do

echo "Upsampling " ${Files[${i}]}

$ANTSPATH/ResampleImage \
3 \
${roiPth}${Files[${i}]}.nii.gz \
${Outpth}/${Files[${i}]}_pt4.nii.gz \
0.4x0.4x0.4 \
0 \
1 \
2


done

#
# for i in {1..5}; do
#
# $ANTSPATH/ResampleImage \
# 3 \
# ${funPth}${Files[${i}]}.nii.gz \
# ${Outpth}/${Files[${i}]}_pt4.nii.gz \
# 0.4x0.4x0.4 \
# 0 \
# 3['l'] \
# 6
#
#
# done
