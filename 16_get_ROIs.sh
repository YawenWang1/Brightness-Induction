#! /bin/bash
# Apply transformation for results from pyprf took in 0h:0m:48s.

start_tme=$(date +%s)

# Define all the pRF files
pRF_roi_Pth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/Anat_space/pRF/ROI/'
export varea_namearray=(1 "v1" "v2" "v3")
export prf_roi_namearray=(1 "background" "centre" "edge")
vareapth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/Anat_space/Masks/'

for vid in {1..3}; do
  for sid in {1..3}; do

  fslmaths ${vareapth}sub-02_ses-002_${varea_namearray[${vid}]}.nii.gz \
  -mul ${pRF_roi_Pth}pRF_results_ovrlp_mask_50prct_${prf_roi_namearray[${sid}]}_reg2fsanat.nii.gz \
  ${vareapth}sub-02_ses-002_${varea_namearray[${vid}]}_${prf_roi_namearray[${sid}]}.nii.gz
done
done


end_tme=$(date +%s)
nettme=$(expr $end_tme - $start_tme)
echo " "
echo "-----> Transform label to nii files took in $(($nettme / 3600))h:$(($nettme % 3600 / 60))m:$(($nettme % 60))s."
echo " "

#
# strPathOrig=$PWD
# echo ${strPathOrig}
# # Move all the prf to surface (left and right hemisphere)
# # currPth="/media/h/P04/Data/S04/Ses01/03_GLM/tst/07_ctr/"
# currPth="/media/h/P04/Data/S04/Ses01/03_GLM/SriPlay/pRF_OC_ROI_masks_glm/04_up_sub_down/"
# currPthout="/media/h/P04/Data/S04/Ses01/03_GLM/SriPlay/pRF_OC_ROI_masks_glm/03_In_surface/"
# mkdir ${currPthout}
# cd ${currPth}
# Files=( $(ls | grep .nii.gz) )
# echo ${Files}
# numFiles=${#Files[@]}
# numFiles=$(($numFiles - 1))
# echo ${numFiles}
# cd ${strPathOrig}
# for hemi in {"lh","rh"}; do
# for i in $(seq 0 $numFiles); do
#   echo "${currPth}${Files[${i}]}"
#
#   # To get rid of .nii.gz
#   interp="$(cut -d'.' -f 2  <<< ${Files[${i}]})"
#   mri_vol2surf \
#   --mov ${currPth}${Files[${i}]} \
#   --regheader S04 \
#   --hemi ${hemi} \
#   --o ${currPthout}P04_S03_${hemi}_pRF_ROI_up_sub_down_${interp}.nii.gz \
#   --interp nearest
# done
# done
#
# # project lum_down to surface
# currPth="/media/h/P04/Data/S04/Ses01/03_GLM/SriPlay/pRF_OC_ROI_masks_glm/01_Lum_Down/"
# cd ${currPth}
# Files=( $(ls | grep .nii.gz) )
# echo ${Files}
# numFiles=${#Files[@]}
# numFiles=$(($numFiles - 1))
# echo ${numFiles}
# cd ${strPathOrig}
# for hemi in {"lh","rh"}; do
# for i in $(seq 0 $numFiles); do
#   echo "${currPth}${Files[${i}]}"
#   interp="$(cut -d'.' -f 2  <<< ${Files[${i}]})"
#
#   mri_vol2surf \
#   --mov ${currPth}${Files[${i}]} \
#   --regheader S04 \
#   --hemi ${hemi} \
#   --o ${currPthout}P04_S03_${hemi}_pRF_ROI_down_${interp}.nii.gz \
#   --interp nearest
# done
# done
#
#
# # project lum_up condition to surface
# currPth="/media/h/P04/Data/S04/Ses01/03_GLM/SriPlay/pRF_OC_ROI_masks_glm/00_Lum_Up/"
# cd ${currPth}
# Files=( $(ls | grep .nii.gz) )
# echo ${Files}
# numFiles=${#Files[@]}
# numFiles=$(($numFiles - 1))
# echo ${numFiles}
# cd ${strPathOrig}
# for hemi in {"lh","rh"}; do
# for i in $(seq 0 $numFiles); do
#   echo "${currPth}${Files[${i}]}"
#   interp="$(cut -d'.' -f 2  <<< ${Files[${i}]})"
#
#   mri_vol2surf \
#   --mov ${currPth}${Files[${i}]} \
#   --regheader S04 \
#   --hemi ${hemi} \
#   --o ${currPthout}P04_S03_${hemi}_pRF_ROI_up_${interp}.nii.gz \
#   --interp nearest
# done
# done
#
#
#
#
#
#
#
#
# # Look at the data from freeview
# # freeview -f $SUBJECTS_DIR/S04/surf/lh.inflated:overlay=./results_227vols_polar_angle_reg2anat_lh.nii.gz:label=/media/h/P04/Data/S04/Ses01/03_GLM/00_Ana/S04/label/lh.benson14atlas.V1.label:label=/media/h/P04/Data/S04/Ses01/03_GLM/00_Ana/S04/label/lh.benson14atlas.V2.label
