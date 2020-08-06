#! /bin/bash
################################################################################

# Run Motion correction for all runs
# 0h:9m:39s.
################################################################################
# Directory of sri's motion correction and distortion correction code
start_tme=$(date +%s)

Pth='/media/h/P04/Data/BIDS/'
subject_id='sub-02'
session_id='ses-001'
TR=2.604
pRF_prefix='sub-02_ses-001_task-pRF_acq-EP3D_dir-RL_run-'
fun_suffix='_echo-1_bold'

################################################################################
echo "Start the Reslice of Motion and distortion"
anat_Pth='/media/h/P04/Data/BIDS/sub-02/ses-001/anat/MPRAGE/sub-02/mri/nii/'
fixed_anat=${mskPth}brain_finalsurfs.nii.gz
trfPth='/media/h/P04/Data/BIDS/sub-02/ses-001/func/TRFs/'
prf_2_anat_trf=${trfPth}P04_sub-02_ses-001_prf_to_fs_0GenericAffine.mat
fun_Pth=${Pth}${subject_id}/${session_id}/func/
fixed_Image=${fun_Pth}sub-02_ses-001_task-pRF_acq-EP3D_dir-RL_run-1_echo-1_bold_fixed_dc_template0.nii.gz
fixed_Msk=${fun_Pth}sub-02_ses-001_task-pRF_acq-EP3D_dir-RL_run-1_echo-1_bold_fixedMask_brain.nii.gz

OutPth="${fun_Pth}GLM/pRF/"
mkdir ${OutPth}
dcmatTrf=${fun_Pth}sub-02_ses-001_task-pRF_acq-EP3D_dir-RL_run-1_echo-1_bold_fixed_dc_template0GenericAffine.mat
echo ${dcmatTrf}
dcwarp=${fun_Pth}sub-02_ses-001_task-pRF_acq-EP3D_dir-RL_run-1_echo-1_bold_fixed_dc_template0warp.nii.gz
echo ${dcwarp}

basevol=1000 # ANTs indexing

#for all the funs during the sessions
for runid in {1..4}
do

  echo "Resclicing pRF Run ${runid}  :  "
  echo ${pRF_prefix}${runid}${fun_suffix}
  echo " "
  currfmri=${fun_Pth}${pRF_prefix}${runid}${fun_suffix}
  currfun3d=${currfmri}_split/
  currfunmc=${currfmri}_mats/
  currOutFolder="${OutPth}run_0${runid}_subset/"
  mkdir ${currOutFolder}

  curr4dfun="${OutPth}pRF_fun_0${runid}_MoCo_Dist_Corr_anat_Coreg.nii.gz"
  curr4dfun_srt="${OutPth}pRF_fun_0${runid}_MoCo_Dist_Corr_anat_Coreg_srt.nii.gz"

  tmax=$($ANTSPATH/PrintHeader ${currfmri}.nii.gz | grep Dimens | cut -d ',' -f 4 | cut -d ']' -f 1)
  echo ${tmax}

  #different run has different volumes
  for volume in $(seq 1000 $((${tmax} - 1 + 1000)))
  do
    currIn=${currfun3d}${pRF_prefix}${runid}${fun_suffix}_${volume}.nii.gz
    echo "current 3d image is :"
    echo ${currIn}
    mocoTrf=${currfunmc}${pRF_prefix}${runid}${fun_suffix}_${volume}_0GenericAffine.mat
    echo "current motion matrix is : "
    echo ${mocoTrf}
    currOut01=${currOutFolder}fun_0${runid}_vol_${volume}_MC_DC_anat_Coreg.nii.gz
    currOut02=${currOutFolder}fun_0${runid}_vol_${volume}_MC_DC_anat_Coreg_srt.nii.gz

    $ANTSPATH/antsApplyTransforms \
    -d 3 \
    --float \
    -i ${currIn} \
    -r ${fixed_Image} \
    -o ${currOut01} \
    -n BSpline[4] \
    -t ${prf_2_anat_trf} \
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
  ${currOutFolder}/*_MC_DC_anat_Coreg_srt.nii.gz

  $ANTSPATH/ImageMath \
  4 \
  ${curr4dfun} \
  TimeSeriesAssemble \
  2.604 \
  0 \
  ${currOutFolder}/*_MC_DC_anat_Coreg.nii.gz



done
end_tme=$(date +%s)
nettme=$(expr $end_tme - $start_tme)
echo " "
echo "-----> Combined Motion and Distortion Reslice estimation took in $(($nettme / 3600))h:$(($nettme % 3600 / 60))m:$(($nettme % 60))s."
echo " "
