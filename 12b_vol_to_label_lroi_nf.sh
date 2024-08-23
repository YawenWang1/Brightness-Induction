#! /bin/bash
# Apply transformation for results from pyprf took in 0h:0m:48s.

start_tme=$(date +%s)
export SUBJECTS_DIR=/media/g/P04/Data/BIDS/sub-12/ses-002/anat/fs
export subjID='sub-12'

# Define all the pRF files
labelPth='/media/g/P04/Data/BIDS/sub-12/ses-002/anat/fs/sub-12/label/'

# Smoothed version
volPth="/media/g/P04/Data/BIDS/sub-12/ses-002/func/GLM/Anat_space/pRF/ROI/In_surface/"

strPathOrig=$PWD

olvp_prct=(1 "50" "75" "90")

# -----------------------------------------------------------------------------
for olvpid in {1..3}; do
# Get all the pRF OC ROI
cd ${volPth}
# Get all the pRF overlay results
pRF_oc_ROI=( $(ls | grep pRF_results_lroi_nf_ovrlp_mask_${olvp_prct[${olvpid}]}prct | grep .nii.gz) )
numROI=${#pRF_oc_ROI[@]}
numROI=$(($numROI - 1))
echo ${numROI}
# -----------------------------------------------------------------------------
cd ${strPathOrig}

cd ${volPth}rh
# Get all the pRF overlay results
pRF_oc_ROI_rh=( $(ls | grep pRF_results_lroi_nf_ovrlp_mask_${olvp_prct[${olvpid}]}prct | grep .nii.gz) )
# -----------------------------------------------------------------------------
cd ${strPathOrig}

for i in in $(seq 0 $numROI); do
# Get rid of .nii.gz

interp=$(cut -d '.' -f 1 <<< ${pRF_oc_ROI[${i}]})
interp_rh=$(cut -d '.' -f 1 <<< ${pRF_oc_ROI_rh[${i}]})

mri_cor2label \
--i ${volPth}${pRF_oc_ROI[${i}]} \
--surf ${subjID} lh inflated \
--l ${labelPth}${interp}.label \
--id 1



mri_cor2label \
--i ${volPth}rh/${pRF_oc_ROI_rh[${i}]} \
--surf ${subjID} rh inflated \
--l ${labelPth}${interp_rh}.label \
--id 1


done
done


mri_cor2label \
--i ${volPth}stimulus_lroi_nf_roi_comb_reg2fsanat_msk_lh.nii.gz \
--surf ${subjID} lh inflated \
--l ${labelPth}stimulus_lroi_nf_roi_comb_reg2fsanat_msk_lh.label \
--id 1

mri_cor2label \
--i ${volPth}rh/stimulus_lroi_nf_roi_comb_reg2fsanat_msk_rh.nii.gz \
--surf ${subjID} rh inflated \
--l ${labelPth}stimulus_lroi_nf_roi_comb_reg2fsanat_msk_rh.label \
--id 1

end_tme=$(date +%s)
nettme=$(expr $end_tme - $start_tme)
echo " "
echo "-----> Transform vol to label took in $(($nettme / 3600))h:$(($nettme % 3600 / 60))m:$(($nettme % 60))s."
echo " "
