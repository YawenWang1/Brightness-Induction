#!/bin/bash


###############################################################################
# Upsample pRF results.                                                       #
###############################################################################


# -----------------------------------------------------------------------------
# *** Define parameters

# Input directory:
# strPthIn="/media/h/P04/Data/S04/Ses01/03_GLM/00_Ana/S04/label/"
strPthIn="/media/h/P04/Data/S04/Ses01/03_GLM/04_ASpace/06_0p8/"

# Output directory:
strPthOut="/media/h/P04/Data/S04/Ses01/03_GLM/04_ASpace/06_0p8/"
mkdir ${strPthOut}
# Upsampling factor (e.g. 0.5 for half the previous voxel size, 0.25 for a
# quater of the previous voxel size):
varUpFac=0.8
# -----------------------------------------------------------------------------
# Define ROI names
# roifiles=(
# benson14atlas.V1 \
# benson14atlas.V2 \
# benson14atlas.V3 \
# benson14atlas.hV4 \
# )
cd "${strPthIn}"

roifiles=( $(ls | grep .nii.gz) )



# -----------------------------------------------------------------------------
# *** Upsample images

echo "-Upsampling of ROI files"

# Check number of files to be processed:
varNumIn=${#roifiles[@]}

# Since indexing starts from zero, we subtract one:
varNumIn=$((varNumIn - 1))

for idx01 in $(seq 0 $varNumIn)
do
	# Define temporary path of current input image:
	# strTmpIn="${strPthIn}${roifiles[idx01]}.nii.gz"
	strTmpIn="${strPthIn}${roifiles[idx01]}"
	# Define temporary path of current output image:
	# strTmpOut="${strPthOut}${roifiles[idx01]}.0p8.nii.gz"
	strTmpOut="${strPthIn}${roifiles[idx01]}"

	echo "--------------------------------------------------------------------"
	echo "------Processing ${roifiles[idx01]}"
	date
	#
	# # Run Upsampling
	# $ANTSPATH/ResampleImage \
	# 3 \
	# ${strTmpIn} \
	# ${strTmpOut} \
	# ${varUpFac}x${varUpFac}x${varUpFac} \
	# 0 \
	# 4

	fslmaths \
	${strTmpOut} \
	-thr 0.5 \
	${strTmpOut} \

	fslmaths ${strTmpOut} -bin ${strTmpOut}


done

# -----------------------------------------------------------------------------
