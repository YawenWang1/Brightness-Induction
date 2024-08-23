#! /bin/bash
# Apply transformation for results from pyprf took in 0h:0m:48s.

start_tme=$(date +%s)

# Define all the pRF files
subjID='sub-12'
funPth='/media/g/P04/Data/BIDS/sub-12/ses-002/func/GLM/BI/'
optPth='/media/g/P04/Data/BIDS/sub-12/ses-002/func/GLM/Anat_space/GLM_results/'
surfoptPth='/media/g/P04/Data/BIDS/sub-12/ses-002/func/GLM/Anat_space/GLM_results/In_surface/'
anatPth='/media/g/P04/Data/BIDS/sub-12/ses-002/anat/fs/sub-12/mri/nii/'
trfPth='/media/g/P04/Data/BIDS/sub-12/ses-002/func/TRFs/'
lstCondPth=(1 "00_lum_up_3EV.gfeat/cope1.feat/stats/" \
"01_Lum_down_3EV.gfeat/cope2.feat/stats/" \
"02_Tar_3EV.gfeat/cope3.feat/stats/" \
"03_Ctr_3EV.gfeat/cope4.feat/stats/")
lstCondNme=(1 "00_lum_up_" \
"01_Lum_down_" \
"02_Tar_" \
"03_Ctr_")
export SUBJECTS_DIR=/media/g/P04/Data/BIDS/sub-12/ses-002/anat/fs/
export stats_array=(1 "zstat1" "tstat1" "cope1" "pe1" "varcope1" "weights1")

# Make new directory
mkdir ${optPth}
mkdir ${surfoptPth}
for conid in {1..4}; do
  for i in {1..6}; do

  $ANTSPATH/antsApplyTransforms -d 3 \
  -i ${funPth}${lstCondPth[$conid]}${stats_array[${i}]}.nii.gz \
  -o ${optPth}${lstCondNme[$conid]}${stats_array[${i}]}_reg2fsanat.nii.gz \
  -n LanczosWindowedSinc \
  -r ${anatPth}brain.finalsurfs.nii.gz \
  -t ${trfPth}sub-12_ses-002_fun_to_anat_0GenericAffine.mat -v
  done

  strPathOrig=$PWD
  # -----------------------------------------------------------------------------
  # Get all the pRF OC ROI
  cd ${optPth}
  # Get all the pRF overlay results
  glm_results=( $(ls | grep ${lstCondNme[$conid]} |grep .nii.gz) )
  numGLMs=${#glm_results[@]}
  numGLMs=$(($numGLMs - 1))
  echo ${numGLMs}
  # -----------------------------------------------------------------------------
  cd ${strPathOrig}


  for hemi in {"lh","rh"}; do
  for i in $(seq 0 $numGLMs); do

    # Get rid of .nii.gz
    interp=$(cut -d '.' -f 1 <<< ${glm_results[${i}]})
    mri_vol2surf \
    --mov ${optPth}${glm_results[${i}]} \
    --regheader ${subjID} \
    --hemi ${hemi} \
    --o ${surfoptPth}${interp}_${hemi}.nii.gz \
    --interp nearest
  done
  done
done


end_tme=$(date +%s)
nettme=$(expr $end_tme - $start_tme)
echo " "
echo "-----> Transform func results to surface took in $(($nettme / 3600))h:$(($nettme % 3600 / 60))m:$(($nettme % 60))s."
echo " "

#
# # Look at the data from freeview
# # freeview -f $SUBJECTS_DIR/S04/surf/lh.inflated:overlay=./results_227vols_polar_angle_reg2anat_lh.nii.gz:label=/media/g/P04/Data/S04/Ses01/03_GLM/00_Ana/S04/label/lh.benson14atlas.V1.label:label=/media/g/P04/Data/S04/Ses01/03_GLM/00_Ana/S04/label/lh.benson14atlas.V2.label
