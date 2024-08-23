#! /bin/bash
# Track the time 41s

start_tme=$(date +%s)
# From session 002
funPth='/media/g/P04/Data/BIDS/sub-12/ses-002/func/'
trfPth='/media/g/P04/Data/BIDS/sub-12/ses-002/func/TRFs/'
anatPth='/media/g/P04/Data/BIDS/sub-12/ses-002/anat/fs/sub-12/mri/nii/'

funmskPth='/media/g/P04/Data/BIDS/sub-12/ses-002/func/'
moving_fun=${funPth}sub-12_ses-002_task-BI_acq-EP3D_dir-RL_run-1_echo-1_bold_fixed_dc_template0.nii.gz
msk_fun_brain=${funPth}sub-12_ses-002_task-BI_acq-EP3D_dir-RL_run-1_echo-1_bold_fixedMask_brain.nii.gz

msk_brain=${anatPth}sub-12_ses-002_brainmask_ncrb.nii.gz
fixed_anat=${anatPth}brain.finalsurfs.nii.gz

# From session 001
prfPth='/media/g/P04/Data/BIDS/sub-12/ses-001/func/'
prfmskPth='/media/g/P04/Data/BIDS/sub-12/ses-001/func/'
moving_prf=${prfPth}sub-12_ses-001_task-pRF_acq-EP3D_dir-RL_run-1_echo-1_bold_fixed_dc_template0.nii.gz
msk_prf_brain=${prfPth}sub-12_ses-001_task-pRF_acq-EP3D_dir-RL_run-1_echo-1_bold_fixedMask_brain.nii.gz

# Output directory
Outpth='/media/g/P04/Data/BIDS/sub-12/ses-002/func/GLM/Anat_space/'
mkdir ${Outpth}
# Register pRF to anatomy

echo "Register pRF to anatomy"
$ANTSPATH/antsRegistration \
--verbose 1 \
--dimensionality 3 \
--float 1 \
--collapse-output-transforms 1 \
--output [ ${Outpth}sub-12_ses-001_prf_to_anat_,${Outpth}sub-12_ses-001_prf_to_anat_Warped.nii.gz,${Outpth}sub-12_ses-001_prf_to_anat_InverseWarped.nii.gz ] \
--interpolation LanczosWindowedSinc \
--use-histogram-matching 1 \
--winsorize-image-intensities [ 0.005,0.995 ] \
-x [ ${msk_brain}, ${msk_prf_brain} ] \
--initial-moving-transform [${trfPth}sub-12_ses-002_ana_to_pRF.txt,1] \
--transform Rigid[ 0.1 ] \
--metric MI[ ${fixed_anat},${moving_prf},1,4 ] \
--convergence [ 100x50,1e-6,10 ] \
--shrink-factors 2x1 \
--smoothing-sigmas 2x0vox
#
# #-------------------------------------------------------------------------------
# # Register functional fixed image to anatomy
echo "Register functional runs to anatomy"
$ANTSPATH/antsRegistration \
--verbose 1 \
--dimensionality 3 \
--float 1 \
--collapse-output-transforms 1 \
--output [ ${Outpth}sub-12_ses-002_fun_to_anat_,${Outpth}sub-12_ses-002_fun_to_anat_Warped.nii.gz,${Outpth}sub-12_ses-002_fun_to_anat_InverseWarped.nii.gz ] \
--interpolation LanczosWindowedSinc \
--use-histogram-matching 1 \
--winsorize-image-intensities [ 0.005,0.995 ] \
-x [ ${msk_brain}, ${msk_fun_brain} ] \
--initial-moving-transform [${trfPth}sub-12_ses-002_ana_to_fun.txt,1] \
--transform Rigid[ 0.1 ] \
--metric MI[ ${fixed_anat},${moving_fun},1,4 ] \
--convergence [ 100x50,1e-6,10 ] \
--shrink-factors 2x1 \
--smoothing-sigmas 2x0vox
#
# # Register pRF fixed image to functional mean
echo "Register functional runs to anatomy"
$ANTSPATH/antsRegistration \
--verbose 1 \
--dimensionality 3 \
--float 1 \
--collapse-output-transforms 1 \
--output [ ${Outpth}sub-12_ses-001_prf_to_fun_,${Outpth}sub-12_ses-001_prf_to_fun_Warped.nii.gz,${Outpth}sub-12_ses-001_prf_to_fun_InverseWarped.nii.gz ] \
--interpolation LanczosWindowedSinc \
--use-histogram-matching 1 \
--winsorize-image-intensities [ 0.005,0.995 ] \
-x [ ${msk_fun_brain}, ${msk_prf_brain} ] \
--initial-moving-transform ${trfPth}sub-12_ses-002_pRF_to_fun.txt \
--transform Rigid[ 0.1 ] \
--metric MI[ ${moving_fun},${moving_prf},1,4 ] \
--convergence [ 100x50,1e-6,10 ] \
--shrink-factors 2x1 \
--smoothing-sigmas 2x0vox

cp ${Outpth}sub-12_ses-001_prf_to_fun_0GenericAffine.mat ${trfPth}sub-12_ses-001_prf_to_fun_0GenericAffine.mat
cp ${Outpth}sub-12_ses-002_fun_to_anat_0GenericAffine.mat ${trfPth}sub-12_ses-002_fun_to_anat_0GenericAffine.mat
cp ${Outpth}sub-12_ses-001_prf_to_anat_0GenericAffine.mat ${trfPth}sub-12_ses-001_prf_to_anat_0GenericAffine.mat

end_tme=$(date +%s)
nettme=$(expr $end_tme - $start_tme)
echo " "
echo "-----> Registration took in $(($nettme / 3600))h:$(($nettme % 3600 / 60))m:$(($nettme % 60))s."
echo " "
