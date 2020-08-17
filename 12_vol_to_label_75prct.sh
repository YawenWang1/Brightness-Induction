#! /bin/bash
# Apply transformation for results from pyprf took in 0h:0m:48s.

start_tme=$(date +%s)
export SUBJECTS_DIR=/media/h/P04/Data/BIDS/sub-02/ses-002/anat
export subjID='sub-02'

# Define all the pRF files
labelPth='/media/h/P04/Data/BIDS/sub-02/ses-002/anat/sub-02/label/'

# volPth="/media/h/P04/Data/BIDS/sub-01/ses-001/func/GLM/pRF/ROI_Anat_space/In_surface/"
# Smoothed version
volPth="/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/Anat_space/pRF/ROI/In_surface/"

strPathOrig=$PWD
# -----------------------------------------------------------------------------
# Get all the pRF OC ROI
cd ${volPth}
# Get all the pRF overlay results
pRF_oc_ROI=( $(ls | grep pRF_results_ovrlp_mask_75prct | grep .nii.gz) )
numROI=${#pRF_oc_ROI[@]}
numROI=$(($numROI - 1))
echo ${numROI}
# -----------------------------------------------------------------------------
cd ${strPathOrig}

cd ${volPth}rh
# Get all the pRF overlay results
pRF_oc_ROI_rh=( $(ls | grep pRF_results_ovrlp_mask_75prct | grep .nii.gz) )
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
--i ${volPth}${pRF_oc_ROI[${i}]} \
--surf ${subjID} lh sphere \
--l ${labelPth}${interp}.sphere.label \
--id 1

mri_cor2label \
--i ${volPth}rh/${pRF_oc_ROI_rh[${i}]} \
--surf ${subjID} rh inflated \
--l ${labelPth}${interp_rh}.label \
--id 1

mri_cor2label \
--i ${volPth}rh/${pRF_oc_ROI_rh[${i}]} \
--surf ${subjID} rh sphere \
--l ${labelPth}${interp_rh}.sphere.label \
--id 1
done


mri_cor2label \
--i ${volPth}stimuli_roi_75prct_ori_reg2fsanat_lh.nii.gz \
--surf ${subjID} lh inflated \
--l ${labelPth}stimuli_roi_75prct_ori_reg2fsanat_lh.label \
--id 1

mri_cor2label \
--i ${volPth}stimuli_roi_75prct_ori_reg2fsanat_lh.nii.gz \
--surf ${subjID} lh sphere \
--l ${labelPth}stimuli_roi_75prct_ori_reg2fsanat_lh.sphere.label \
--id 1

end_tme=$(date +%s)
nettme=$(expr $end_tme - $start_tme)
echo " "
echo "-----> Transform vol to label took in $(($nettme / 3600))h:$(($nettme % 3600 / 60))m:$(($nettme % 60))s."
echo " "
