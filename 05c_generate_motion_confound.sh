#! /bin/bash
# This is script is to generate motion confound txt file for FSL-GLM
start_tme=$(date +%s)

Pth='/media/g/P04/Data/BIDS/'
subject_id='sub-12'
export session_id=("ses-001" "ses-002")
export task=("pRF" "BI")
export run_number=(3 6)
numSes=${#session_id[@]}
numSes=$(($numSes - 1))
baseRun=1


for sesid in $(seq 0 ${numSes});
do
  echo $sesid

  currpth=${Pth}${subject_id}/${session_id[$sesid]}/func/
  echo $currpth
  mskImg=${currpth}${subject_id}_${session_id[$sesid]}_task-${task[$sesid]}_acq-EP3D_dir-RL_run-1_echo-1_bold_fixedMask_brain.nii.gz

  runnum=${run_number[$sesid]}
  for runid in $(eval echo "{$baseRun..$runnum}");
  do
    echo ${runid}

    fsl_motion_outliers \
    -v \
    --nomoco \
    --dvars \
    -i ${currpth}GLM/${task[$sesid]}/${task[$sesid]}_fun_0${runid}_MoCo_Dist_Corr_Coreg.nii.gz \
    -m ${mskImg} \
    -s ${currpth}GLM/${task[$sesid]}/${task[$sesid]}_fun_0${runid}_MoCo_Dist_Corr_Coreg_dvars.txt \
    -p ${currpth}GLM/${task[$sesid]}/${task[$sesid]}_fun_0${runid}_MoCo_Dist_Corr_Coreg_dvars.png \
    -o ${currpth}GLM/${task[$sesid]}/${task[$sesid]}_fun_0${runid}_MoCo_Dist_Corr_Coreg_dvars.txt


  done

done

end_tme=$(date +%s)
nettme=$(expr $end_tme - $start_tme)
echo " "
echo "-----> Transform antsRegistration mat files to FSL mat files took in $(($nettme / 3600))h:$(($nettme % 3600 / 60))m:$(($nettme % 60))s."
echo " "
