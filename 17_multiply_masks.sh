#!/bin/bash


###############################################################################
# Upsample pRF results.                                                       #
###############################################################################


# -----------------------------------------------------------------------------
# *** Define parameters

# Input directory:
strPthIn="/media/h/P04/Data/S04/Ses01/03_GLM/04_ASpace/04_up_sub_down/"
strpRFPthIn="/media/h/P04/Data/S04/Ses01/03_GLM/04_ASpace/pRF_results_up_tst_0p4/"
# Output directory:
strPthOut="/media/h/P04/Data/S04/Ses01/03_GLM/04_ASpace/05_0p4/"
mkdir ${strPthOut}

# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# *** Upsample images

echo "- apply pRF-results to ROI mask"

# Save original path in order to cd back to this path in the end:
# strPathOrig=( $(pwd) )
roifiles=(
benson14atlas.V1 \
benson14atlas.V2 \
benson14atlas.V3 \
benson14atlas.hV4 \
)
ROI_V1="${strPthOut}benson14atlas.V1.0p4"
ROI_V2="${strPthOut}benson14atlas.V2.0p4"
ROI_V3="${strPthOut}benson14atlas.V3.0p4"

pRF_90_Center="${strpRFPthIn}0p4_pRF_results_ovrlp_mask_90prct_square_centre.nii.gz"
pRF_90_Edge="${strpRFPthIn}0p4_pRF_results_ovrlp_mask_90prct_square_edge.nii.gz"
pRF_90_Bckgrd="${strpRFPthIn}0p4_pRF_results_ovrlp_mask_90prct_background.nii.gz"
# -------------------------------------------------------------------------------
# Apply center to V1
fslmaths \
"${ROI_V1}.nii.gz" \
-mul \
${pRF_90_Center} \
${strPthOut}V1_Center_90_0p4.nii.gz \
# Apply edge to V1
fslmaths \
"${ROI_V1}.nii.gz" \
-mul \
${pRF_90_Edge} \
${strPthOut}V1_Edge_90_0p4.nii.gz \
# Apply Background to V1
fslmaths \
"${ROI_V1}.nii.gz" \
-mul \
${pRF_90_Bckgrd} \
${strPthOut}V1_Bckgrd_90_0p4.nii.gz \
#-------------------------------------------------------------------------------
# Apply center to V2
fslmaths \
"${ROI_V2}.nii.gz" \
-mul \
${pRF_90_Center} \
${strPthOut}V2_Center_90_0p4.nii.gz \
# Apply edge to V2
fslmaths \
"${ROI_V2}.nii.gz" \
-mul \
${pRF_90_Edge} \
${strPthOut}V2_Edge_90_0p4.nii.gz \
# Apply Background to V2
fslmaths \
"${ROI_V2}.nii.gz" \
-mul \
${pRF_90_Bckgrd} \
${strPthOut}V2_Bckgrd_90_0p4.nii.gz \
#-------------------------------------------------------------------------------
# Apply center to V3
fslmaths \
"${ROI_V3}.nii.gz" \
-mul \
${pRF_90_Center} \
${strPthOut}V3_Center_90_0p4.nii.gz \
# Apply edge to V2
fslmaths \
"${ROI_V3}.nii.gz" \
-mul \
${pRF_90_Edge} \
${strPthOut}V3_Edge_90_0p4.nii.gz \
# Apply Background to V2
fslmaths \
"${ROI_V3}.nii.gz" \
-mul \
${pRF_90_Bckgrd} \
${strPthOut}V3_Bckgrd_90_0p4.nii.gz \

#--------------------------------------------------------------------------------
