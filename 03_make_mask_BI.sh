#! /bin/bash
################################################################################

# Run Motion correction for BI runs
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
subject_id='sub-03'
session_id='ses-002'
TR=2.604
ope_Pth=${Pth}${subject_id}/${session_id}/func/func_ope/
ope_Image=${subject_id}_${session_id}_task-BI_acq-EP3D_dir-LR_run-1_echo-1_bold

################################################################################
#            Create a Mask and fixed functional Image first                    #
# START MOTION CORRECTION ON FIRST 5 VOLS
FixRunID=1
fun_Pth=${Pth}${subject_id}/${session_id}/func/
BI_prefix='sub-03_ses-002_task-BI_acq-EP3D_dir-RL_run-'
fun_suffix='_echo-1_bold'
fun_roi_suffix='_echo-1_bold_roi'
suffix='.nii.gz'
FixedFun=${BI_prefix}${FixRunID}${fun_suffix}
FixedFun_roi=${BI_prefix}${FixRunID}${fun_roi_suffix}
echo "-----> Making a fixed Image for BI runs."
echo " "
# Get the dimension of BI run at [x,y,z]
xmax=$($ANTSPATH/PrintHeader ${fun_Pth}${FixedFun}.nii.gz | grep Dimens | cut -d '[' -f 2 | cut -d ',' -f 1 | cut -d ']' -f 1)
echo ${xmax}
ymax=$($ANTSPATH/PrintHeader ${fun_Pth}${FixedFun}.nii.gz | grep Dimens | cut -d ',' -f 2 | cut -d ']' -f 1)
echo ${ymax}
zmax=$($ANTSPATH/PrintHeader ${fun_Pth}${FixedFun}.nii.gz | grep Dimens | cut -d ',' -f 3 | cut -d ']' -f 1)
echo ${zmax}
tmax=$($ANTSPATH/PrintHeader ${fun_Pth}${FixedFun}.nii.gz | grep Dimens | cut -d ',' -f 4 | cut -d ']' -f 1)
echo ${tmax}
# Crop the first five volums of the 1st BI run to make the fixed image
echo "Crop the first five volume from :"
echo ${FixedFun_roi}${suffix}
echo "-----------------------------------------------------------------"
# #
fslroi \
${fun_Pth}${FixedFun}.nii.gz \
${fun_Pth}${FixedFun_roi}${suffix}.nii.gz \
0 \
${xmax} \
0 \
${ymax} \
0 \
${zmax} \
0 \
5
# #
# # # Define some parameters
basevol=1000 # ANTs indexing
fromvol=$(($basevol + 1))
nthvol=$(($basevol + 4)) # Zero indexing
# # # DISASSEMBLE the roi BI
echo "Making temporary folder to split the first 5 volumes of the 1st Run"
echo "-----------------------------------------------------------------"
Fun_ROI_Folder=${fun_Pth}Fun_roi_split/
mkdir ${Fun_ROI_Folder}
#
$ANTSPATH/ImageMath \
4 \
${Fun_ROI_Folder}${BI_prefix}${FixRunID}_echo-1_bold_.nii.gz \
TimeSeriesDisassemble \
${fun_Pth}${FixedFun_roi}${suffix}
#
for volume in $(eval echo "{$fromvol..$nthvol}"); do

    echo -ne "--------------------> Registering $volume"\\r

    FIXED=${Fun_ROI_Folder}${BI_prefix}${FixRunID}_echo-1_bold_${basevol}.nii.gz
    MOVING=${Fun_ROI_Folder}${BI_prefix}${FixRunID}_echo-1_bold_${volume}.nii.gz
    OUTPUT=${Fun_ROI_Folder}${BI_prefix}${FixRunID}_echo-1_bold_${volume}

    $ANTSPATH/antsRegistration \
    --verbose 0 \
    --float 1 \
    --dimensionality 3 \
    --use-histogram-matching 1 \
    --interpolation BSpline[4] \
    --collapse-output-transforms 1 \
    --output [ ${OUTPUT}_ , ${OUTPUT}_Warped.nii.gz , 1 ] \
    --winsorize-image-intensities [ 0.005 , 0.995 ] \
    --initial-moving-transform [ $FIXED , $MOVING , 1 ] \
    --transform Rigid[0.1] \
    --metric MI[ $FIXED , $MOVING , 1 , 32 , Regular , 0.25] \
    --convergence [ 1000x500x250 , 1e-6 , 10 ] \
    --shrink-factors 4x2x1 \
    --smoothing-sigmas 2x1x0vox \
    --transform Affine[0.1] \
    --metric MI[ $FIXED , $MOVING , 1 , 32 , Regular , 0.25] \
    --convergence [ 500x250x100 , 1e-6 , 10 ] \
    --shrink-factors 4x2x1 \
    --smoothing-sigmas 2x1x0vox

done
#
end_tme=$(date +%s)
nettme=$(expr $end_tme - $start_tme)
#
echo " "
echo "-----> Motion estimation took in $(($nettme / 3600))h:$(($nettme % 3600 / 60))m:$(($nettme % 60))s."
echo " "
#
#
$ANTSPATH/ImageMath \
4 \
${fun_Pth}${BI_prefix}${FixRunID}_echo-1_bold_roi_MoCorr.nii.gz \
TimeSeriesAssemble \
$TR \
0 \
${Fun_ROI_Folder}${BI_prefix}${FixRunID}_echo-1_bold_${basevol}.nii.gz \
${Fun_ROI_Folder}/*_Warped.nii.gz
#
#
#
$ANTSPATH/AverageImages \
3 \
${fun_Pth}${BI_prefix}${FixRunID}_echo-1_bold_fixed.nii.gz \
2 \
${Fun_ROI_Folder}${BI_prefix}${FixRunID}_echo-1_bold_${basevol}.nii.gz \
${Fun_ROI_Folder}/*_Warped.nii.gz

echo "-----> Created motion corrected mean template."
echo " "
#
#
#
# ################################################################################
# # Make new functional mask
echo "-----> Creating Brain mask for the fixed run."
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
        --input-image ${fun_Pth}${BI_prefix}${FixRunID}_echo-1_bold_fixed.nii.gz \
        --output ${fun_Pth}${BI_prefix}${FixRunID}_echo-1_bold_fixed_N4.nii.gz
    else
        N4BiasFieldCorrection \
        --image-dimensionality 3 \
        --shrink-factor 2 \
        --rescale-intensities 1 \
        --bspline-fitting [200] \
        --convergence [50x50x50x50,1e-9] \
        --input-image ${fun_Pth}${BI_prefix}${FixRunID}_echo-1_bold_fixed_N4.nii.gz \
        --output ${fun_Pth}${BI_prefix}${FixRunID}_echo-1_bold_fixed_N4.nii.gz
    fi

done

## DENOISE BEFORE MASKING
DenoiseImage \
--image-dimensionality 3 \
--input-image ${fun_Pth}${BI_prefix}${FixRunID}_echo-1_bold_fixed_N4.nii.gz \
--noise-model Rician \
--output ${fun_Pth}${BI_prefix}${FixRunID}_echo-1_bold_fixed_N4_DEN.nii.gz

## CREATE ROUGH IMAGE MASK AFTER BIAS-CORRECTION
# $ANTSPATH/ThresholdImage \
#     3 \
#     $(dirname $func_data_path)/${func_data_name}_fixed_N4_DEN.nii.gz \
#     $(dirname $func_data_path)/${func_data_name}_fixedMask.nii.gz 100 1.e9

$ANTSPATH/ImageMath \
3 \
${fun_Pth}${BI_prefix}${FixRunID}_echo-1_bold_fixedMask.nii.gz \
ThresholdAtMean \
${fun_Pth}${BI_prefix}${FixRunID}_echo-1_bold_fixed_N4_DEN.nii.gz \
1.2

## MORPHOLOGICAL EROSION TO REDUCE EDGE EFFECTS
$ANTSPATH/ImageMath \
3 \
${fun_Pth}${BI_prefix}${FixRunID}_echo-1_bold_fixedMask.nii.gz \
ME \
${fun_Pth}${BI_prefix}${FixRunID}_echo-1_bold_fixedMask.nii.gz \
2

## GET THE LARGEST COMPONENT
$ANTSPATH/ImageMath \
3 \
${fun_Pth}${BI_prefix}${FixRunID}_echo-1_bold_fixedMask.nii.gz \
GetLargestComponent \
${fun_Pth}${BI_prefix}${FixRunID}_echo-1_bold_fixedMask.nii.gz \

## FILL HOLES
$ANTSPATH/ImageMath \
3 \
${fun_Pth}${BI_prefix}${FixRunID}_echo-1_bold_fixedMask.nii.gz \
FillHoles \
${fun_Pth}${BI_prefix}${FixRunID}_echo-1_bold_fixedMask.nii.gz \

## MORPHOLOGICAL DILATION
$ANTSPATH/ImageMath \
3 \
${fun_Pth}${BI_prefix}${FixRunID}_echo-1_bold_fixedMask.nii.gz \
MD \
${fun_Pth}${BI_prefix}${FixRunID}_echo-1_bold_fixedMask.nii.gz \
4

## MORPHOLOGICAL EROSION
$ANTSPATH/ImageMath \
3 \
${fun_Pth}${BI_prefix}${FixRunID}_echo-1_bold_fixedMask.nii.gz \
ME \
${fun_Pth}${BI_prefix}${FixRunID}_echo-1_bold_fixedMask.nii.gz \
2

# Remove unwanted data
rm \
${fun_Pth}${BI_prefix}${FixRunID}_echo-1_bold_fixed_N4.nii.gz \
${fun_Pth}${BI_prefix}${FixRunID}_echo-1_bold_fixed_N4_DEN.nii.gz

rm -rf ${Fun_ROI_Folder}


echo "-----> Finished to make a mask for BI runs."
echo " "

echo " "
end_tme=$(date +%s)
nettme=$(expr $end_tme - $start_tme)
echo "-----> It took in $(($nettme / 3600))h:$(($nettme % 3600 / 60))m:$(($nettme % 60))s."
echo " "


# Open ITKSNAP and remove the cerebellum and do the following operations
# cd /media/h/P04/Data/BIDS/sub-03/ses-001/func
#
$ANTSPATH/ImageMath 3 sub-03_ses-002_task-BI_acq-EP3D_dir-RL_run-1_echo-1_bold_fixedMask_brain.nii.gz ME sub-03_ses-002_task-BI_acq-EP3D_dir-RL_run-1_echo-1_bold_fixedMask_brain.nii.gz 1
$ANTSPATH/ImageMath 3 sub-03_ses-002_task-BI_acq-EP3D_dir-RL_run-1_echo-1_bold_fixedMask_brain.nii.gz MD sub-03_ses-002_task-BI_acq-EP3D_dir-RL_run-1_echo-1_bold_fixedMask_brain.nii.gz 2
$ANTSPATH/ImageMath 3 sub-03_ses-002_task-BI_acq-EP3D_dir-RL_run-1_echo-1_bold_fixedMask_brain.nii.gz MD sub-03_ses-002_task-BI_acq-EP3D_dir-RL_run-1_echo-1_bold_fixedMask_brain.nii.gz 2
