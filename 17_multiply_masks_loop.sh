#!/bin/bash


###############################################################################
# Upsample pRF results.                                                       #
###############################################################################


# -----------------------------------------------------------------------------
# *** Define parameters
# Parent Path
strPthPret="/media/h/P04/Data/S04/Ses01/03_GLM/SriPlay/"
# Input directory:
strpRFPthIn="/media/h/P04/Data/S04/Ses01/03_GLM/SriPlay/1Run_ss/pRF_results_overlay/"

# Output directory:
strPthOut=${strPthPret}ROI_masks/
mkdir ${strPthOut}
strPathOrig=$PWD
# -----------------------------------------------------------------------------
# Define all the R2 masks
Msk_namearray=(1 "mask_pt2" "mask_pt15" "mask_pt27")
Msk_prefix="results_227vol_1run_sm_hpf_R2_reg2anat_"
#------------------------------------------------------------------------------
cd ${strpRFPthIn}
# Get all the pRF overlay results
pRF_results_overlay=( $(ls | grep .nii.gz) )
numpRF=${#pRF_results_overlay[@]}
numpRF=$(($numpRF - 1))
# -----------------------------------------------------------------------------
cd ${strPathOrig}
# *** Upsample images

echo "- apply pRF-results to ROI mask"

# Save original path in order to cd back to this path in the end:
# strPathOrig=( $(pwd) )
# roifiles=(
# benson14atlas.V1.0p8 \
# benson14atlas.V2 \
# benson14atlas.V3 \
# benson14atlas.hV4 \
# )
# ROI_V1="${strPthOut}benson14atlas.V1"
# ROI_V2="${strPthOut}benson14atlas.V2"
# ROI_V3="${strPthOut}benson14atlas.V3"
ROI_namearray=(1 "benson14atlas.V1" "benson14atlas.V2" "benson14atlas.V3")
# pRF_90_Center="${strpRFPthIn}pRF_results_ovrlp_mask_95prct_square_centre.nii.gz"
# pRF_90_Edge="${strpRFPthIn}pRF_results_ovrlp_mask_95prct_square_edge.nii.gz"
# pRF_90_Bckgrd="${strpRFPthIn}pRF_results_ovrlp_mask_95prct_background.nii.gz"
# -------------------------------------------------------------------------------
date
for ROIID in {1..3}
do

  currROI=${strPthPret}${ROI_namearray[${ROIID}]}.nii.gz
  echo ${currROI}
for R2Msk in {1..3}
do
  currR2Mask=${strPthPret}1Run_ss/${Msk_prefix}${Msk_namearray[${R2Msk}]}.nii.gz
  echo ${currR2Mask}
  # Apply R2 Mask to pRF
  for pRFId in $(seq 0 $numpRF)
  do
    # current pRF overlay file
    currpRFile=${strpRFPthIn}${pRF_results_overlay[${pRFId}]}
    echo ${currpRFile}
    # current output file
    currOut01=${strPthOut}${Msk_namearray[${R2Msk}]}_${pRF_results_overlay[${pRFId}]}
    echo ${currOut01}
    # multiply R2 mask to pRF overlay results
    fslmaths \
    ${currpRFile} \
    -mul \
    ${currR2Mask} \
    ${currOut01}

    currOut02=${strPthOut}${ROI_namearray[${ROIID}]}_${Msk_namearray[${R2Msk}]}_${pRF_results_overlay[${pRFId}]}
    # Apply current ROI to the above Mask
    fslmaths \
    ${currOut01} \
    -mul \
    ${currROI} \
    ${currOut02}

    echo ${currOut02}

  done
done
done
date

# # Apply center to V1
# fslmaths \
# "${ROI_V1}.nii.gz" \
# -mul \
# ${pRF_90_Center} \
# ${strPthOut}V1_Center_95_0p8.nii.gz
# # Apply edge to V1
# fslmaths \
# "${ROI_V1}.nii.gz" \
# -mul \
# ${pRF_90_Edge} \
# ${strPthOut}V1_Edge_95_0p8.nii.gz
# # Apply Background to V1
# fslmaths \
# "${ROI_V1}.nii.gz" \
# -mul \
# ${pRF_90_Bckgrd} \
# ${strPthOut}V1_Bckgrd_95_0p8.nii.gz
# #-------------------------------------------------------------------------------
# # Apply center to V2
# fslmaths \
# "${ROI_V2}.nii.gz" \
# -mul \
# ${pRF_90_Center} \
# ${strPthOut}V2_Center_95_0p8.nii.gz
# # Apply edge to V2
# fslmaths \
# "${ROI_V2}.nii.gz" \
# -mul \
# ${pRF_90_Edge} \
# ${strPthOut}V2_Edge_95_0p8.nii.gz
# # Apply Background to V2
# fslmaths \
# "${ROI_V2}.nii.gz" \
# -mul \
# ${pRF_90_Bckgrd} \
# ${strPthOut}V2_Bckgrd_95_0p8.nii.gz \
# #-------------------------------------------------------------------------------
# # Apply center to V3
# fslmaths \
# "${ROI_V3}.nii.gz" \
# -mul \
# ${pRF_90_Center} \
# ${strPthOut}V3_Center_95_0p8.nii.gz
# # Apply edge to V2
# fslmaths \
# "${ROI_V3}.nii.gz" \
# -mul \
# ${pRF_90_Edge} \
# ${strPthOut}V3_Edge_95_0p8.nii.gz \
# # Apply Background to V2
# fslmaths \
# "${ROI_V3}.nii.gz" \
# -mul \
# ${pRF_90_Bckgrd} \
# ${strPthOut}V3_Bckgrd_95_0p8.nii.gz
#
# #--------------------------------------------------------------------------------
