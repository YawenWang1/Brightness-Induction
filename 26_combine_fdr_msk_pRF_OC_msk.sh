#! /bin/bash
fdrmskPthIn="/media/h/P04/Data/S04/Ses01/03_GLM/04_ASpace/00_Lum_Up.gfeat/cope1.feat/stats/"
outputPth="/media/h/P04/Data/S04/Ses01/03_GLM/SriPlay/ROI_masks/func_space/"
pRF_OC_ROI_Pth="/media/h/P04/Data/S04/Ses01/03_GLM/SriPlay/ROI_masks/func_space/"
out01="${pRF_OC_ROI_Pth}/up/"
mkdir ${out01}
strPathOrig=$PWD
cd ${pRF_OC_ROI_Pth}
FilesROIs=( $(ls | grep func_benson14atlas. | grep .nii.gz) )
numroiFiles=${#FilesROIs[@]}
numroiFiles=$(($numroiFiles - 1))
cd ${strPathOrig}

cd ${fdrmskPthIn}
Filesfdr=( $(ls | grep benson14atlas. | grep .nii.gz) )
numfdrFiles=${#Filesfdr[@]}
numfdrFiles=$(($numfdrFiles - 1))
echo ${numFiles}
cd ${strPathOrig}

# Multiply fdr mask by pRF_OC_ROI
for i in $(seq 0 $numfdrFiles); do

  currfdr=${fdrmskPthIn}${numfdrFiles[${i}]}
  interp01="$(cut -d'.' -f 2 <<< ${numfdrFiles[${i}])"
  # interp02 looks like [V1_background]
  interp02="$(cut -d'_' -f 1,4 <<< $interp01)"

  for roiid in $(seq 0 $numroiFiles);
  do

    currmsk=${pRF_OC_ROI_Pth}${FilesROIs[${roiid}]}

    interp03="$(cut -d'.' -f 2 <<< ${FilesROIs[${roiid}]})"
    # interp04 looks like [V1_background]
    interp04="$(cut -d'_' -f 1,11 <<< ${interp03})"

    if [ ${interp02} -eq ${interp04} ] ;
    then
      
      fslmaths \
      ${currfdr} \
      -mul \
      -${currmsk} \
      ${currout}



    fi


  done

done
