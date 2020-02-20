#!/bin/bash


###############################################################################
# Upsample pRF results.                                                       #
###############################################################################


# -----------------------------------------------------------------------------
# *** Define parameters

# Input directory:
# strPthIn="/media/h/P04/Data/S04/Ses01/03_GLM/04_ASpace/pRF_results_up_tst/"
strPthIn="/media/h/P04/Data/S04/Ses01/03_GLM/03_pRF/pRF_results/pRF_results_note4/"

# Output directory:
# strPthOut="/media/h/P04/Data/S04/Ses01/03_GLM/04_ASpace/pRF_results_up_tst_0p4/"6
# strPthOut="/media/h/P04/Data/S04/Ses01/03_GLM/03_pRF/pRF_results/upsample_0p8_pRF_results_note2/"
strPthOut="/media/h/P04/Data/S04/Ses01/03_GLM/03_pRF/pRF_results/pRF_results_note4/"

mkdir ${strPthOut}
# Upsampling factor (e.g. 0.5 for half the previous voxel size, 0.25 for a
# quater of the previous voxel size):
# varUpFac=0.4
varUpFac=0.8

# -----------------------------------------------------------------------------
# Define ROI names
cd "${strPthIn}"
aryIn=( $(ls | grep pRF_results_ovrlp_mask_ | grep .nii.gz) )


# -----------------------------------------------------------------------------
# *** Upsample images

echo "-Upsampling of prf_results files"

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

	# # # Run Upsampling
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
