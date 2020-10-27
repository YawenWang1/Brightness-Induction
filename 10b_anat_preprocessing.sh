#! /bin/bash
################################################################################

# Mask brain mask from bias corrected INV2 Image
################################################################################
# Directory of sri's motion correction and distortion correction code
start_tme=$(date +%s)

################################################################################
# Simple formatting
# Start bold text
bold=$(tput bold)
# Turn off all attributes
normal=$(tput sgr0)

################################################################################


Pth='/media/h/P04/Data/BIDS/'
subject_id='sub-03'
session_id='ses-002'
TR=2.604
################################################################################
anat_Pth=${Pth}${subject_id}/${session_id}/anat/spm_bf_correction
INV2=${anat_Pth}/msub-03_ses-002_acq-MP2RAGE_run-1_mod-INV2_T1w
# Get the dimension of BI run at [x,y,z]
xmax=$($ANTSPATH/PrintHeader ${INV2}.nii | grep Dimens | cut -d '[' -f 2 | cut -d ',' -f 1 | cut -d ']' -f 1)
echo ${xmax}
ymax=$($ANTSPATH/PrintHeader ${INV2}.nii | grep Dimens | cut -d ',' -f 2 | cut -d ']' -f 1)
echo ${ymax}
zmax=$($ANTSPATH/PrintHeader ${INV2}.nii | grep Dimens | cut -d ',' -f 3 | cut -d ']' -f 1)
echo ${zmax}
# ################################################################################
# # Make mask
echo "-----> Creating Brain mask from INV2."
echo ""
/usr/share/fsl/5.0/bin/bet ${INV2} \
${INV2}_brain \
-f 0.20000000000000007 \
-g 0 \
-m \
-t

# Get non-brain mask
fslmaths \
${anat_Pth}/c3sub-03_ses-002_acq-MP2RAGE_run-1_mod-INV2_T1w.nii \
-add ${anat_Pth}/c4sub-03_ses-002_acq-MP2RAGE_run-1_mod-INV2_T1w.nii \
-add ${anat_Pth}/c5sub-03_ses-002_acq-MP2RAGE_run-1_mod-INV2_T1w.nii \
${anat_Pth}/sub-03_non_brainmask.nii.gz
# Manully adjust occipital lobe area to remove sinus
# Get invertion of non_brain_Mask
fslmaths \
${anat_Pth}/sub-03_non_brainmask.nii.gz \
-sub 1 \
-mul -1 \
${anat_Pth}/sub-03_non_brainmask_ivt.nii.gz
# Calculate brains to fit to freesurfer
fslmaths \
${anat_Pth}/msub-03_ses-002_acq-MP2RAGE_run-1_mod-UNI_T1w.nii \
-mul ${anat_Pth}/mINV2_brainMask.nii.gz \
-mul ${anat_Pth}/sub-03_non_brainmask_ivt.nii.gz \
${anat_Pth}/sub-03_UNI_brain.nii.gz
# Get T1 brain
fslmaths \
${Pth}${subject_id}/${session_id}/anat/sub-03_ses-002_acq-MP2RAGE_run-1_mod-T1_T1w.nii.gz \
-mul ${anat_Pth}/mINV2_brainMask.nii.gz \
-mul ${anat_Pth}/sub-03_non_brainmask_ivt.nii.gz \
${anat_Pth}/sub-03_T1_brain.nii.gz


# Make a new folder for freesurfer files
fsPth=${Pth}${subject_id}/${session_id}/anat/fs
mkdir ${fsPth}
# Copy two files are needed for running freesurfer
cp ${anat_Pth}/sub-03_T1_brain.nii.gz ${fsPth}/sub-03_T1_brain.nii.gz
cp ${anat_Pth}/sub-03_UNI_brain.nii.gz ${fsPth}/sub-03_UNI_brain.nii.gz





echo "-----> Finished to preprocess anatomical data."
echo " "

echo " "
end_tme=$(date +%s)
nettme=$(expr $end_tme - $start_tme)
echo "-----> It took in $(($nettme / 3600))h:$(($nettme % 3600 / 60))m:$(($nettme % 60))s."
echo " "
