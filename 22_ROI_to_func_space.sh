#! /bin/bash

# Register ROI to functional space (function 1:6)
#-------------------------------------------------------------------------------------
currPth="/media/h/P04/Data/S04/Ses01/03_GLM/SriPlay/"
strPathOrig=$PWD
echo ${strPathOrig}

currPthout="/media/h/P04/Data/S04/Ses01/03_GLM/SriPlay/ROI_masks/func_space/"
mkdir ${currPthout}

cd ${currPth}ROI_masks/pRF_OC_ROI/
Files=( $(ls | grep .nii.gz) )
echo ${Files}
numFiles=${#Files[@]}
numFiles=$(($numFiles - 1))
echo ${numFiles}
cd ${strPathOrig}

for i in $(seq 0 $numFiles); do
  $ANTSPATH/antsApplyTransforms \
  -d 3 \
  -i ${currPth}ROI_masks/pRF_OC_ROI/${Files[${i}]} \
  -o ${currPthout}func_${Files[${i}]} \
  -n BSpline[4] \
  -r ${currPth}fun_all_mean.nii.gz \
  -t ${currPth}P04_S03_fun_to_fs_0GenericAffine.mat \
  -v


done
# Register ROI to pRF space
#-------------------------------------------------------------------------------
# for i in $(seq 0 $numFiles); do
#   $ANTSPATH/antsApplyTransforms \
#   -d 3 \
#   -i ${currPth}ROI_masks/${Files[${i}]} \
#   -o ${currPthout}func_${Files[${i}]} \
#   -n BSpline[4] \
#   -r ${currPth}P02_S03_fun_07_filtered_func_data_mean.nii.gz \
#   -t ${currPth}P02_S03_prf_2_fs_01_0GenericAffine.mat \
#   -v
#
#
# done



#Register pRF to functional
#-------------------------------------------------------------------------------
# $ANTSPATH/antsRegistration \
# --verbose 1 --dimensionality 3 --float 1 --collapse-output-transforms 1 \
# --output [ P04_S03_prf_to_fun_,P04_S03_prf_to_fun_Warped.nii.gz,P04_S03_prf_to_fun_InverseWarped.nii.gz ] \
# --interpolation BSpline[4] \
# --use-histogram-matching 1 \
# --winsorize-image-intensities [ 0.005,0.995 ] \
# -x [ fun_01_template0_mask.nii.gz, fun_07_template0_mask_brain_ED.nii.gz ] \
# --initial-moving-transform P02_S03_pRF_to_sf.txt \
# --transform Rigid[ 0.1 ] \
# --metric CC[ fun_all_mean.nii.gz,P02_S03_fun_07_filtered_func_data_mean.nii.gz,1,4 ] \
# --convergence [ 100x50,1e-6,10 ] --shrink-factors 2x1 --smoothing-sigmas 2x0vox
