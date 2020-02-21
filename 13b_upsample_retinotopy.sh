#!/bin/bash


###############################################################################
# Upsample pRF results.                                                       #
###############################################################################


# -----------------------------------------------------------------------------
# *** Define parameters

# Input directory:
strPthIn="/media/h/P04/Data/S04/Ses01/03_GLM/03_pRF/pRF_results/"

# Output directory:
strPthOut="/media/h/P04/Data/S04/Ses01/03_GLM/03_pRF/pRF_results_up_tst/"
mkdir ${strPthOut}
# Upsampling factor (e.g. 0.5 for half the previous voxel size, 0.25 for a
# quater of the previous voxel size):
varUpFac=0.4
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# *** Upsample images

echo "-Upsampling of pRF results"

# Calculate inverse of upsampling factor (for caculation of new matrix size):
varUpInv=`bc <<< 1/${varUpFac}`

# Save original path in order to cd back to this path in the end:
# strPathOrig=( $(pwd) )
strPathOrig=$PWD

# cd into target directory and create list of images to be processed, only
# taking into account compressed nii files containing pRF results:
cd "${strPthIn}"
aryIn=( $(ls | grep results_ | grep .nii.gz) )


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
