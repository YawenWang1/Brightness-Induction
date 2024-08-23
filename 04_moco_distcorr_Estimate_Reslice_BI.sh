#! /bin/bash
################################################################################

# Run Motion correction for BI runs
#  4h:0m:58s.
################################################################################
# Directory of sri's motion correction and distortion correction code
start_tme=$(date +%s)

################################################################################
# Simple formatting
# Start bold text
bold=$(tput bold)
# Turn off all attributes
normal=$(tput sgr0)

################################################################################


Pth='/media/g/P04/Data/BIDS/'
subject_id='sub-12'
session_id='ses-002'
TR=2.604
ope_Pth=${Pth}${subject_id}/${session_id}/func/func_ope/
ope_Image=sub-12_ses-002_task-BI_acq-EP3D_dir-LR_run-1_echo-1_bold

################################################################################
#            Create a Mask and fixed functional Image first                    #
# START MOTION CORRECTION ON FIRST 5 VOLS
FixRunID=1
fun_Pth=${Pth}${subject_id}/${session_id}/func/
BI_prefix='sub-12_ses-002_task-BI_acq-EP3D_dir-RL_run-'
fun_suffix='_echo-1_bold'
fun_roi_suffix='_echo-1_bold_roi'
suffix='.nii.gz'
FixedFun=${BI_prefix}${FixRunID}${fun_suffix}
FixedFun_roi=${BI_prefix}${FixRunID}${fun_roi_suffix}
# Get the dimension of BI run at [x,y,z]
xmax=$($ANTSPATH/PrintHeader ${fun_Pth}${FixedFun}.nii.gz | grep Dimens | cut -d '[' -f 2 | cut -d ',' -f 1 | cut -d ']' -f 1)
echo ${xmax}
ymax=$($ANTSPATH/PrintHeader ${fun_Pth}${FixedFun}.nii.gz | grep Dimens | cut -d ',' -f 2 | cut -d ']' -f 1)
echo ${ymax}
zmax=$($ANTSPATH/PrintHeader ${fun_Pth}${FixedFun}.nii.gz | grep Dimens | cut -d ',' -f 3 | cut -d ']' -f 1)
echo ${zmax}
tmax=$($ANTSPATH/PrintHeader ${fun_Pth}${FixedFun}.nii.gz | grep Dimens | cut -d ',' -f 4 | cut -d ']' -f 1)
echo ${tmax}
# # # Define some parameters
basevol=1000 # ANTs indexing
fromvol=$(($basevol + 1))
nthvol=$(($basevol + 4)) # Zero indexing
################################################################################
# Motion Estimation for ope data
echo "Motion Estimation for ope data "
ope_split=${ope_Pth}${ope_Image}_split
ope_moco=${ope_Pth}${ope_Image}_moco_out
ope_mats=${ope_Pth}${ope_Image}_mats

echo "Making folder $ope_split "
mkdir $ope_split

echo "Making folder $ope_moco "
mkdir $ope_moco

echo "Making folder $ope_mats "
mkdir $ope_mats

echo "-----> Temporary directories were created."
echo " "

n_vols_ope=$($ANTSPATH/PrintHeader ${ope_Pth}${ope_Image}.nii.gz | grep Dimens | cut -d ',' -f 4 | cut -d ']' -f 1)

#-------------------------------------------------------------------------------
# DISASSEMBLE OPPOSITE PHASE-ENCODING DATA
$ANTSPATH/ImageMath \
4 \
${ope_split}/${ope_Image}_.nii.gz \
TimeSeriesDisassemble \
${ope_Pth}${ope_Image}.nii.gz

echo "-----> Opposite phase data was disassembled into its ${bold} $n_vols_ope ${normal} constituent volumes."
echo " "
#
# ################################################################################
# # START MOTION CORRECTION ON OPPOSITE PHASE-ENCODING DATA
#
basevol=1000 # ANTs indexing
fromvol=$(($basevol + 1))
nthvol=$(($basevol + $n_vols_ope - 1)) # Zero indexing

echo "-----> Starting motion correction on opposite phase-encoding data."
echo " "

start_tme=$(date +%s)

for volume in $(eval echo "{$fromvol..$nthvol}"); do

    echo -ne "--------------------> Registering $volume"\\r

    FIXED=${ope_split}/${ope_Image}_${basevol}.nii.gz
    MOVING=${ope_split}/${ope_Image}_${volume}.nii.gz
    OUTPUT=${ope_moco}/${ope_Image}_${volume}

    $ANTSPATH/antsRegistration \
    --verbose 0 \
    --float 1 \
    --dimensionality 3 \
    --use-histogram-matching 1 \
    --interpolation BSpline[4] \
    --collapse-output-transforms 1 \
    --output [ ${OUTPUT}_ , ${OUTPUT}_Warped.nii.gz , 1 ] \
    --winsorize-image-intensities [ 0.005 , 0.995 ] \
    --initial-moving-transform [ $FIXED , $MOVING , 1 ] \
    --transform Rigid[0.1] \
    --metric MI[ $FIXED , $MOVING , 1 , 32 , Regular , 0.25] \
    --convergence [ 1000x500x250 , 1e-6 , 10 ] \
    --shrink-factors 4x2x1 \
    --smoothing-sigmas 2x1x0vox \
    --transform Affine[0.1] \
    --metric MI[ $FIXED , $MOVING , 1 , 32 , Regular , 0.25] \
    --convergence [ 500x250x100 , 1e-6 , 10 ] \
    --shrink-factors 4x2x1 \
    --smoothing-sigmas 2x1x0vox

done


echo " "

$ANTSPATH/ImageMath \
4 \
${ope_Pth}/${ope_Image}_MoCorr.nii.gz \
TimeSeriesAssemble \
$TR \
0 \
${ope_split}/${ope_Image}_${basevol}.nii.gz $ope_moco/*_Warped.nii.gz

$ANTSPATH/AverageImages \
3 \
${ope_Pth}/${ope_Image}_MoCorr_meanTemplate.nii.gz \
2 \
${ope_split}/${ope_Image}_${basevol}.nii.gz \
$ope_moco/*_Warped.nii.gz

echo "-----> Created motion corrected mean template."
echo " "

rm -rf $ope_moco
rm -rf $ope_mats
rm -rf $ope_split

echo "-----> Temporary files cleaned up."
echo " "
###############################################################################
Start Estimating all the functional runs
 Estimation for all the runs #################################################
###############################################################################
echo "Start the Estimation of Motion and distortion"

fixed_Image=${BI_prefix}${FixRunID}${fun_suffix}_fixed.nii.gz
fixed_Msk=${BI_prefix}${FixRunID}_echo-1_bold_fixedMask_brain

#-------------------------------------------------------------------------------

nthvol=$(($basevol + $tmax - 1)) # Zero indexing


for runid in {1..6}
do
  echo "-----> Starting motion correction on functional data."
  echo " "

  echo "Estimating Run ${runid}  :  "

  # CREATE TEMPORARY DIRECTORIES

  #data_prefix=sub${subject_id}_${modality}_run${run_number}
  data_split=${fun_Pth}${BI_prefix}${runid}${fun_suffix}_split
  data_moco=${fun_Pth}${BI_prefix}${runid}${fun_suffix}_moco
  data_mats=${fun_Pth}${BI_prefix}${runid}${fun_suffix}_mats

  echo "Making folder $data_split "
  mkdir $data_split

  echo "Making folder $data_moco "
  mkdir $data_moco

  echo "Making folder $data_mats "
  mkdir $data_mats

  echo "-----> Temporary directories were created."
  echo " "

  echo "${fun_Pth}${BI_prefix}${runid}${fun_suffix}.nii.gz"
  echo " "

  echo "DISASSEMBLE Run $runid"
  echo " "

  $ANTSPATH/ImageMath \
  4 \
  ${data_split}/${BI_prefix}${runid}${fun_suffix}_.nii.gz \
  TimeSeriesDisassemble \
  ${fun_Pth}${BI_prefix}${runid}${fun_suffix}.nii.gz

  echo "-----> 4D data was disassembled into its ${bold} $tmax ${normal} constituent volumes."
  echo " "

  for volume in {1000..1257}; do

      echo -ne "--------------------> Registering ${volume}"\\r

      FIXED=$fun_Pth${fixed_Image}

      MOVING=${data_split}/${BI_prefix}${runid}${fun_suffix}_${volume}.nii.gz
      echo $MOVING
      MASK=$fun_Pth${fixed_Msk}.nii.gz

      OUTPUT=${data_moco}/${BI_prefix}${runid}${fun_suffix}_${volume}

      $ANTSPATH/antsRegistration \
      --verbose 0 \
      --float 1 \
      --dimensionality 3 \
      --random-seed 42 \
      --use-histogram-matching 1 \
      --interpolation BSpline[4] \
      --collapse-output-transforms 1 \
      --output [ ${OUTPUT}_ , ${OUTPUT}_Warped.nii.gz , 1 ] \
      --winsorize-image-intensities [ 0.005 , 0.995 ] \
      --masks [ $MASK , 1 ] \
      --initial-moving-transform [ $FIXED , $MOVING , 1 ] \
      --transform Rigid[0.1] \
      --metric MI[ $FIXED , $MOVING , 1 , 32 , Regular , 0.25] \
      --convergence [ 1000x500x250 , 1e-6 , 10 ] \
      --shrink-factors 4x2x1 \
      --smoothing-sigmas 2x1x0vox \
      --transform Affine[0.1] \
      --metric MI[ $FIXED , $MOVING , 1 , 32 , Regular , 0.25 ] \
      --convergence [ 500x250x100 , 1e-6 , 10 ] \
      --shrink-factors 4x2x1 \
      --smoothing-sigmas 2x1x0vox


      fslmaths \
      ${data_moco}/${BI_prefix}${runid}${fun_suffix}_${volume}_Warped.nii.gz \
      ${data_moco}/${BI_prefix}${runid}${fun_suffix}_${volume}_Warped_srt.nii.gz \
      -odt short


  done

  $ANTSPATH/ImageMath \
  4 \
  $fun_Pth${BI_prefix}${runid}${fun_suffix}_MoCorr.nii.gz \
  TimeSeriesAssemble \
  $TR \
  0 \
  $data_moco/*_Warped.nii.gz


  $ANTSPATH/ImageMath \
  4 \
  $fun_Pth${BI_prefix}${runid}${fun_suffix}_MoCorr_srt.nii.gz \
  TimeSeriesAssemble \
  $TR \
  0 \
  $data_moco/*_Warped_srt.nii.gz


  $ANTSPATH/AverageImages \
  3 \
  $fun_Pth${BI_prefix}${runid}${fun_suffix}_MoCorr_meanTemplate.nii.gz \
  2 \
  $data_moco/*_Warped.nii.gz

  $ANTSPATH/AverageImages \
  3 \
  $fun_Pth${BI_prefix}${runid}${fun_suffix}_MoCorr_srt_meanTemplate.nii.gz \
  2 \
  $data_moco/*_Warped_srt.nii.gz


  echo "-----> Created motion corrected mean template for distortion correction."
  echo " "
  echo "Copy all the mat files from data_moco to data_mat"
  cp -r ${data_moco}/*.mat ${data_mats}/
  rm -rf $data_moco

  echo "-----> Temporary files cleaned up."
  echo " "

  echo "Run ${runid} estimated is finished"

done


# ################################################################################
# # REGISTER THE OPPOSITE PE TEMPLATE TO THE FUNCTIONAL TEMPLATE - RIGID ONLY
FIXED=${fun_Pth}sub-12_ses-002_task-BI_acq-EP3D_dir-RL_run-1_echo-1_bold_fixed.nii.gz
MASK=${fun_Pth}sub-12_ses-002_task-BI_acq-EP3D_dir-RL_run-1_echo-1_bold_fixedMask_brain.nii.gz
MOVING=${ope_Pth}sub-12_ses-002_task-BI_acq-EP3D_dir-LR_run-1_echo-1_bold_MoCorr_meanTemplate.nii.gz
OUTPUT=${fun_Pth}sub-12_ses-002_task-BI_acq-EP3D_dir-LR_run-1_MoCorr_meanTemplate_T0_RL_Fixed_reg2func
OUTPUT_dc=${fun_Pth}sub-12_ses-002_task-BI_acq-EP3D_dir-RL_run-1_echo-1_bold_fixed_dc_

echo ${FIXED}
echo ${MASK}
echo ${MOVING}
echo ${OUTPUT}


$ANTSPATH/antsRegistration --verbose 1 \
-x [ ${MASK}, 1 ] \
--random-seed 42 --dimensionality 3 --float 1 \
--collapse-output-transforms 1 \
--output [ ${OUTPUT}_,${OUTPUT}_Warped.nii.gz,1 ] \
--interpolation BSpline[4] \
--use-histogram-matching 1 \
--winsorize-image-intensities [ 0.005,0.995 ] \
--initial-moving-transform [ ${FIXED},${MOVING},1 ] --transform Rigid[ 0.1 ] \
--metric MI[ ${FIXED},${MOVING},1,32,Regular,0.25 ] \
--convergence [ 250x100,1e-6,10 ] --shrink-factors 2x1 --smoothing-sigmas 1x0vox


$ANTSPATH/antsMultivariateTemplateConstruction2.sh \
-d 3 \
-i 4 \
-k 1 \
-f 4x2x1 \
-s 2x1x0vox \
-q 30x20x4 \
-t SyN \
-m CC \
-c 2 \
-j 16 \
-o ${OUTPUT_dc} \
${FIXED} \
${OUTPUT}_Warped.nii.gz


echo "-----> Registered Opposite PE template to the functional template."
printf "\n\n"
end_tme=$(date +%s)
nettme=$(expr $end_tme - $start_tme)
echo "-----> Combined Motion and Distortion estimation took in $(($nettme / 3600))h:$(($nettme % 3600 / 60))m:$(($nettme % 60))s."
echo " "
echo "=========================================================================="
start_tme=$(date +%s)
echo "Start the Reslice of Motion and distortion for BI functional runs"
fixed_Image=${fun_Pth}sub-12_ses-002_task-BI_acq-EP3D_dir-RL_run-1_echo-1_bold_fixed_dc_template0.nii.gz
fixed_Msk=${fun_Pth}sub-12_ses-002_task-BI_acq-EP3D_dir-RL_run-1_echo-1_bold_fixedMask_brain.nii.gz
mkdir ${fun_Pth}GLM/
OutPth="${fun_Pth}GLM/BI/"
mkdir ${OutPth}
dcmatTrf=${fun_Pth}sub-12_ses-002_task-BI_acq-EP3D_dir-RL_run-1_echo-1_bold_fixed_dc_template0GenericAffine.mat
echo ${dcmatTrf}
dcwarp=${fun_Pth}sub-12_ses-002_task-BI_acq-EP3D_dir-RL_run-1_echo-1_bold_fixed_dc_template0warp.nii.gz
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
