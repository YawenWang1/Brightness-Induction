#!/bin/bash
#####Give better registration###################################################
### Create a concatenated linear and differomorphic distortion warp ############
strDataPath="/media/h/P04/Data/S04/Ses01/02_Preprocessing/01_Func/"
##for functional runs###########################################################
dctrfFilesPth="${strDataPath}04_dist_correction/00_DC/"
mocoTrfPthUp="${strDataPath}05_MoCo/00_fun_se/"
OutPth="${strDataPath}06_Tglm/"
mkdir ${OutPth}
##for functional runs########################################################
#Define reference image and mask image
# refImg="${dctrfFilesPth}fun_07_dc_template0.nii.gz"
anaPath="/media/h/P04/Data/S04/Ses01/03_GLM/00_Ana/S04/mri/"
refImg="${anaPath}brain.nii.gz"
ana2pRfTxt="${anaPath}fun_07_To_Ana.txt"
for runid in {7..7}
do


  funPth="${mocoTrfPthUp}run_0${runid}_subset/"
  currOutFolder="${OutPth}run_0${runid}_subset/"
  mkdir ${currOutFolder}
  dcmatTrf="${dctrfFilesPth}fun_0${runid}_dc_fun_0${runid}_template000GenericAffine.mat"
  echo ${dcmatTrf}
  dcwarp="${dctrfFilesPth}fun_0${runid}_dc_fun_0${runid}_template001Warp.nii.gz"
  echo ${dcwarp}

  # echo ${dc2anaTxt}
  curr4dfun="${OutPth}fun_0${runid}_MDCoreg_01.nii.gz"
  #different run has different volumes
  for volid in {1000..1227}
  do
    currIn="${funPth}fun_0${runid}_vol_${volid}.nii.gz"
    echo ${currIn}
    mocoTrf="${funPth}fun_0${runid}_vol_${volid}_0GenericAffine.mat"
    echo ${mocoTrf}
    currOut="${currOutFolder}fun_0${runid}_vol_${volid}_MC_DC_Coreg_01.nii.gz"
    $ANTSPATH/antsApplyTransforms \
    -d 3 \
    --float \
    -i ${currIn} \
    -r ${refImg} \
    -o ${currOut} \
    -n BSpline[4] \
    -t ${ana2pRfTxt} \
    -t ${mocoTrf} \
    -t ${dcwarp} \
    -t ${dcmatTrf} \
    -v 1

    fslmaths \
    ${currOut} \
    ${currOutFolder}fun_0${runid}_vol_${volid}_MC_DC_Coreg_srt_01.nii.gz \
    -odt short


  done
  $ANTSPATH/ImageMath \
  4 \
  ${curr4dfun} \
  TimeSeriesAssemble \
  2.604 \
  0 \
  ${currOutFolder}/*_MC_DC_Coreg_srt_01.nii.gz

done
