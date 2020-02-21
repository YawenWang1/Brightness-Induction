#!/bin/bash

################################################################################
##This script is to resort the mean images created before#######################
strDataPath="/media/h/P04/Data/S04/Ses01/02_Preprocessing/01_Func/"

#####Make a new folder for all the mean images
destPath="${strDataPath}02_fun_mean_images"
folders=("00_fun_se/gz" \
"01_fun_se_op")
#copy the mean image to the folder created
for folderid in {1..2}
do
  if ((${folderid} < 2))
  then
    folder_end="_subset"
    file_end="_template0.nii.gz"
  else
    folder_end="_op_subset"
    file_end="_ope_template0.nii.gz"
  fi
  for runid in {1..7}
  do
    currPath="${strDataPath}${folders[${folderid}-1]}/run_0${runid}${folder_end}"

    currfile="${currPath}/fun_0${runid}${file_end}"
    # echo ${currPath}
    # echo ${currfile}
    cp ${currfile} "${destPath}"
    rm -rf ${currPath}
  done
done
