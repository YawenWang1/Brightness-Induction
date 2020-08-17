#! /bin/bash

# Register pRF to anatomy
#--------------------------------------------------------------------------------------

# Define all the pRF files
export SUBJECTS_DIR=/media/h/P04/Data/BIDS/sub-02/ses-001/anat/MPRAGE
export prf_namearray=(1 "polar_angle" "PE_01" "eccentricity" "R2" "SD" "x_pos" "y_pos")
trfPth='/media/h/P04/Data/BIDS/sub-02/ses-001/func/TRFs/'
funPth='/media/h/P04/Data/BIDS/sub-02/ses-001/func/'
prfPth='/media/h/P04/Data/BIDS/sub-02/ses-001/func/GLM/pRF/'
mskPth='/media/h/P04/Data/BIDS/sub-02/ses-001/anat/MPRAGE/sub-02/mri/nii/'
fixed_anat=${mskPth}brain_finalsurfs.nii.gz
prfsrfOptPth=${prfPth}/pRF_results/In_surface/
mkdir ${prfsrfOptPth}
subjID='sub-02'


for runid in {1..4}; do

for i in {1..7}; do

$ANTSPATH/antsApplyTransforms -d 3 \
-i ${prfPth}results_run_0${runid}_${prf_namearray[${i}]}.nii.gz \
-o ${prfPth}results_run_0${runid}_${prf_namearray[${i}]}_reg2anat.nii.gz \
-n BSpline[4] \
-r ${fixed_anat} \
-t ${trfPth}P04_sub-02_ses-001_prf_to_fs_0GenericAffine.mat \
-v
done
done

#
for hemi in {"lh","rh"}; do
for runid in {1..4}; do
for i in {1..7}; do

  # Get the name of the current prf roi
  interp01=results_run_0${runid}_${prf_namearray[${i}]}_reg2anat

  mri_vol2surf \
  --mov ${prfPth}${interp01}.nii.gz \
  --regheader ${subjID} \
  --hemi ${hemi} \
  --o ${prfsrfOptPth}${interp01}_${hemi}.nii.gz \
  --interp nearest
done
done
done


# Look at the data from freeview
# freeview -f $SUBJECTS_DIR/S04/surf/lh.inflated:overlay=./results_227vols_polar_angle_reg2anat_lh.nii.gz:label=/media/h/P04/Data/S04/Ses01/03_GLM/00_Ana/S04/label/lh.benson14atlas.V1.label:label=/media/h/P04/Data/S04/Ses01/03_GLM/00_Ana/S04/label/lh.benson14atlas.V2.label
