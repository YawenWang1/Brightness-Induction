#! /bin/bash
################################################################################

# Run Motion correction for pRF runs
# 20 mins
################################################################################
# Directory of sri's motion correction and distortion correction code
start_tme=$(date +%s)

################################################################################
# Simple formatting
# Start bold text
bold=$(tput bold)
# Turn off all attributes
normal=$(tput sgr0)

################################################################################


Pth='/media/h/P04/Data/BIDS/'
subject_id='sub-02'
session_id='ses-001'
TR=2.604
Ana_Pth=${Pth}${subject_id}/${session_id}/anat/
INV2_Image='sub-02_ses-002_acq-MP2RAGE_run-1_mod-INV2_T1w'

################################################################################
#            Create a Mask and fixed functional Image first                    #
# ################################################################################
# # Make new functional mask
echo "-----> Creating Brain mask for the anatomy from INV2."
echo ""
## Run N4 many times
for i in {1..3}; do
    if [ "$i" -eq "1" ]; then
        N4BiasFieldCorrection \
        --image-dimensionality 3 \
        --shrink-factor 4 \
        --rescale-intensities 1 \
        --bspline-fitting [200] \
        --convergence [200x200x200x200,1e-9] \
        --input-image ${Ana_Pth}${INV2_Image}.nii.gz \
        --output ${Ana_Pth}${INV2_Image}$_N4.nii.gz
    else
        N4BiasFieldCorrection \
        --image-dimensionality 3 \
        --shrink-factor 2 \
        --rescale-intensities 1 \
        --bspline-fitting [200] \
        --convergence [50x50x50x50,1e-9] \
        --input-image ${Ana_Pth}${INV2_Image}.nii.gz \
        --output ${Ana_Pth}${INV2_Image}.nii.gz
    fi

done

## DENOISE BEFORE MASKING
DenoiseImage \
--image-dimensionality 3 \
--input-image ${Ana_Pth}${INV2_Image}$_N4.nii.gz \
--noise-model Rician \
--output ${Ana_Pth}${INV2_Image}$_N4_DEN.nii.gz


$ANTSPATH/ImageMath \
3 \
${Ana_Pth}${INV2_Image}$_N4_DEN_Mask.nii.gz \
ThresholdAtMean \
${Ana_Pth}${INV2_Image}$_N4_DEN.nii.gz \
1.2

## MORPHOLOGICAL EROSION TO REDUCE EDGE EFFECTS
$ANTSPATH/ImageMath \
3 \
${fun_Pth}${pRF_prefix}${FixRunID}_echo-1_bold_fixedMask.nii.gz \
ME \
${fun_Pth}${pRF_prefix}${FixRunID}_echo-1_bold_fixedMask.nii.gz \
2

## GET THE LARGEST COMPONENT
$ANTSPATH/ImageMath \
3 \
${fun_Pth}${pRF_prefix}${FixRunID}_echo-1_bold_fixedMask.nii.gz \
GetLargestComponent \
${fun_Pth}${pRF_prefix}${FixRunID}_echo-1_bold_fixedMask.nii.gz \

## FILL HOLES
$ANTSPATH/ImageMath \
3 \
${fun_Pth}${pRF_prefix}${FixRunID}_echo-1_bold_fixedMask.nii.gz \
FillHoles \
${fun_Pth}${pRF_prefix}${FixRunID}_echo-1_bold_fixedMask.nii.gz \

## MORPHOLOGICAL DILATION
$ANTSPATH/ImageMath \
3 \
${fun_Pth}${pRF_prefix}${FixRunID}_echo-1_bold_fixedMask.nii.gz \
MD \
${fun_Pth}${pRF_prefix}${FixRunID}_echo-1_bold_fixedMask.nii.gz \
4

## MORPHOLOGICAL EROSION
$ANTSPATH/ImageMath \
3 \
${fun_Pth}${pRF_prefix}${FixRunID}_echo-1_bold_fixedMask.nii.gz \
ME \
${fun_Pth}${pRF_prefix}${FixRunID}_echo-1_bold_fixedMask.nii.gz \
2

# Remove unwanted data
rm \
${fun_Pth}${pRF_prefix}${FixRunID}_echo-1_bold_fixed_N4.nii.gz \
${fun_Pth}${pRF_prefix}${FixRunID}_echo-1_bold_fixed_N4_DEN.nii.gz

rm -rf ${Fun_ROI_Folder}


echo "-----> Finished to make a mask for pRF runs."
echo " "

echo " "
end_tme=$(date +%s)
nettme=$(expr $end_tme - $start_tme)
echo "-----> It took in $(($nettme / 3600))h:$(($nettme % 3600 / 60))m:$(($nettme % 60))s."
echo " "
