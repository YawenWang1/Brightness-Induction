#! /bin/bash
# Apply transformation for results from pyprf took in 0h:0m:48s.

start_tme=$(date +%s)

# Define all the pRF files
pRF_roi_Pth='/media/g/P04/Data/BIDS/sub-12/ses-002/func/GLM/Anat_space/pRF/ROI/'
export varea_namearray=(1 "V1" "V2" "V3")
export prf_roi_namearray=(1 "background" "centre" "edge")
vareapth='/media/g/P04/Data/BIDS/sub-12/ses-002/func/GLM/Anat_space/Masks/'
mkdir '/media/g/P04/Data/BIDS/sub-12/ses-002/func/GLM/Anat_space/Masks/final/'
for vid in {1..3}; do
  for sid in {1..2}; do

  fslmaths ${vareapth}sub-12_ses-002_rh_${varea_namearray[${vid}]}.nii.gz \
  -mul ${pRF_roi_Pth}pRF_results_lroi_nf_ovrlp_mask_75prct_${prf_roi_namearray[${sid}]}_reg2fsanat_msk.nii.gz \
  ${vareapth}final/sub-12_ses-002_lroi_nf_rh_${varea_namearray[${vid}]}_${prf_roi_namearray[${sid}]}.nii.gz

  fslmaths ${vareapth}sub-12_ses-002_lh_${varea_namearray[${vid}]}.nii.gz \
  -mul ${pRF_roi_Pth}pRF_results_lroi_nf_ovrlp_mask_75prct_${prf_roi_namearray[${sid}]}_reg2fsanat_msk.nii.gz \
  ${vareapth}final/sub-12_ses-002_lroi_nf_lh_${varea_namearray[${vid}]}_${prf_roi_namearray[${sid}]}.nii.gz

  fslmaths ${vareapth}final/sub-12_ses-002_lroi_nf_rh_${varea_namearray[${vid}]}_${prf_roi_namearray[${sid}]}.nii.gz \
  -add ${vareapth}final/sub-12_ses-002_lroi_nf_lh_${varea_namearray[${vid}]}_${prf_roi_namearray[${sid}]}.nii.gz \
  ${vareapth}final/sub-12_ses-002_lroi_nf_${varea_namearray[${vid}]}_${prf_roi_namearray[${sid}]}.nii.gz


done
done

for vid in {1..3}; do
  for sid in {3..3}; do

  fslmaths ${vareapth}sub-12_ses-002_rh_${varea_namearray[${vid}]}.nii.gz \
  -mul ${pRF_roi_Pth}pRF_results_lroi_nf_ovrlp_mask_50prct_${prf_roi_namearray[${sid}]}_reg2fsanat_msk.nii.gz \
  ${vareapth}final/sub-12_ses-002_lroi_nf_rh_${varea_namearray[${vid}]}_${prf_roi_namearray[${sid}]}.nii.gz

  fslmaths ${vareapth}sub-12_ses-002_lh_${varea_namearray[${vid}]}.nii.gz \
  -mul ${pRF_roi_Pth}pRF_results_lroi_nf_ovrlp_mask_50prct_${prf_roi_namearray[${sid}]}_reg2fsanat_msk.nii.gz \
  ${vareapth}final/sub-12_ses-002_lroi_nf_lh_${varea_namearray[${vid}]}_${prf_roi_namearray[${sid}]}.nii.gz

  fslmaths ${vareapth}final/sub-12_ses-002_lroi_nf_rh_${varea_namearray[${vid}]}_${prf_roi_namearray[${sid}]}.nii.gz \
  -add ${vareapth}final/sub-12_ses-002_lroi_nf_lh_${varea_namearray[${vid}]}_${prf_roi_namearray[${sid}]}.nii.gz \
  ${vareapth}final/sub-12_ses-002_lroi_nf_${varea_namearray[${vid}]}_${prf_roi_namearray[${sid}]}.nii.gz


done
done

end_tme=$(date +%s)
nettme=$(expr $end_tme - $start_tme)
echo " "
echo "-----> Transform label to nii files took in $(($nettme / 3600))h:$(($nettme % 3600 / 60))m:$(($nettme % 60))s."
echo " "

#
# # Look at the data from freeview
# # freeview -f $SUBJECTS_DIR/S04/surf/lh.inflated:overlay=./results_227vols_polar_angle_reg2anat_lh.nii.gz:label=/media/g/P04/Data/S04/Ses01/03_GLM/00_Ana/S04/label/lh.benson14atlas.V1.label:label=/media/g/P04/Data/S04/Ses01/03_GLM/00_Ana/S04/label/lh.benson14atlas.V2.label
