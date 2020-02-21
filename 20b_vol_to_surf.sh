#! /bin/bash

#--------------------------------------------------------------------------------------

# Define all the pRF files
export SUBJECTS_DIR=/media/h/P04/Data/S04/Ses01/03_GLM/00_Ana

strPathOrig=$PWD
echo ${strPathOrig}
# Move all the prf to surface (left and right hemisphere)
# currPth="/media/h/P04/Data/S04/Ses01/03_GLM/tst/07_ctr/"
currPth="/media/h/P04/Data/S04/Ses01/03_GLM/SriPlay/OC_ROI_masks_glm/01_Lum_Down/"
currPthout="/media/h/P04/Data/S04/Ses01/03_GLM/SriPlay/OC_ROI_masks_glm/Surf_ROI/"
mkdir ${currPthout}
cd ${currPth}
Files=( $(ls | grep .nii.gz) )
echo ${Files}
numFiles=${#Files[@]}
numFiles=$(($numFiles - 1))
echo ${numFiles}
cd ${strPathOrig}
for hemi in {"lh","rh"}; do
for i in $(seq 0 $numFiles); do
  echo "${currPth}${Files[${i}]}"
  mri_vol2surf \
  --mov ${currPth}${Files[${i}]} \
  --regheader S04 \
  --hemi ${hemi} \
  --o ${currPthout}P04_S03_${hemi}_down_${Files[${i}]} \
  --interp nearest
done
done



# Move all the prf to surface (left and right hemisphere)
# currPth="/media/h/P04/Data/S04/Ses01/03_GLM/tst/07_ctr/"
currPth="/media/h/P04/Data/S04/Ses01/03_GLM/SriPlay/OC_ROI_masks_glm/00_Lum_Up/"
currPthout="/media/h/P04/Data/S04/Ses01/03_GLM/SriPlay/OC_ROI_masks_glm/Surf_ROI/"
mkdir ${currPthout}
cd ${currPth}
Files=( $(ls | grep .nii.gz) )
echo ${Files}
numFiles=${#Files[@]}
numFiles=$(($numFiles - 1))
echo ${numFiles}
cd ${strPathOrig}
for hemi in {"lh","rh"}; do
for i in $(seq 0 $numFiles); do
  echo "${currPth}${Files[${i}]}"
  mri_vol2surf \
  --mov ${currPth}${Files[${i}]} \
  --regheader S04 \
  --hemi ${hemi} \
  --o ${currPthout}P04_S03_${hemi}_up_${Files[${i}]} \
  --interp nearest
done
done


# Move all the prf to surface (left and right hemisphere)
# currPth="/media/h/P04/Data/S04/Ses01/03_GLM/tst/07_ctr/"
currPth="/media/h/P04/Data/S04/Ses01/03_GLM/SriPlay/OC_ROI_masks_glm/04_up_sub_down/"
currPthout="/media/h/P04/Data/S04/Ses01/03_GLM/SriPlay/OC_ROI_masks_glm/Surf_ROI/"
mkdir ${currPthout}
cd ${currPth}
Files=( $(ls | grep .nii.gz) )
echo ${Files}
numFiles=${#Files[@]}
numFiles=$(($numFiles - 1))
echo ${numFiles}
cd ${strPathOrig}
for hemi in {"lh","rh"}; do
for i in $(seq 0 $numFiles); do
  echo "${currPth}${Files[${i}]}"
  mri_vol2surf \
  --mov ${currPth}${Files[${i}]} \
  --regheader S04 \
  --hemi ${hemi} \
  --o ${currPthout}P04_S03_${hemi}_up_sub_down_${Files[${i}]} \
  --interp nearest
done
done



# Look at the data from freeview
#
# freeview -f $SUBJECTS_DIR/S04/surf/lh.inflated:overlay=./results_227vols_polar_angle_reg2anat_lh.nii.gz:label=/media/h/P04/Data/S04/Ses01/03_GLM/00_Ana/S04/label/lh.benson14atlas.V1.label:label=/media/h/P04/Data/S04/Ses01/03_GLM/00_Ana/S04/label/lh.benson14atlas.V2.label
