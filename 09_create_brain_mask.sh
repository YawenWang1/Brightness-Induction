#!/bin/bash
##This script is to automatically create a brain mask for all the fun_runs######
strDataPath="/media/h/P04/Data/S04/Ses01/02_Preprocessing/01_Func/"
#Directory where the mean_images are
mean_niis="${strDataPath}02_fun_mean_images/"
#####Make a new folder for all the mean images if it doesn't exit###############
destPath="${strDataPath}03_fun_masks"
if ((-d ${destPath}))
then
  echo "the folder already exits"
else
  mkdir ${destPath}
fi
# #######the end of all right phase encoding nifti files##########################
file_end="_template0"
# for runid in {1..7}
# do
#   currfile="${mean_niis}fun_0${runid}${file_end}.nii.gz"
#   curropt="${destPath}/fun_0${runid}${file_end}_mask.nii.gz"
#   $ANTSPATH/ThresholdImage 3  ${currfile} ${curropt} 0.6 20
#   $ANTSPATH/ImageMath 3 ${curropt} ME ${curropt} 1
#   $ANTSPATH/ImageMath 3 ${curropt} GetLargestComponent ${curropt}
#   $ANTSPATH/ImageMath 3 ${curropt} MD ${curropt} 2
#   $ANTSPATH/ImageMath 3 ${curropt} ME ${curropt} 2
# done
#Post-processing of masks
for runid in {1..7}
do
  currfile="${destPath}/fun_0${runid}${file_end}_mask.nii.gz"
  curropt="${destPath}/fun_0${runid}${file_end}_mask_ED.nii.gz"
  $ANTSPATH/ImageMath 3 ${curropt} ME ${currfile} 1
  $ANTSPATH/ImageMath 3 ${curropt} MD ${curropt} 2
done
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
