#!/bin/bash

################################################################################
##This script is to create mean image for each run #############################

strDataPath="/media/h/P04/Data/S04/Ses01/02_Preprocessing/01_Func/"
#for all the opposite - phase encoding runs
strFolders=(
            ${strDataPath}01_fun_se_op \
            )

for folderid in {1..1}
do
  currfolder=${strFolders[folderid-1]}
  for runid in {1..7}
  do
    # tempfolder=${currfolder}/run_0${runid}_subset
    tempfolder=${currfolder}/run_0${runid}_op_subset
    mkdir ${tempfolder}
    $ANTSPATH/ImageMath \
    4 \
    ${tempfolder}/fun_0${runid}_vol_.nii.gz \
    TimeSeriesDisassemble \
    ${currfolder}/fun_0${runid}_ope.nii.gz

    $ANTSPATH/antsMultivariateTemplateConstruction2.sh \
    -d 3 \
    -i 2 \
    -k 1 \
    -f 4x2x1 \
    -s 2x1x0vox \
    -q 30x20x4 \
    -t Affine \
    -m MI \
    -c 2 \
    -j 16 \
    -n 0 \
    -r 1 \
    -o ${tempfolder}/fun_0${runid}_ope_ ${tempfolder}/*.nii.gz
  done
done


# For all the functional runs################################
strFolders=(
            ${strDataPath}00_fun_se/gz \
            )

for folderid in {1..1}
do
  currfolder=${strFolders[folderid-1]}
  for runid in {1..7}
  do
    #tempfolder=${currfolder}/run_0${runid}_subset
    tempfolder=${currfolder}/run_0${runid}_subset
    mkdir ${tempfolder}
    $ANTSPATH/ImageMath \
    4 \
    ${tempfolder}/fun_0${runid}_vol_.nii.gz \
    TimeSeriesSubset \
    ${currfolder}/fun_0${runid}.nii.gz \
    5 \

    $ANTSPATH/antsMultivariateTemplateConstruction2.sh \
    -d 3 \
    -i 2 \
    -k 1 \
    -f 4x2x1 \
    -s 2x1x0vox \
    -q 30x20x4 \
    -t Affine \
    -m MI \
    -c 2 \
    -j 16 \
    -n 0 \
    -r 1 \
    -o ${tempfolder}/fun_0${runid}_ ${tempfolder}/*.nii.gz
  done
done
