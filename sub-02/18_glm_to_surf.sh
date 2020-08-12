#! /bin/bash
# Apply transformation for results from pyprf took in 0h:0m:48s.

start_tme=$(date +%s)
export SUBJECTS_DIR=/media/h/P04/Data/BIDS/sub-02/ses-002/anat
export stats_array=(1 "zstat1" "tstat1" "cope1" "pe1" "varcope1" "weights1")

subjID='sub-02'

# Define all the pRF files
glmPth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/BI/02_Ctr.gfeat/cope6.feat/stats/'
optPth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/Anat_space/02_Ctr/'
surfoptPth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/Anat_space/02_Ctr/In_surface/'

anatPth='/media/h/P04/Data/BIDS/sub-02/ses-002/anat/sub-02/mri/nii/'
trfPth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/TRFs/'

mkdir ${optPth}
mkdir ${surfoptPth}

for i in {1..6}; do

$ANTSPATH/antsApplyTransforms -d 3 \
-i ${glmPth}${stats_array[${i}]}.nii.gz \
-o ${optPth}ctr_${stats_array[${i}]}_reg2fsanat.nii.gz \
-n BSpline[4] \
-r ${anatPth}brain_finalsurfs.nii.gz \
-t ${trfPth}sub-02_ses-002_fun_to_fs_0GenericAffine.mat -v
done

strPathOrig=$PWD
# -----------------------------------------------------------------------------
# Get all the pRF OC ROI
cd ${optPth}
# Get all the pRF overlay results
glm_results=( $(ls | grep .nii.gz) )
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


glmPth01='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/BI/01_Lum_Down.gfeat/cope2.feat/stats/'
optPth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/Anat_space/01_Lum_Down/'
mkdir ${optPth}
surfoptPth=${optPth}In_surface/
mkdir ${surfoptPth}

for i in {1..6}; do

$ANTSPATH/antsApplyTransforms -d 3 \
-i ${glmPth01}${stats_array[${i}]}.nii.gz \
-o ${optPth}down_${stats_array[${i}]}_reg2fsanat.nii.gz \
-n BSpline[4] \
-r ${anatPth}brain_finalsurfs.nii.gz \
-t ${trfPth}sub-02_ses-002_fun_to_fs_0GenericAffine.mat -v
done

# Get all the pRF OC ROI
cd ${optPth}
# Get all the pRF overlay results
glm_results=( $(ls | grep .nii.gz) )
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



glmPth01='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/BI/00_Lum_Up.gfeat/cope1.feat/stats/'
optPth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/Anat_space/00_Lum_Up/'
mkdir ${optPth}
surfoptPth=${optPth}In_surface/
mkdir ${surfoptPth}

for i in {1..6}; do

$ANTSPATH/antsApplyTransforms -d 3 \
-i ${glmPth01}${stats_array[${i}]}.nii.gz \
-o ${optPth}up_${stats_array[${i}]}_reg2fsanat.nii.gz \
-n BSpline[4] \
-r ${anatPth}brain_finalsurfs.nii.gz \
-t ${trfPth}sub-02_ses-002_fun_to_fs_0GenericAffine.mat -v
done

# Get all the pRF OC ROI
cd ${optPth}
# Get all the pRF overlay results
glm_results=( $(ls | grep .nii.gz) )
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


glmPth01='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/BI/03_inter_tar_up.gfeat/cope4.feat/stats/'
optPth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/Anat_space/03_inter_tar_up/'
mkdir ${optPth}
surfoptPth=${optPth}In_surface/
mkdir ${surfoptPth}

for i in {1..6}; do

$ANTSPATH/antsApplyTransforms -d 3 \
-i ${glmPth01}${stats_array[${i}]}.nii.gz \
-o ${optPth}up_tar_inter_${stats_array[${i}]}_reg2fsanat.nii.gz \
-n BSpline[4] \
-r ${anatPth}brain_finalsurfs.nii.gz \
-t ${trfPth}sub-02_ses-002_fun_to_fs_0GenericAffine.mat -v
done

# Get all the pRF OC ROI
cd ${optPth}
# Get all the pRF overlay results
glm_results=( $(ls | grep .nii.gz) )
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

glmPth01='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/BI/04_inter_tar_down.gfeat/cope5.feat/stats/'
optPth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/Anat_space/04_inter_tar_down/'
mkdir ${optPth}
surfoptPth=${optPth}In_surface/
mkdir ${surfoptPth}

for i in {1..6}; do

$ANTSPATH/antsApplyTransforms -d 3 \
-i ${glmPth01}${stats_array[${i}]}.nii.gz \
-o ${optPth}down_tar_inter_${stats_array[${i}]}_reg2fsanat.nii.gz \
-n BSpline[4] \
-r ${anatPth}brain_finalsurfs.nii.gz \
-t ${trfPth}sub-02_ses-002_fun_to_fs_0GenericAffine.mat -v
done

# Get all the pRF OC ROI
cd ${optPth}
# Get all the pRF overlay results
glm_results=( $(ls | grep .nii.gz) )
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



glmPth01='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/BI/05_target.gfeat/cope3.feat/stats/'
optPth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/Anat_space/05_target/'
mkdir ${optPth}
surfoptPth=${optPth}In_surface/
mkdir ${surfoptPth}

for i in {1..6}; do

$ANTSPATH/antsApplyTransforms -d 3 \
-i ${glmPth01}${stats_array[${i}]}.nii.gz \
-o ${optPth}tar_${stats_array[${i}]}_reg2fsanat.nii.gz \
-n BSpline[4] \
-r ${anatPth}brain_finalsurfs.nii.gz \
-t ${trfPth}sub-02_ses-002_fun_to_fs_0GenericAffine.mat -v
done

# Get all the pRF OC ROI
cd ${optPth}
# Get all the pRF overlay results
glm_results=( $(ls | grep .nii.gz) )
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




end_tme=$(date +%s)
nettme=$(expr $end_tme - $start_tme)
echo " "
echo "-----> Transform func results to surface took in $(($nettme / 3600))h:$(($nettme % 3600 / 60))m:$(($nettme % 60))s."
echo " "

#
# # Look at the data from freeview
# # freeview -f $SUBJECTS_DIR/S04/surf/lh.inflated:overlay=./results_227vols_polar_angle_reg2anat_lh.nii.gz:label=/media/h/P04/Data/S04/Ses01/03_GLM/00_Ana/S04/label/lh.benson14atlas.V1.label:label=/media/h/P04/Data/S04/Ses01/03_GLM/00_Ana/S04/label/lh.benson14atlas.V2.label
