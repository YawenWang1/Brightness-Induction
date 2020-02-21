#!/bin/bash
### register the anatomay to function in itksnap ############
#Itksnap : registration, get the .txt file for transformation from ana to run_dc
strDataPath="/media/h/P02/Data/S03/Ses01/02_Preprocessing/01_Func/"
dcOutPthup="${strDataPath}04_dist_correction/"
dcFilesPth="${dcOutPthup}00_DC/"
dcTrfFilePth="${dcOutPthup}01_DC_Ana/"
mkdir ${dcTrfFilePth}
anaPthUp="/media/h/P02/Data/S03/Ses01/02_Preprocessing/00_Ana/whole_brain_epi_reference/"
anaFilePth="${anaPthUp}S03_BP_ep3d_0p8_wholebraintemplate0_reg2anaWarped.nii.gz"

for runid in {1..1}
do

  $ANTSPATH/antsApplyTransforms \
  -d 3 \
  -i ${dcFilesPth}fun_0${runid}_dc_template0.nii.gz \
  -r ${anaFilePth} \
  -o ${dcTrfFilePth}fun_0${runid}_dc_template0_reg2wbepi.nii.gz \
  -n BSpline[4] \
  -t [${dcFilesPth}EPI_3d_to_fun_0${runid}.txt,1] \
  -v 1
done
