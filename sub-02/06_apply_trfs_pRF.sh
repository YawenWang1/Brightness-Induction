#! /bin/bash
# Track the time 41s

start_tme=$(date +%s)

funPth='/media/h/P04/Data/BIDS/sub-02/ses-001/func/'
trfPth='/media/h/P04/Data/BIDS/sub-02/ses-001/func/TRFs/'
mskPth='/media/h/P04/Data/BIDS/sub-02/ses-001/anat/MPRAGE/sub-02/mri/nii/'
fixed_anat=${mskPth}brain_finalsurfs.nii.gz
moving_prf=${funPth}sub-02_ses-001_task-pRF_acq-EP3D_dir-RL_run-1_echo-1_bold_fixed_dc_template0.nii.gz
# msk_brain_oc_prf=${mskPth}brain_mask_oc_pRF.nii.gz
msk_brain=${mskPth}brain_mask.nii.gz
msk_prf_brain=${funPth}sub-02_ses-001_task-pRF_acq-EP3D_dir-RL_run-1_echo-1_bold_fixedMask_brain.nii.gz

# Register pRF to anatomy

echo "Register pRF to anatomy"
$ANTSPATH/antsRegistration \
--verbose 1 \
--dimensionality 3 \
--float 1 \
--collapse-output-transforms 1 \
--output [ ${trfPth}P04_sub-02_ses-001_prf_to_fs_,${trfPth}P04_sub-02_ses-001_prf_to_fs_Warped.nii.gz,${trfPth}P04_sub-02_ses-001_prf_to_fs_InverseWarped.nii.gz ] \
--interpolation BSpline[4] \
--use-histogram-matching 1 \
--winsorize-image-intensities [ 0.005,0.995 ] \
-x [ ${msk_brain}, ${msk_prf_brain} ] \
--initial-moving-transform [${trfPth}sub-02_ses-001_anat_to_pRF.txt,1] \
--transform Rigid[ 0.1 ] \
--metric MI[ ${fixed_anat},${moving_prf},1,4 ] \
--convergence [ 100x50,1e-6,10 ] \
--shrink-factors 2x1 \
--smoothing-sigmas 2x0vox

#-------------------------------------------------------------------------------
# Register functional fixed image to anatomy
# moving_fun=${funPth}sub-02_ses-001_task-BI_acq-EP3D_dir-RL_run-3_echo-1_bold_fixed_dc_template0.nii.gz
# msk_brain_oc_fun=${mskPth}brain_mask_oc_fun.nii.gz
# msk_fun_brain=${funPth}sub-02_ses-001_task-BI_acq-EP3D_dir-RL_run-3_echo-1_bold_fixed_dc_template0_fixed_brain.nii.gz

# echo "Register fun_fixed to anatomy"
# $ANTSPATH/antsRegistration \
# --verbose 1 \
# --dimensionality 3 \
# --float 1 \
# --collapse-output-transforms 1 \
# --output [ ${trfPth}P04_sub-02_ses-001_fun_to_fs_,${trfPth}P04_sub-02_ses-001_fun_to_fs_Warped.nii.gz,${trfPth}P04_sub-02_ses-001_fun_to_fs_InverseWarped.nii.gz ] \
# --interpolation BSpline[4] \
# --use-histogram-matching 1 \
# --winsorize-image-intensities [ 0.005,0.995 ] \
# -x [ ${msk_brain}, ${msk_fun_brain} ] \
# --initial-moving-transform [${trfPth}sub-02_ses-001_anat_to_fun.txt,1] \
# --transform Rigid[ 0.1 ] \
# --metric MI[ ${fixed_anat},${moving_fun},1,4 ] \
# --convergence [ 100x50,1e-6,10 ] \
# --shrink-factors 2x1 \
# --smoothing-sigmas 2x0vox

# Register pRF fixed image to functonal fixed
# echo "Register fun_fixed to anatomy"
# $ANTSPATH/antsRegistration \
# --verbose 1 \
# --dimensionality 3 \
# --float 1 \
# --collapse-output-transforms 1 \
# --output [ ${trfPth}P04_sub-02_ses-001_prf_to_fun_,${trfPth}P04_sub-02_ses-001_prf_to_fun_Warped.nii.gz,${trfPth}P04_sub-02_ses-001_prf_to_fun_InverseWarped.nii.gz ] \
# --interpolation BSpline[4] \
# --use-histogram-matching 1 \
# --winsorize-image-intensities [ 0.005,0.995 ] \
# -x [ ${msk_brain_oc_fun}, ${msk_fun_brain} ] \
# --initial-moving-transform ${trfPth}sub-02_ses-001_pRF_to_fun.txt \
# --transform Rigid[ 0.1 ] \
# --metric MI[ ${moving_fun},${moving_prf},1,4 ] \
# --convergence [ 100x50,1e-6,10 ] \
# --shrink-factors 2x1 \
# --smoothing-sigmas 2x0vox

end_tme=$(date +%s)
nettme=$(expr $end_tme - $start_tme)
echo " "
echo "-----> Registration took in $(($nettme / 3600))h:$(($nettme % 3600 / 60))m:$(($nettme % 60))s."
echo " "
