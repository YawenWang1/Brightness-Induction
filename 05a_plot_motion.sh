#! /bin/bash
start_tme=$(date +%s)

Pth='/media/g/P04/Data/BIDS/'
subject_id='sub-12'
export session_id=("ses-001" "ses-002")
export task=("pRF" "BI")
export run_number=(3 6)
numSes=${#session_id[@]}
numSes=$(($numSes - 1))
baseRun=1
################################################################################
for sesid in $(seq 0 ${numSes});
do
  echo $sesid

  currpth=${Pth}${subject_id}/${session_id[$sesid]}/func/
  echo $currpth
  refImg=${currpth}${subject_id}_${session_id[$sesid]}_task-${task[$sesid]}_acq-EP3D_dir-RL_run-1_echo-1_bold_fixed.nii.gz
  tmpRun=${currpth}${subject_id}_${session_id[$sesid]}_task-${task[$sesid]}_acq-EP3D_dir-RL_run-1_echo-1_bold.nii.gz
  echo $tmpRun

  tmax=$($ANTSPATH/PrintHeader ${tmpRun} | grep Dimens | cut -d ',' -f 4 | cut -d ']' -f 1)
  echo $tmax
  runnum=${run_number[$sesid]}
  for runid in $(eval echo "{$baseRun..$runnum}");
  do
    echo ${runid}

    matfldr=${currpth}${subject_id}_${session_id[$sesid]}_task-${task[$sesid]}_acq-EP3D_dir-RL_run-${runid}_echo-1_bold_mats
    volfldr=${currpth}${subject_id}_${session_id[$sesid]}_task-${task[$sesid]}_acq-EP3D_dir-RL_run-${runid}_echo-1_bold_split
    for vomid in $(seq 1000 $((${tmax} - 1 + 1000)));
    do

      stem=${subject_id}_${session_id[$sesid]}_task-${task[$sesid]}_acq-EP3D_dir-RL_run-${runid}_echo-1_bold_
      echo "Convert antsRegistration mat file to ITK mat file"
      echo "=================================================================="
      echo ""
      ConvertTransformFile \
      3 \
      ${matfldr}/${stem}${vomid}_0GenericAffine.mat \
      ${matfldr}/vol_${vomid}_af.mat \
      --convertToAffineType
      echo "Convert to FSL mat file"
      echo "=================================================================="
      echo ""
      c3d_affine_tool \
      -ref ${refImg} \
      -src ${volfldr}/${stem}${vomid}.nii.gz \
      -itk ${matfldr}/vol_${vomid}_af.mat -ras2fsl \
      -o ${matfldr}/3d_vol_${vomid}_FSL.mat \
      -info-full

    done
  done

done

end_tme=$(date +%s)
nettme=$(expr $end_tme - $start_tme)
echo " "
echo "-----> Transform antsRegistration mat files to FSL mat files took in $(($nettme / 3600))h:$(($nettme % 3600 / 60))m:$(($nettme % 60))s."
echo " "
