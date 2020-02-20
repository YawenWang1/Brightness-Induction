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
Msk_namearray=(1 "mask_pt2" "mask_pt15" "mask_pt27")
# Msk_posfix=(1 \
# "mask_90prct_background" \
# "mask_90prct_square_centre" \
# "mask_90prct_square_edge" \
# "mask_95prct_background" \
# "mask_95prct_square_centre" \
# "mask_95prct_square_edge" \
# "ratio_background" \
# "ratio_square_centre" \
# "ratio_square_edge")
Msk_posfix=(1 \
"ctnr_background" \
"ctnr_square_centre" \
"ctnr_square_edge")
strPathOrig=$PWD
inter="_pRF_results_227vol_1run_sm_hpfovrlp_"
# inter="_pRF_results_227vol_1run_sm_hpfovrlp_"
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
    echo ${currGLMfile}


    if [ $condID -eq 3 ];
    then
      interp="$(cut -d'.' -f 1  <<< ${glmFiles[${glmFile}]})"
      # First convert .nii.gz to .mgz
      # To get rid of the redundant P02_S03
      interp01="$(cut -d'_' -f 7 <<<${interp})"
    else
      # Get the name
      # To get rid of .nii.gz
      interp="$(cut -d'.' -f 1  <<< ${glmFiles[${glmFile}]})"
      # First convert .nii.gz to .mgz
      # To get rid of the redundant P02_S03
      interp01="$(cut -d'_' -f 5 <<<${interp})"

    fi

    echo ${interp01}

    for ROIID in {1..3}
    do

      for MskThrsh in {2..2}
      do
        for MskPosId in {1..3}
        do
          # get the correct
          # current ROI
          currROI=${strROIPthIn}${ROI_namearray[${ROIID}]}_${Msk_namearray[${MskThrsh}]}${inter}${Msk_posfix[${MskPosId}]}.nii.gz
          echo ${currROI}
          # Get the name

          # current output
          # curroutput=${strOut01}/${ROI_namearray[${ROIID}]}_${Msk_namearray[${MskThrsh}]}${inter}${Msk_posfix[${MskPosId}]}${glmFiles[${glmFile}]}

          curroutput=${strOut01}/${ROI_namearray[${ROIID}]}_${Msk_posfix[${MskPosId}]}_${interp01}.nii.gz
          # Apply ROI to glm
          fslmaths \
          ${currGLMfile} \
          -mul \
          ${currROI} \
          ${curroutput}


        done
      done
    done
  done
done
