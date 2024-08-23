#! /bin/bash

echo "check tSNR..."
echo "==========================================================="

subjID='sub-12'
session_id='ses-002'
Pth='/media/g/P04/Data/BIDS/'
fun_Pth=${Pth}${subjID}/${session_id}/func/
tSNRPth_ses02=${fun_Pth}tSNR/
mkdir ${tSNRPth_ses02}
mskPth_reg2fun=${fun_Pth}GLM/Anat_space/Masks/fun_vareas/
tSNR_roi=${tSNRPth_ses02}ROI/
mkdir ${tSNR_roi}
Vareas=("V1" \
"V2" \
"V3")
Hemis=("lh" "rh")
strPathOrig=$PWD
# Calculate tsnr througth various folder
for runid in $(seq 1 6); do
  cd /media/g/P04/Data/BIDS/${subjID}/ses-002/func/GLM/BI/
  echo BI_fun_0${runid}_MoCo_Dist_Corr_Coreg.nii.gz
  echo "========================================================="
  3dTstat \
  -prefix ${tSNRPth_ses02}${subjID}_BI_fun_0${runid}_tsnr_befr_glm.nii.gz \
  -cvarinv BI_fun_0${runid}_MoCo_Dist_Corr_Coreg.nii.gz

  echo ${tSNRPth_ses02}${subjID}_BI_fun_0${runid}_tsnr_filtered.nii.gz \
  echo "========================================================="
  cd /media/g/P04/Data/BIDS/${subjID}/ses-002/func/GLM/BI/BI_fun_0${runid}_MoCo_Dist_Corr_Coreg_3EV.feat
  3dTstat \
  -prefix ${tSNRPth_ses02}${subjID}_BI_fun_0${runid}_tsnr_filtered.nii.gz \
  -cvarinv filtered_func_data.nii.gz

  cd /media/g/P04/Data/BIDS/${subjID}/ses-002/func/GLM/BI/BI_fun_0${runid}_MoCo_Dist_Corr_Coreg_3EV.feat/stats/
  echo ${tSNRPth_ses02}${subjID}_BI_fun_0${runid}_tsnr_res.nii.gz \
  echo "=========================================================="
  3dTstat \
  -prefix ${tSNRPth_ses02}${subjID}_BI_fun_0${runid}_tsnr_res.nii.gz \
  -cvarinv res4d.nii.gz

  for hemi in ${Hemis[@]}; do

    for vid in ${Vareas[@]}; do

        echo ${tSNR_roi}${subjID}_${hemi}_${vid}_BI_fun_0${runid}_tsnr_befr_glm.nii.gz
        echo "===================================================================="
        fslmaths ${mskPth_reg2fun}${subjID}_${session_id}_${hemi}_${vid}_reg2run_msk.nii.gz \
        -mul ${tSNRPth_ses02}${subjID}_BI_fun_0${runid}_tsnr_befr_glm.nii.gz \
        ${tSNR_roi}${subjID}_${hemi}_${vid}_BI_fun_0${runid}_tsnr_befr_glm.nii.gz

        echo ${tSNR_roi}${subjID}_${hemi}_${vid}_BI_fun_0${runid}_tsnr_filtered.nii.gz
        echo "===================================================================="
        fslmaths ${mskPth_reg2fun}${subjID}_${session_id}_${hemi}_${vid}_reg2run_msk.nii.gz \
        -mul ${tSNRPth_ses02}${subjID}_BI_fun_0${runid}_tsnr_filtered.nii.gz \
        ${tSNR_roi}${subjID}_${hemi}_${vid}_BI_fun_0${runid}_tsnr_filtered.nii.gz


        echo ${tSNR_roi}${subjID}_${hemi}_${vid}_BI_fun_0${runid}_tsnr_res.nii.gz
        echo "===================================================================="
        fslmaths ${mskPth_reg2fun}${subjID}_${session_id}_${hemi}_${vid}_reg2run_msk.nii.gz \
        -mul ${tSNRPth_ses02}${subjID}_BI_fun_0${runid}_tsnr_res.nii.gz \
        ${tSNR_roi}${subjID}_${hemi}_${vid}_BI_fun_0${runid}_tsnr_res.nii.gz



    done

  done

done


# # Define masks
# # Go back to functional space
# cd ${mskPth_reg2fun}
# # Get all the pRF overlay results
# mskFiles=( $(ls | grep .nii.gz) )
# numMsk=${#mskFiles[@]}
# numMsk=$(($numMsk - 1))
# echo ${numMsk}
# # -----------------------------------------------------------------------------
# cd ${strPathOrig}
#
# for roiid in $(seq 0 $numMsk); do
#   echo ${mskFiles[${roiid}]}
#   interp=$(cut -d '_' -f 1,2,3,4 <<< ${mskFiles[${roiid}]})
#
# for runid in {1..6}; do
#
#   echo ${tSNRPth_ses02}sub-03_ses-002_task-BI_acq-EP3D_dir-RL_run-${runid}_echo-1_bold_tSNR.nii.gz
#   echo "=========================================================================================="
#   fslmaths ${tSNRPth_ses02}sub-03_ses-002_task-BI_acq-EP3D_dir-RL_run-${runid}_echo-1_bold_tSNR.nii.gz \
#   -mul ${mskPth_reg2fun}${mskFiles[${roiid}]} \
#   ${tSNR_roi}tSNR_${interp}.nii.gz
#
# done
# done
