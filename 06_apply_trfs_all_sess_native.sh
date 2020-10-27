#! /bin/bash
# Track the time 41s

start_tme=$(date +%s)
# From session 002
funPth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/'
trfPth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/TRFs/'
anatPth='/media/h/P04/Data/BIDS/sub-02/ses-002/anat/'
funmskPth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/'
moving_fun=${funPth}sub-02_ses-002_task-BI_acq-EP3D_dir-RL_run-1_echo-1_bold_fixed_dc_template0.nii.gz
msk_brain=${anatPth}sub-02_ses-002_brainmask_ncrb.nii.gz
fixed_anat=${anatPth}msub-02_ses-002_acq-MP2RAGE_run-1_mod-UNI_T1w_brain.nii.gz

# From session 001
prfPth='/media/h/P04/Data/BIDS/sub-02/ses-001/func/'
prfmskPth='/media/h/P04/Data/BIDS/sub-02/ses-001/func/'
moving_prf=${prfPth}sub-02_ses-001_task-pRF_acq-EP3D_dir-RL_run-1_echo-1_bold_fixed_dc_template0.nii.gz
msk_prf_brain=${prfPth}sub-02_ses-001_task-pRF_acq-EP3D_dir-RL_run-1_echo-1_bold_fixedMask_brain.nii.gz

# Output directory
Outpth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/Anat_space/'
mkdir ${Outpth}
# Register pRF to anatomy

echo "Register pRF to anatomy"
$ANTSPATH/antsRegistration \
--verbose 1 \
--dimensionality 3 \
--float 1 \
--collapse-output-transforms 1 \
--output [ ${Outpth}sub-02_ses-001_prf_to_ana_,${Outpth}sub-02_ses-001_prf_to_ana_Warped.nii.gz,${Outpth}sub-02_ses-001_prf_to_ana_InverseWarped.nii.gz ] \
--interpolation LanczosWindowedSinc \
--use-histogram-matching 1 \
--winsorize-image-intensities [ 0.005,0.995 ] \
-x [ ${msk_brain}, ${msk_prf_brain} ] \
--initial-moving-transform [${trfPth}sub-02_ses-002_anat_to_pRF.txt,1] \
--transform Rigid[ 0.1 ] \
--metric MI[ ${fixed_anat},${moving_prf},1,4 ] \
--convergence [ 100x50,1e-6,10 ] \
--shrink-factors 2x1 \
--smoothing-sigmas 2x0vox

#-------------------------------------------------------------------------------
# Register functional fixed image to anatomy
echo "Register functional runs to anatomy"
$ANTSPATH/antsRegistration \
--verbose 1 \
--dimensionality 3 \
--float 1 \
--collapse-output-transforms 1 \
--output [ ${Outpth}sub-02_ses-002_fun_to_ana_,${Outpth}sub-02_ses-002_fun_to_ana_Warped.nii.gz,${Outpth}sub-02_ses-002_fun_to_ana_InverseWarped.nii.gz ] \
--interpolation LanczosWindowedSinc \
--use-histogram-matching 1 \
--winsorize-image-intensities [ 0.005,0.995 ] \
-x [ ${msk_brain}, ${msk_prf_brain} ] \
--initial-moving-transform [${trfPth}sub-02_ses-002_anat_to_fun.txt,1] \
--transform Rigid[ 0.1 ] \
--metric MI[ ${fixed_anat},${moving_fun},1,4 ] \
--convergence [ 100x50,1e-6,10 ] \
--shrink-factors 2x1 \
--smoothing-sigmas 2x0vox



end_tme=$(date +%s)
nettme=$(expr $end_tme - $start_tme)
echo " "
echo "-----> Registration took in $(($nettme / 3600))h:$(($nettme % 3600 / 60))m:$(($nettme % 60))s."
echo " "
