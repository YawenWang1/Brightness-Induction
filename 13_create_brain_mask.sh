#!/bin/bash
##This script is to automatically create a brain mask for all the fun_runs######
strDataPath="/media/h/P02/Data/S03/Ses01/03_GLM/00_Ana/whole_brain_epi_reference/"
#Directory where the mean_images are
ana_niis="${strDataPath}S03_BP_ep3d_0p8_wholebraintemplate0_reg2anaWarped.nii.gz"
# #######the end of all right phase encoding nifti files##########################

curropt="${strDataPath}/epi_reg2ana_brain_mask.nii.gz"
# $ANTSPATH/ThresholdImage 3  ${ana_niis} ${curropt} 0.8 20
# $ANTSPATH/ImageMath 3 ${curropt} ME ${curropt} 1
# $ANTSPATH/ImageMath 3 ${curropt} GetLargestComponent ${curropt}
# $ANTSPATH/ImageMath 3 ${curropt} MD ${curropt} 2
# $ANTSPATH/ImageMath 3 ${curropt} ME ${curropt} 1

# #Post-processing of masks

$ANTSPATH/ImageMath 3 ${curropt} MD ${curropt} 4
# $ANTSPATH/ImageMath 3 ${curropt} ME ${curropt} 2

#itksnap manually change the _MC.nii.gz and save as _mask.nii.gz
# ############################ MASK ##########################
#


# start_time=$(date +%s)
# ############################ INIT ##########################
# # Subject
# s=1
# # Run
# r=1
# # TR
# tr=2.8394
# # Number of volumes
# vols=230
# # RUN 1
# # Filenames
# fmri=sub${s}_ep3d_func_asl_run${r}.nii.gz
# prefix=sub${s}_ep3d_func_asl_run${r}
# ope=sub${s}_ep3d_func_asl_ope_run${r}.nii.gz
# prefix_ope=sub${s}_ep3d_func_asl_ope_run${r}
#
# ############################ FUNC ##########################
# # Fix the 4th dimension to correct TR
# ImageMath \
# 4 \
# ${fmri} \
# SetTimeSpacing \
# ${fmri} \
# ${tr}
#
# # Extract the reference volume
# ImageMath \
# 4 \
# ${prefix}_ref.nii.gz \
# TimeSeriesSubset \
# ${fmri} 1
#
# # Use ${prefix}_ref100.nii.gz as fixed image
# # Run motion correction without mask
#
# ############################ MASK ##########################
# # Create an automated brain mask
# ThresholdImage 3  ${prefix}_mc_avg.nii.gz ${prefix}_mask.nii.gz 120 1.e9
# ImageMath 3 ${prefix}_mask.nii.gz ME ${prefix}_mask.nii.gz 1
# ImageMath 3 ${prefix}_mask.nii.gz GetLargestComponent ${prefix}_mask.nii.gz
# ImageMath 3 ${prefix}_mask.nii.gz MD ${prefix}_mask.nii.gz 2
# ImageMath 3 ${prefix}_mask.nii.gz ME ${prefix}_mask.nii.gz 1
#
# ############################ OPE ##########################
# # Perform Affine motion correction of opposite phase-encoded data
# antsMotionCorr \
# --dimensionality 3 \
# --random-seed 42 \
# --use-histogram-matching 1 \
# --useFixedReferenceImage 1 \
# --verbose 1 \
# --use-estimate-learning-rate-once \
# --useScalesEstimator \
# --transform Rigid[0.25] \
# --metric MI[ ${prefix}_mc_avg.nii.gz , ${ope} , 1 , 32 , Regular , 0.25 ] \
# --iterations 15x10x5 \
# --smoothingSigmas 2x1x0 \
# --shrinkFactors 4x2x1 \
# --output [ ${prefix_ope} , ${prefix_ope}_mc.nii.gz , ${prefix_ope}_mc_avg.nii.gz ]
#
# # Register opposite phase-encoded data to the functional data
# antsRegistration \
# --dimensionality 3 \
# --random-seed 42 \
# --float \
# --masks [ ${prefix}_mask.nii.gz , 1 ] \
# --interpolation BSpline[4] \
# --initial-moving-transform [ ${prefix}_mc_avg.nii.gz , ${prefix_ope}_mc_avg.nii.gz , 1 ] \
# --transform Rigid[0.1] \
# --metric MeanSquares[ ${prefix}_mc_avg.nii.gz , ${prefix_ope}_mc_avg.nii.gz , 1 , 32 , Regular , 0.25 ] \
# --convergence 100x50x25 \
# --smoothing-sigmas 2x1x0 \
# --shrink-factors 4x2x1 \
# --use-histogram-matching 1 \
# --use-estimate-learning-rate-once 1 \
# --winsorize-image-intensities [ 0.005 , 0.995  ] \
# --output [ ${prefix_ope}_reg2func_ , ${prefix_ope}_reg2func_Warped.nii.gz , 1 ]
