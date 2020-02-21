#!/bin/bash
#-------------------------------------------------------------------------------
# Define glm directory
strPthIn="/media/h/P04/Data/S04/Ses01/03_GLM/04_ASpace/"
# Define ROI directory
strROIPthIn="/media/h/P04/Data/S04/Ses01/03_GLM/SriPlay/ROI_masks/"
# strOut="/media/h/P04/Data/S04/Ses01/03_GLM/SriPlay/ROI_masks_glm/"
strOut="/media/h/P04/Data/S04/Ses01/03_GLM/SriPlay/pRF_OC_ROI_masks_glm/"

mkdir ${strOut}
# Define names
glm_results=(1 "00_Lum_Up" "01_Lum_Down" "04_up_sub_down")
ROI_namearray=(1 "benson14atlas.V1" "benson14atlas.V2" "benson14atlas.V3")
OC_ROIPth="/media/h/P04/Data/S04/Ses01/03_GLM/SriPlay/"
Msk_posfix=(1 \
"cntr_background" \
"cntr_square_centre" \
"cntr_square_edge")
strPathOrig=$PWD
inter="_pRF_results_227vol_1run_sm_hpfovrlp_"
# Apply ROIs for GLM results
for condID in {1..3}
do
  # current condition
  strOut01=${strOut}${glm_results[${condID}]}
  # Make new folder
  mkdir ${strOut01}
  # Current glm result folder
  currentglm=${strPthIn}${glm_results[${condID}]}
  cd ${currentglm}
  glmFiles=( $(ls | grep .nii.gz) )
  numGLM=${#glmFiles[@]}
  numGLM=$(($numGLM - 1))
  cd ${strPathOrig}
  for glmFile in $(seq 0 $numGLM)
  do
    # Current glm file
    currGLMfile=${currentglm}/${glmFiles[${glmFile}]}
    for ROIID in {1..3}
    do
          # current ROI
          currROI=${OC_ROIPth}${ROI_namearray[${ROIID}]}.nii.gz
          echo ${currROI}
          # current output
          curroutput=${strOut01}/${ROI_namearray[${ROIID}]}_${glmFiles[${glmFile}]}
          # Apply ROI to glm
          fslmaths \
          ${currGLMfile} \
          -mul \
          ${currROI} \
          ${curroutput}

    done
  done
done
