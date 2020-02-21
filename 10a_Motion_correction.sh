#!/bin/bash
##This script is to correct motion in all the func and ope runs#############
strDataPath="/media/h/P04/Data/S04/Ses01/02_Preprocessing/01_Func/"
##for functional runs########################################################
funPath="${strDataPath}00_fun_se/gz/"
funOutPthup="${strDataPath}05_MoCo/00_fun_se/"
mkdir ${funOutPthup}
#Define reference image and mask image
refImg="${strDataPath}02_fun_mean_images/fun_07_template0.nii.gz"
mskImg="${strDataPath}03_fun_masks/fun_07_template0_mask_ED.nii.gz"
date
for runid in {7..7}
do
  funOut="${funOutPthup}run_0${runid}_subset/"
  mkdir ${funOut}
  currfun="${funPath}fun_0${runid}.nii.gz"
  # # #Disasseble 4d into 3d imges
  # $ANTSPATH/ImageMath \
  # 4 \
  # ${funOut}/fun_0${runid}_vol_.nii.gz \
  # TimeSeriesDisassemble \
  # ${currfun}

  #different run has different volumes

  for volid in {1000..1227}
  do
    $ANTSPATH/antsRegistrationSyN.sh \
    -d 3 \
    -e 42 \
    -f ${refImg} \
    -m ${funOut}/fun_0${runid}_vol_${volid}.nii.gz \
    -x ${mskImg} \
    -o ${funOut}/fun_0${runid}_vol_${volid}_ \
    -p f \
    -j 1 \
    -t r \
    -n 16

    $ANTSPATH/antsRegistration --verbose 1 \
    --random-seed 42 --dimensionality 3 --float 1 \
    --collapse-output-transforms 1 \
    --output [ ${funOut}/fun_0${runid}_vol_${volid}_,${funOut}/fun_0${runid}_vol_${volid}_Warped.nii.gz,1 ] \
    --interpolation BSpline[4] \
    --use-histogram-matching 1 \
    --winsorize-image-intensities [ 0.005,0.995 ] \
    -x [ ${mskImg}, 1 ] \
    --initial-moving-transform [ ${refImg},${funOut}/fun_0${runid}_vol_${volid}.nii.gz,1 ] --transform Rigid[ 0.1 ] \
    --metric MI[ ${refImg},${funOut}/fun_0${runid}_vol_${volid}.nii.gz,1,32,Regular,0.25 ] \
    --convergence [ 250x100,1e-6,10 ] --shrink-factors 2x1 --smoothing-sigmas 1x0vox

    fslmaths \
    ${funOut}fun_0${runid}_vol_${volid}_Warped.nii.gz \
    ${funOut}fun_0${runid}_vol_${volid}_Warped_srt.nii.gz \
    -odt short




  done
  $ANTSPATH/ImageMath 4 ${funOut}fun_0${runid}_mc.nii.gz \
  TimeSeriesAssemble 2.604 0 ${funOut}*_Warped_srt.nii.gz \


  fslmaths \
  ${funOut}fun_0${runid}_mc.nii.gz \
  -Tmean\
  ${funOut}fun_0${runid}_mc_mean.nii.gz \
  -odt short



done
date
