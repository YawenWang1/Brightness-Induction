#! /bin/bash

# Register pRF to anatomy
#--------------------------------------------------------------------------------------

# prf two runs from P02-S03
# /home/yawen/Documents/Compiled_Software/ANTs/Build/bin/antsRegistration \
# --verbose 1 --dimensionality 3 --float 1 --collapse-output-transforms 1 \
# --output [ P02_S03_prf_to_fs_,P02_S03_prf_to_fs_Warped.nii.gz,P02_S03_prf_to_fs_InverseWarped.nii.gz ] \
# --interpolation BSpline[4] \
# --use-histogram-matching 1 \
# --winsorize-image-intensities [ 0.005,0.995 ] \
# -x [ fun_01_template0_mask.nii.gz, brain_mask_ol.nii.gz ] \
# --initial-moving-transform P02_S03_pRF_to_sf.txt \
# --transform Rigid[ 0.1 ] \
# --metric CC[ P02_S03_fun_07_filtered_func_data_mean.nii.gz,brain_finalsurfs.nii.gz,1,4 ] \
# --convergence [ 100x50,1e-6,10 ] --shrink-factors 2x1 --smoothing-sigmas 2x0vox

# Define all the pRF files
export SUBJECTS_DIR=/media/h/P04/Data/S04/Ses01/03_GLM/00_Ana
# export prf_namearray=(1 "polar_angle" "PE_01" "eccentricity" "R2" "SD" "x_pos" "y_pos")

# # 227 volumes
# for i in {1..7}; do
#
# $ANTSPATH/antsApplyTransforms -d 3 \
# -i ./pRF/01_2Runs/results_227vols_${prf_namearray[${i}]}.nii.gz \
# -o results_227vols_02_${prf_namearray[${i}]}_reg2anat.nii.gz \
# -n BSpline[4] \
# -r brain_finalsurfs.nii.gz \
# -t [P02_S03_prf_2_fs_01_0GenericAffine.mat,1] -v
# done
#
# for i in {1..7}; do
#
# $ANTSPATH/antsApplyTransforms -d 3 \
# -i 1Run_ss/results_227vol_1run_sm_hpf_${prf_namearray[${i}]}.nii.gz \
# -o 1Run_ss/results_227vol_1run_sm_hpf_${prf_namearray[${i}]}_reg2anat.nii.gz \
# -n BSpline[4] \
# -r brain_finalsurfs.nii.gz \
# -t [P02_S03_prf_2_fs_01_0GenericAffine.mat,1] -v
# done



strPathOrig=$PWD
echo ${strPathOrig}
# Move all the prf to surface (left and right hemisphere)
# currPth="/media/h/P04/Data/S04/Ses01/03_GLM/tst/07_ctr/"
currPth="/media/h/P04/Data/S04/Ses01/03_GLM/SriPlay/pRF_OC_ROI_masks_glm/04_up_sub_down/"
currPthout="/media/h/P04/Data/S04/Ses01/03_GLM/SriPlay/pRF_OC_ROI_masks_glm/03_In_surface/"
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

  # To get rid of .nii.gz
  interp="$(cut -d'.' -f 2  <<< ${Files[${i}]})"
  mri_vol2surf \
  --mov ${currPth}${Files[${i}]} \
  --regheader S04 \
  --hemi ${hemi} \
  --o ${currPthout}P04_S03_${hemi}_pRF_ROI_up_sub_down_${interp}.nii.gz \
  --interp nearest
done
done

# project lum_down to surface
currPth="/media/h/P04/Data/S04/Ses01/03_GLM/SriPlay/pRF_OC_ROI_masks_glm/01_Lum_Down/"
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
  interp="$(cut -d'.' -f 2  <<< ${Files[${i}]})"

  mri_vol2surf \
  --mov ${currPth}${Files[${i}]} \
  --regheader S04 \
  --hemi ${hemi} \
  --o ${currPthout}P04_S03_${hemi}_pRF_ROI_down_${interp}.nii.gz \
  --interp nearest
done
done


# project lum_up condition to surface
currPth="/media/h/P04/Data/S04/Ses01/03_GLM/SriPlay/pRF_OC_ROI_masks_glm/00_Lum_Up/"
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
  interp="$(cut -d'.' -f 2  <<< ${Files[${i}]})"

  mri_vol2surf \
  --mov ${currPth}${Files[${i}]} \
  --regheader S04 \
  --hemi ${hemi} \
  --o ${currPthout}P04_S03_${hemi}_pRF_ROI_up_${interp}.nii.gz \
  --interp nearest
done
done








# Look at the data from freeview
# freeview -f $SUBJECTS_DIR/S04/surf/lh.inflated:overlay=./results_227vols_polar_angle_reg2anat_lh.nii.gz:label=/media/h/P04/Data/S04/Ses01/03_GLM/00_Ana/S04/label/lh.benson14atlas.V1.label:label=/media/h/P04/Data/S04/Ses01/03_GLM/00_Ana/S04/label/lh.benson14atlas.V2.label
