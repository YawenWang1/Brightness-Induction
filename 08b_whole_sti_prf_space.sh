#! /bin/bash
pRF_resPth='/media/g/P04/Data/BIDS/sub-12/ses-001/func/GLM/pRF/s2/pRF_results/'

export ovrlp_namearray=(1 "50" "75" "90" "95")
numROI=${#pRF_oc_ROI[@]}

for ovlpid in {1..4};do
  echo "Now processing ----------------------"${ovlpid}" prct "
  fslmaths ${pRF_resPth}pRF_results_ovrlp_mask_${ovrlp_namearray[${ovlpid}]}prct_background.nii.gz \
  -add ${pRF_resPth}pRF_results_ovrlp_mask_${ovrlp_namearray[${ovlpid}]}prct_centre.nii.gz \
  -add ${pRF_resPth}pRF_results_ovrlp_mask_${ovrlp_namearray[${ovlpid}]}prct_edge.nii.gz \
  ${pRF_resPth}stimulus_roi_${ovrlp_namearray[${ovlpid}]}prct_ori.nii.gz
done

fslmaths ${pRF_resPth}pRF_results_ovrlp_mask_50prct_edge.nii.gz \
-add ${pRF_resPth}pRF_results_ovrlp_mask_75prct_centre.nii.gz \
-add ${pRF_resPth}pRF_results_ovrlp_mask_75prct_background.nii.gz \
${pRF_resPth}stimulus_roi_comb.nii.gz
