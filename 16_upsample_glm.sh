#!/bin/bash


###############################################################################
# Upsample pRF results.                                                       #
###############################################################################


# -----------------------------------------------------------------------------
# *** Define parameters

# Input directory:
# strPthIn="/media/h/P04/Data/S04/Ses01/03_GLM/04_ASpace/04_up_sub_down/"
strPthIn="/media/h/P04/Data/S04/Ses01/03_GLM/04_ASpace/01_Lum_Down/"
# Output directory:
# strPthOut="/media/h/P04/Data/S04/Ses01/03_GLM/04_ASpace/04_up_sub_down_up/"
strPthOut="/media/h/P04/Data/S04/Ses01/03_GLM/04_ASpace/05_0p4/01_Lum_Down/"

mkdir ${strPthOut}
# Upsampling factor (e.g. 0.5 for half the previous voxel size, 0.25 for a
# quater of the previous voxel size):
varUpFac=0.4
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# *** Upsample images

echo "-Upsampling of glm results"

# Save original path in order to cd back to this path in the end:
# strPathOrig=( $(pwd) )
strPathOrig=$PWD

# cd into target directory and create list of images to be processed, only
# taking into account compressed nii files containing pRF results:
cd "${strPthIn}"
aryIn=( $(ls | grep .nii.gz) )


# Check number of files to be processed:
varNumIn=${#aryIn[@]}

# Since indexing starts from zero, we subtract one:
varNumIn=$((varNumIn - 1))

for idx01 in $(seq 0 $varNumIn)
do
	# Define temporary path of current input image:
	strTmpIn="${strPthIn}${aryIn[idx01]}"

	# Define temporary path of current output image:
	strTmpOut="${strPthOut}${aryIn[idx01]}"

	echo "--------------------------------------------------------------------"
	echo "------Processing ${aryIn[idx01]}"
	date

	# Run Upsampling
	$ANTSPATH/ResampleImage \
	3 \
	${strTmpIn} \
	${strTmpOut} \
	${varUpFac}x${varUpFac}x${varUpFac} \
	0 \
	6

done

# cd back to original directory:
cd "${strPathOrig}"
# -----------------------------------------------------------------------------


#
# # Input directory:
# # strPthIn="/media/h/P04/Data/S04/Ses01/03_GLM/04_ASpace/04_up_sub_down/"
# strPthIn01="/media/h/P04/Data/S04/Ses01/03_GLM/04_ASpace/00_Lum_Up/"
# # Output directory:
# # strPthOut="/media/h/P04/Data/S04/Ses01/03_GLM/04_ASpace/04_up_sub_down_up/"
# strPthOut01="/media/h/P04/Data/S04/Ses01/03_GLM/04_ASpace/05_0p4/00_Lum_Up/"
#
# mkdir ${strPthOut01}
# # Upsampling factor (e.g. 0.5 for half the previous voxel size, 0.25 for a
# # quater of the previous voxel size):
# varUpFac=0.4
# # -----------------------------------------------------------------------------
#
#
# # -----------------------------------------------------------------------------
# # *** Upsample images
#
# echo "-Upsampling of glm results"
#
# # cd into target directory and create list of images to be processed, only
# # taking into account compressed nii files containing pRF results:
# cd "${strPthIn01}"
# aryIn01=( $(ls | grep .nii.gz) )
#
#
# # Check number of files to be processed:
# varNumIn=${#aryIn01[@]}
#
# # Since indexing starts from zero, we subtract one:
# varNumIn=$((varNumIn - 1))
#
# for idx01 in $(seq 0 $varNumIn)
# do
# 	# Define temporary path of current input image:
# 	strTmpIn01="${strPthIn01}${aryIn01[idx01]}"
#
# 	# Define temporary path of current output image:
# 	strTmpOut01="${strPthOut01}${aryIn01[idx01]}"
#
# 	echo "--------------------------------------------------------------------"
# 	echo "------Processing ${aryIn01[idx01]}"
# 	date
#
# 	# Run Upsampling
# 	$ANTSPATH/ResampleImage \
# 	3 \
# 	${strTmpIn01} \
# 	${strTmpOut01} \
# 	${varUpFac}x${varUpFac}x${varUpFac} \
# 	0 \
# 	6
#
# done
#
# # cd back to original directory:
# cd "${strPathOrig}"
# # -----------------------------------------------------------------------------
