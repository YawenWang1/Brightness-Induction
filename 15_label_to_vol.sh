#! /bin/bash
# Apply transformation for results from pyprf took in 0h:0m:48s.

start_tme=$(date +%s)

# Define all the pRF files
export SUBJECTS_DIR=/media/h/P04/Data/BIDS/sub-02/ses-002/anat
export varea_namearray=(1 "v1" "v2v" "v2d" "v3v" "v3d")
subjID='sub-02'

labelPth='/media/h/P04/Data/BIDS/sub-02/ses-002/anat/sub-02/label/'
outpth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/Anat_space/Masks/'

for i in $(seq 1 5); do
for hemi in {"lh","rh"}; do
  currFile=${labelPth}${hemi}.${varea_namearray[${i}]}.mannual
  echo ${currFile}${hemi}.${varea_namearray}.mannual.label
  mri_label2vol --label ${currFile} --identity --fill-ribbon --subject ${subjID} --hemi ${hemi} --o ${outpth}sub-02_ses-002_${hemi}_${varea_namearray[${i}]}.nii.gz

done
fslmaths ${outpth}sub-02_ses-002_lh_${varea_namearray[${i}]}.nii.gz -add ${outpth}sub-02_ses-002_rh_${varea_namearray[${i}]}.nii.gz ${outpth}sub-02_ses-002_${varea_namearray[${i}]}.nii.gz
done


fslmaths ${outpth}sub-02_ses-002_v2v.nii.gz -add ${outpth}sub-02_ses-002_v2d.nii.gz ${outpth}sub-02_ses-002_v2.nii.gz
fslmaths ${outpth}sub-02_ses-002_v3v.nii.gz -add ${outpth}sub-02_ses-002_v3d.nii.gz ${outpth}sub-02_ses-002_v3.nii.gz


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
