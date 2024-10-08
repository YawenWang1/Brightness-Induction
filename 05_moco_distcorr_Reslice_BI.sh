#! /bin/bash
################################################################################

# Run Motion correction for all runs
# 1h:31m:28s
################################################################################
# Directory of sri's motion correction and distortion correction code
start_tme=$(date +%s)

Pth='/media/h/P04/Data/BIDS/'
subject_id='sub-03'
session_id='ses-002'
TR=2.604
BI_prefix='sub-03_ses-002_task-BI_acq-EP3D_dir-RL_run-'
fun_suffix='_echo-1_bold'

################################################################################
echo "Start the Reslice of Motion and distortion"

fun_Pth=${Pth}${subject_id}/${session_id}/func/
fixed_Image=${fun_Pth}sub-03_ses-002_task-BI_acq-EP3D_dir-RL_run-1_echo-1_bold_fixed_dc_template0.nii.gz
fixed_Msk=${fun_Pth}sub-03_ses-002_task-BI_acq-EP3D_dir-RL_run-1_echo-1_bold_fixedMask_brain.nii.gz
mkdir ${fun_Pth}GLM/
OutPth="${fun_Pth}GLM/BI/"
mkdir ${OutPth}
dcmatTrf=${fun_Pth}sub-03_ses-002_task-BI_acq-EP3D_dir-RL_run-1_echo-1_bold_fixed_dc_template0GenericAffine.mat
echo ${dcmatTrf}
dcwarp=${fun_Pth}sub-03_ses-002_task-BI_acq-EP3D_dir-RL_run-1_echo-1_bold_fixed_dc_template0warp.nii.gz
echo ${dcwarp}

basevol=1000 # ANTs indexing

#for all the funs during the sessions
for runid in {1..6}
do

  echo "Resclicing BI Run ${runid}  :  "
  echo ${BI_prefix}${runid}${fun_suffix}
  echo " "
  currfmri=${fun_Pth}${BI_prefix}${runid}${fun_suffix}
  currfun3d=${currfmri}_split/
  currfunmc=${currfmri}_mats/
  currOutFolder="${OutPth}run_0${runid}_subset/"
  mkdir ${currOutFolder}

  curr4dfun="${OutPth}BI_fun_0${runid}_MoCo_Dist_Corr_Coreg.nii.gz"
  curr4dfun_srt="${OutPth}BI_fun_0${runid}_MoCo_Dist_Corr_Coreg_srt.nii.gz"

  tmax=$($ANTSPATH/PrintHeader ${currfmri}.nii.gz | grep Dimens | cut -d ',' -f 4 | cut -d ']' -f 1)
  echo ${tmax}

  #different run has different volumes
  for volume in $(seq 1000 $((${tmax} - 1 + 1000)))
  do
    currIn=${currfun3d}${BI_prefix}${runid}${fun_suffix}_${volume}.nii.gz
    echo "current 3d image is :"
    echo ${currIn}
    mocoTrf=${currfunmc}${BI_prefix}${runid}${fun_suffix}_${volume}_0GenericAffine.mat
    echo "current motion matrix is : "
    echo ${mocoTrf}
    currOut01=${currOutFolder}fun_0${runid}_vol_${volume}_MC_DC_Coreg.nii.gz
    currOut02=${currOutFolder}fun_0${runid}_vol_${volume}_MC_DC_Coreg_srt.nii.gz

    $ANTSPATH/antsApplyTransforms \
    -d 3 \
    --float \
    -i ${currIn} \
    -r ${fixed_Image} \
    -o ${currOut01} \
    -n BSpline[4] \
    -t ${dcwarp} \
    -t ${dcmatTrf} \
    -t ${mocoTrf} \
    -v 1

    fslmaths \
    ${currOut01} \
    ${currOut02} \
    -odt short


  done

  $ANTSPATH/ImageMath \
  4 \
  ${curr4dfun_srt} \
  TimeSeriesAssemble \
  2.604 \
  0 \
  ${currOutFolder}/*_MC_DC_Coreg_srt.nii.gz

  $ANTSPATH/ImageMath \
  4 \
  ${curr4dfun} \
  TimeSeriesAssemble \
  2.604 \
  0 \
  ${currOutFolder}/*_MC_DC_Coreg.nii.gz



done
end_tme=$(date +%s)
nettme=$(expr $end_tme - $start_tme)
echo " "
echo "-----> Combined Motion and Distortion Reslice estimation took in $(($nettme / 3600))h:$(($nettme % 3600 / 60))m:$(($nettme % 60))s."
echo " "
