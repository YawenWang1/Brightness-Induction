#!/bin/bash
### Create a concatenated linear and differomorphic distortion warp ############
# strDataPath="/media/h/P04/Data/S04/Ses01/03_GLM/04_ASpace/"
# 20190130
strDataPath="/media/h/P04/Data/S04/Ses01/03_GLM/03_pRF/"

##for functional runs###########################################################
mkdir ${OutPth}
# Current directory
strPathOrig=$PWD

################################################################################
#Define reference image and mask image
refImg="${strDataPath}brain_finalsurfs.nii.gz"

#Register functional runs to ana
# Current output folder
currOut01="${strDataPath}pRF_results_note2/"
mkdir ${currOut01}
# Motion correction matrix
# prf_results="/media/h/P04/Data/S04/Ses01/03_GLM/03_pRF/pRF_results_up_tst/"

prf_results="/media/h/P04/Data/S04/Ses01/03_GLM/03_pRF/pRF_results/"
# Mskfile="${strDataPath}brain_mask_occipital_lobe.nii.gz"
# prfmatTrf01="${strDataPath}pRF_0p4_To_brain_0GenericAffine.mat"
prfmatTrf01="${strDataPath}fun_07_0p8To_Ana_Brain_Msk.txt"
# cd ${prf_results}
# pRF_results_up_files=( $(ls | grep results_ | grep .nii.gz) )
#
# pRF_results_up_files=( $(ls | grep pRF_results_ | grep .nii.gz) )
# numpRF=${#pRF_results_up_files[@]}
#
# numpRF=$(($numpRF - 1))
#
# for idx01 in $(seq 0 $numpRF)
# do
#   #current input
#   currIn01="${prf_results}${pRF_results_up_files[idx01]}"
#   #current output
#   currout01="${currOut01}${pRF_results_up_files[idx01]}"
#   # Apply transform
#   $ANTSPATH/antsApplyTransforms \
#   -d 3 \
#   -- double \
#   -i ${currIn01} \
#   -r ${refImg} \
#   -o ${currout01} \
#   -n BSpline[4] \
#   -t ${prfmatTrf01} \
#   -v 1
#
# done
# cd ${strPathOrig}


# Register funtional runs to ana (Lum_UP condition)
# Current moving file
strDataPath01="/media/h/P04/Data/S04/Ses01/03_GLM/04_ASpace/"
#Define reference image and mask image
refImg="${strDataPath01}brain_finalsurfs.nii.gz"

currPthIn02="${strDataPath01}00_Lum_Up.gfeat/cope1.feat/stats/"
currPthOut02="${strDataPath01}00_Lum_Up/"
mkdir ${currPthOut02}
# Change directory to the glm results for luminance up condition
cd ${currPthIn02}

Up_results=( $(ls | grep .nii.gz) )
# # # Number of files in cope1.feat/stats/
numUp=${#Up_results[@]}
numUp=$(($numUp - 1))
cd ${strPathOrig}

# functional runs to anatomy
# #
# $ANTSPATH/antsRegistrationSyN.sh \
# -d 3 \
# -f brain_finalsurfs.nii.gz \
# -m fun_all_mean.nii.gz \
# -o P04_S03_fun_to_fs_ \
# -n 16 \
# -i P04_S03_fun_to_ana.txt \
# -t r \
# -x brain_mask_occipital_lobe.nii.gz \
# -p f \
# -j 1 \
# -e 42
#

# # Motion correction matrix
funmatTrf02="${strDataPath01}P04_S03_fun_to_fs_0GenericAffine.mat"

# # Apply transform
for fileid in $(seq 0 ${numUp})
do
  # Current registered .nii.gz
  currtmp=${currPthIn02}${Up_results[${fileid}]}
  # Current output
  currOuttmp="${currPthOut02}P04_S03_Ana_up_${Up_results[${fileid}]}"

  $ANTSPATH/antsApplyTransforms -d 3 \
  -i ${currtmp} \
  -o ${currOuttmp} \
  -n BSpline[4] \
  -r ${refImg} \
  -t ${funmatTrf02} \
  -v 1 \
  --float


done
# # Register stats for lum_Down
currPthIn03="${strDataPath01}01_Lum_Down.gfeat/cope2.feat/stats/"
currPthOut03="${strDataPath01}01_Lum_Down/"
mkdir ${currPthOut03}

cd ${currPthIn03}

Down_results=( $(ls | grep .nii.gz) )
# # # Number of files in cope1.feat/stats/
numDown=${#Down_results[@]}
numDown=$(($numDown - 1))
cd ${strPathOrig}

# Apply transform
for fileid in $(seq 0 ${numDown})
do
  # Current registered .nii.gz
  currtmp=${currPthIn03}${Down_results[${fileid}]}
  # Current output
  currOuttmp="${currPthOut03}P04_S03_Ana_down_${Down_results[${fileid}]}"
  $ANTSPATH/antsApplyTransforms \
  -d 3 \
  -i ${currtmp} \
  -o ${currOuttmp} \
  -n BSpline[4] \
  -r ${refImg} \
  -t ${funmatTrf02} \
  -v 1 \
  --float


done

# Register stats for contrast
currPthIn04="${strDataPath01}03_LumUp_Sub_Lum_Down.gfeat/cope1.feat/stats/"
currPthOut04="${strDataPath01}04_up_sub_down/"
mkdir ${currPthOut04}


cd ${currPthIn04}

Ctr_results=( $(ls | grep .nii.gz) )
# # # Number of files in cope1.feat/stats/
numCtr=${#Ctr_results[@]}
numCtr=$(($numCtr - 1))
cd ${strPathOrig}



# Apply transform
for fileid in $(seq 0 ${numCtr})
do
  # Current registered .nii.gz
  currtmp=${currPthIn04}${Ctr_results[${fileid}]}
  # Current output
  currOuttmp="${currPthOut04}P04_S03_Ana_up_sub_down_${Ctr_results[${fileid}]}"
  $ANTSPATH/antsApplyTransforms \
  -d 3 \
  -i ${currtmp} \
  -o ${currOuttmp} \
  -n BSpline[4] \
  -r ${refImg} \
  -t ${funmatTrf02} \
  -v 1 \
  --float

done
