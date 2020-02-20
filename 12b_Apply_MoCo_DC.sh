#!/bin/bash
### Create a concatenated linear and differomorphic distortion warp ############
strDataPath="/media/h/P04/Data/S04/Ses01/02_Preprocessing/01_Func/"
##for functional runs###########################################################
dctrfFilesPth="${strDataPath}04_dist_correction/00_DC/"
mocoTrfPthUp="${strDataPath}05_MoCo/00_fun_se/"
OutPth="${strDataPath}06_Tglm/"
mkdir ${OutPth}
anaPthUp="/media/h/P02/Data/S03/Ses01/02_Preprocessing/00_Ana/whole_brain_epi_reference/"
anaFilePth="${anaPthUp}S03_BP_ep3d_0p8_wholebraintemplate0_reg2anaWarped.nii.gz"

##for functional runs########################################################
#Define reference image and mask image
# refImg="/media/h/P02/Data/S02/Ses01/02_Preprocessing/00_Ana/brain_den.nii.gz"
refImg="${anaPthUp}S03_BP_ep3d_0p8_wholebraintemplate0_reg2anaWarped.nii.gz"
epiwh2dcTxt="${dctrfFilesPth}EPI_3d_to_fun_01.txt"
echo ${epiwh2dcTxt}

for runid in {1..6}
do


  funPth="${mocoTrfPthUp}run_0${runid}_subset/"
  currOutFolder="${OutPth}run_0${runid}_subset_MC_DC_Coreg/"
  mkdir ${currOutFolder}
  dcmatTrf="${dctrfFilesPth}fun_0${runid}_dc_fun_0${runid}_template000GenericAffine.mat"
  echo ${dcmatTrf}
  dcwarp="${dctrfFilesPth}fun_0${runid}_dc_fun_0${runid}_template001Warp.nii.gz"
  echo ${dcwarp}
  curr4dfun="${OutPth}fun_0${runid}_MDCoreg.nii.gz"
  #different run has different volumes
  for volid in {1000..1219}
  do
    currIn="${funPth}fun_0${runid}_vol_${volid}.nii.gz"
    echo ${currIn}
    mocoTrf="${funPth}fun_0${runid}_vol_${volid}_0GenericAffine.mat"
    echo ${mocoTrf}
    currOut="${currOutFolder}fun_0${runid}_vol_${volid}_MC_DC_Coreg.nii.gz"
    $ANTSPATH/antsApplyTransforms \
    -d 3 \
    --float \
    -i ${currIn} \
    -r ${refImg} \
    -o ${currOut} \
    -n BSpline[4] \
    -t [${epiwh2dcTxt},1] \
    -t ${dcwarp} \
    -t ${dcmatTrf} \
    -t ${mocoTrf} \
    -v 1

    fslmaths \
    ${currOut} \
    ${currOutFolder}fun_0${runid}_vol_${volid}_MC_DC_Coreg_srt.nii.gz \
    -odt short


  done
  $ANTSPATH/ImageMath \
  4 \
  ${curr4dfun} \
  TimeSeriesAssemble \
  2.604 \
  0 \
  ${currOutFolder}/*_MC_DC_Coreg_srt.nii.gz

done


for runid in {7..8}
do
  funPth="${mocoTrfPthUp}run_0${runid}_subset/"
  currOutFolder="${OutPth}run_0${runid}_subset_MC_DC_Coreg/"
  mkdir ${currOutFolder}
  dcmatTrf="${dctrfFilesPth}fun_0${runid}_dc_fun_0${runid}_template000GenericAffine.mat"
  echo ${dcmatTrf}
  dcwarp="${dctrfFilesPth}fun_0${runid}_dc_fun_0${runid}_template001Warp.nii.gz"
  echo ${dcwarp}
  # ana2dcTxt="${dcanaFilePth}fun_0${runid}_ana_to_dc.txt"
  # echo ${dc2anaTxt}
  curr4dfun="${OutPth}fun_0${runid}_MDCoreg.nii.gz"
  #different run has different volumes
  for volid in {1000..1227}
  do
    currIn="${funPth}fun_0${runid}_vol_${volid}.nii.gz"
    echo ${currIn}
    mocoTrf="${funPth}fun_0${runid}_vol_${volid}_0GenericAffine.mat"
    echo ${mocoTrf}
    currOut="${currOutFolder}fun_0${runid}_vol_${volid}_MC_DC_Coreg.nii.gz"
    $ANTSPATH/antsApplyTransforms \
    -d 3 \
    --float \
    -i ${currIn} \
    -r ${refImg} \
    -o ${currOut} \
    -n BSpline[4] \
    -t [${epiwh2dcTxt},1] \
    -t ${dcwarp} \
    -t ${dcmatTrf} \
    -t ${mocoTrf} \
    -v 1

    fslmaths \
    ${currOut} \
    ${currOutFolder}fun_0${runid}_vol_${volid}_MC_DC_Coreg_srt.nii.gz \
    -odt short


  done
  $ANTSPATH/ImageMath \
  4 \
  ${curr4dfun} \
  TimeSeriesAssemble \
  2.604 \
  0 \
  ${currOutFolder}/*_MC_DC_Coreg_srt.nii.gz

done
