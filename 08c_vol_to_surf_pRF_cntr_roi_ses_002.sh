#! /bin/bash

# Register pRF to anatomy
#--------------------------------------------------------------------------------------

# Define all the pRF files
export SUBJECTS_DIR='/media/g/P04/Data/BIDS/sub-12/ses-002/anat/fs'
export prf_roi_namearray=(1 "background" "centre" "edge")
trfPth='/media/g/P04/Data/BIDS/sub-12/ses-002/func/TRFs/'
prfPth='/media/g/P04/Data/BIDS/sub-12/ses-001/func/GLM/pRF/s2/pRF_results/'
anatPth='/media/g/P04/Data/BIDS/sub-12/ses-002/anat/fs/sub-12/mri/nii/'
msk_brain=${anatPth}sub-12_ses-002_brainmask_ncrb.nii.gz

fixed_anat=${anatPth}brain.finalsurfs.nii.gz
Outpth='/media/g/P04/Data/BIDS/sub-12/ses-002/func/GLM/Anat_space/pRF/ROI/'
mkdir /media/g/P04/Data/BIDS/sub-12/ses-002/func/GLM/Anat_space
mkdir /media/g/P04/Data/BIDS/sub-12/ses-002/func/GLM/Anat_space/pRF
mkdir ${Outpth}

prfsrfOptPth=${Outpth}In_surface/
mkdir ${prfsrfOptPth}
subjID='sub-12'


for i in {1..3}; do

$ANTSPATH/antsApplyTransforms -d 3 \
-i ${prfPth}pRF_results_ovrlp_ctnr_${prf_roi_namearray[${i}]}.nii.gz \
-o ${Outpth}pRF_results_ovrlp_ctnr_${prf_roi_namearray[${i}]}_reg2fsanat.nii.gz \
-n GenericLabel \
-r ${fixed_anat} \
-t ${trfPth}sub-12_ses-001_prf_to_anat_0GenericAffine.mat \
-v

fslmaths ${Outpth}pRF_results_ovrlp_ctnr_${prf_roi_namearray[${i}]}_reg2fsanat.nii.gz \
-mul ${msk_brain} \
${Outpth}pRF_results_ovrlp_ctnr_${prf_roi_namearray[${i}]}_reg2fsanat_msk.nii.gz

done


#--------------------------------------------${olvp_prct[${opid}]}prct_-------------------------------------------
# Project them to Surface



for hemi in {"lh","rh"}; do

for i in {1..3}; do

  mri_vol2surf \
  --mov ${Outpth}pRF_results_ovrlp_ctnr_${prf_roi_namearray[${i}]}_reg2fsanat_msk.nii.gz \
  --regheader ${subjID} \
  --hemi ${hemi} \
  --o ${prfsrfOptPth}pRF_results_ovrlp_ctnr_${prf_roi_namearray[${i}]}_reg2fsanat_msk_${hemi}.nii.gz \
  --interp nearest
done

done




# Look at the data from freeview
# freeview -f $SUBJECTS_DIR/S04/surf/lh.inflated:overlay=./results_227vols_polar_angle_reg2anat_lh.nii.gz:label=/media/g/P04/Data/S04/Ses01/03_GLM/00_Ana/S04/label/lh.bes1on14atlas.V1.label:label=/media/g/P04/Data/S04/Ses01/03_GLM/00_Ana/S04/label/lh.bes1on14atlas.V2.label
