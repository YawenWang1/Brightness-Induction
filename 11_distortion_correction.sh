#!/bin/bash
##This script is to distortion correction ######################################
strDataPath="/media/h/P04/Data/S04/Ses01/02_Preprocessing/01_Func/"
##for functional runs###########################################################
meanPath="${strDataPath}02_fun_mean_images/"
dcOutPthup="${strDataPath}04_dist_correction/"
dcFilesPth="${dcOutPthup}00_DC/"
mkdir ${dcFilesPth}
#for all the funs during the sessions
for runid in {1..7}
do
	# register ope to corresponding functional run
	refImg="${meanPath}fun_0${runid}_template0.nii.gz"
	movImg="${meanPath}fun_0${runid}_ope_template0.nii.gz"
	# mskImg="${strDataPath}03_fun_masks/fun_0${runid}_template0_mask.nii.gz"


	$ANTSPATH/antsRegistration --verbose 1 \
	--random-seed 42 --dimensionality 3 --float 1 \
	--collapse-output-transforms 1 \
	--output [ ${dcOutPthup}fun_0${runid}_ope_reg2run_,${dcOutPthup}fun_0${runid}_ope_reg2run_Warped.nii.gz,1 ] \
	--interpolation BSpline[4] \
	--use-histogram-matching 1 \
	--winsorize-image-intensities [ 0.005,0.995 ] \
	--initial-moving-transform [ ${refImg},${movImg},1 ] --transform Rigid[ 0.1 ] \
	--metric MI[ ${refImg},${movImg},1,32,Regular,0.25 ] \
	--convergence [ 250x100,1e-6,10 ] --shrink-factors 2x1 --smoothing-sigmas 1x0vox

	# -x [ ${mskImg}, 1 ] \


	$ANTSPATH/antsMultivariateTemplateConstruction2.sh \
	-d 3 \
	-i 4 \
	-k 1 \
	-f 4x2x1 \
	-s 2x1x0vox \
	-q 30x20x4 \
	-t SyN \
	-m CC \
	-c 2 \
	-j 16 \
	-o ${dcFilesPth}fun_0${runid}_dc_ \
	${refImg} \
	${dcOutPthup}fun_0${runid}_ope_reg2run_Warped.nii.gz

done
