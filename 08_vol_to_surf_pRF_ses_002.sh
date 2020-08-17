#! /bin/bash

# Register pRF to anatomy
#--------------------------------------------------------------------------------------

# Define all the pRF files
export SUBJECTS_DIR='/media/h/P04/Data/BIDS/sub-02/ses-002/anat'
export prf_namearray=(1 "polar_angle" "PE_01" "eccentricity" "R2" "SD" "x_pos" "y_pos")
trfPth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/TRFs/'
prfPth='/media/h/P04/Data/BIDS/sub-02/ses-001/func/GLM/pRF/pRF_results/'
anatPth='/media/h/P04/Data/BIDS/sub-02/ses-002/anat/sub-02/mri/nii/'

fixed_anat=${anatPth}brain_finalsurfs.nii.gz
Outpth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/Anat_space/pRF/'
mkdir ${Outpth}

prfsrfOptPth=${Outpth}In_surface/
mkdir ${prfsrfOptPth}
subjID='sub-02'


for i in {1..7}; do

$ANTSPATH/antsApplyTransforms -d 3 \
-i ${prfPth}results_${prf_namearray[${i}]}.nii.gz \
-o ${Outpth}results_${prf_namearray[${i}]}_reg2fsanat.nii.gz \
-n BSpline[4] \
-r ${fixed_anat} \
-t ${trfPth}sub-02_ses-001_prf_to_fs_0GenericAffine.mat \
-v
done


#
for hemi in {"lh","rh"}; do
for i in $(seq 1 7); do

  # Get the name of the current prf roi
  interp01=results_${prf_namearray[${i}]}
  # interp02=$(cut -d '_' -f 7,8 <<< ${interp01})

  # interp02=$(cut -d '_' -f 1,2,3,4,7,8 <<< ${interp01})

  mri_vol2surf \
  --mov ${Outpth}${interp01}_reg2fsanat.nii.gz \
  --regheader ${subjID} \
  --hemi ${hemi} \
  --o ${prfsrfOptPth}${interp01}_reg2fsanat_${hemi}.nii.gz \
  --interp nearest
done
done


# Look at the data from freeview
# freeview -f $SUBJECTS_DIR/S04/surf/lh.inflated:overlay=./results_227vols_polar_angle_reg2anat_lh.nii.gz:label=/media/h/P04/Data/S04/Ses01/03_GLM/00_Ana/S04/label/lh.benson14atlas.V1.label:label=/media/h/P04/Data/S04/Ses01/03_GLM/00_Ana/S04/label/lh.benson14atlas.V2.label
