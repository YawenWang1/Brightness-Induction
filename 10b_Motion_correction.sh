#!/bin/bash
##This script is to correct motion in all the func and ope runs#############
strDataPath="/media/h/P04/Data/S04/Ses01/02_Preprocessing/01_Func/"
##for functional runs######################################################
opePath="${strDataPath}01_fun_se_op/"
opeOutPthup="${strDataPath}/05_MoCo/01_fun_se_op/"
mkdir ${opeOutPthup}
for runid in {1..7}
do
  opeOut="${opeOutPthup}run_0${runid}_op_subset/"
  mkdir ${opeOut}
  currOpe="${opePath}fun_0${runid}_ope.nii.gz"

  $ANTSPATH/ImageMath \
  4 \
  "${opeOut}fun_0${runid}_ope_vol_.nii.gz" \
  TimeSeriesDisassemble \
  ${currOpe}
  #Define reference image and mask image
  refImg="${strDataPath}02_fun_mean_images/fun_0${runid}_ope_template0.nii.gz"
  mskImg="${strDataPath}03_fun_masks/fun_0${runid}_template0_mask.nii.gz"
  #different run has different volumes

  for volid in {1000..1004}
  do

      $ANTSPATH/antsRegistration --verbose 1 \
      --random-seed 42 --dimensionality 3 --float 1 \
      --collapse-output-transforms 1 \
      --output [ ${opeOut}fun_0${runid}_ope_vol_${volid}_,${opeOut}fun_0${runid}_ope_vol_${volid}_Warped.nii.gz,1 ] \
      --interpolation BSpline[4] \
      --use-histogram-matching 1 \
      --winsorize-image-intensities [ 0.005,0.995 ] \
      -x [ ${mskImg}, 1 ] \
      --initial-moving-transform [ ${refImg},${opeOut}fun_0${runid}_ope_vol_${volid}.nii.gz,1 ] --transform Rigid[ 0.1 ] \
      --metric MI[ ${refImg},${opeOut}fun_0${runid}_ope_vol_${volid}.nii.gz,1,32,Regular,0.25 ] \
      --convergence [ 250x100,1e-6,10 ] --shrink-factors 2x1 --smoothing-sigmas 1x0vox

      fslmaths \
      ${funOut}fun_0${runid}_ope_vol_${volid}_Warped.nii.gz \
      ${funOut}fun_0${runid}_ope_vol_${volid}_Warped_srt.nii.gz \
      -odt short

  done

  $ANTSPATH/ImageMath 4 ${funOut}fun_0${runid}_ope_mc.nii.gz \
  TimeSeriesAssemble 2.604 0 ${funOut}*_Warped_srt.nii.gz \


  fslmaths \
  ${funOut}fun_0${runid}_ope_mc.nii.gz \
  -Tmean\
  ${funOut}fun_0${runid}_ope_mc_mean.nii.gz \
  -odt short



done
