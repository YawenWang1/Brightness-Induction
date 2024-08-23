#! /bin/bash
# Apply transformation for results from pyprf took in 0h:0m:48s.

start_tme=$(date +%s)

# Define all the pRF files
export SUBJECTS_DIR=/media/g/P04/Data/BIDS/sub-12/ses-002/anat/fs
export varea_namearray=(1 "V1" "V2v" "V2d" "V3v" "V3d" "V2" "V3")
# export varea_namearray=(1 "V1" "V2" "V3")
#
subjID='sub-12'
session_id='ses-002'
Pth='/media/g/P04/Data/BIDS/'
labelPth=${Pth}${subjID}/${session_id}/anat/fs/sub-12/label/
outpth=${Pth}${subjID}/${session_id}/anat/fs/sub-12/label/nii/
fun_Pth=${Pth}${subjID}/${session_id}/func/
tSNRPth_ses02=${fun_Pth}tSNR/
mskPth=${fun_Pth}GLM/Anat_space/Masks/
tmpOpt=${mskPth}/tmp/
mkdir ${tmpOpt}
mkdir ${outpth}
mkdir ${tSNRPth_ses02}ROI

strPathOrig=$PWD

olvp_prct=(1 "50" "75" "90")

# Get all the pRF OC ROI
cd ${labelPth}
# Get all the pRF overlay results
pRF_oc_ROI=( $(ls | grep pRF_results_ovrlp_ctnr | grep _lh.label) )
numROI=${#pRF_oc_ROI[@]}
numROI=$(($numROI - 1))
echo ${numROI}
# -----------------------------------------------------------------------------
# Get all the pRF overlay results
pRF_oc_ROI_rh=( $(ls | grep pRF_results_ovrlp_ctnr | grep _rh.label) )
# -----------------------------------------------------------------------------
cd ${strPathOrig}

for i in in $(seq 0 $numROI); do
# Get rid of .ni
# Get all the pRF overlay results
interp=$(cut -d '.' -f 1 <<< ${pRF_oc_ROI[${i}]})
interp_rh=$(cut -d '.' -f 1 <<< ${pRF_oc_ROI_rh[${i}]})

interp_01=$(cut -d '_' -f 4,5 <<< ${pRF_oc_ROI[${i}]})
interp_rh_01=$(cut -d '_' -f 4,5 <<< ${pRF_oc_ROI_rh[${i}]})

currFile_lh=${labelPth}${pRF_oc_ROI[${i}]}
currFile_rh=${labelPth}${pRF_oc_ROI_rh[${i}]}

echo ${currFile_lh}
echo "=========================================================="
echo ${currFile_rh}
echo "=========================================================="
mri_label2vol --label ${currFile_lh} --identity --fill-ribbon --subject ${subjID} --hemi lh --fillthresh 0.5 --o ${outpth}${interp}.nii.gz
mri_label2vol --label ${currFile_rh} --identity --fill-ribbon --subject ${subjID} --hemi rh --fillthresh 0.5 --o ${outpth}${interp_rh}.nii.gz

for vid in $(seq 1 7); do
  fslmaths ${outpth}${interp}.nii.gz -mul ${mskPth}sub-12_ses-002_lh_${varea_namearray[${vid}]}.nii.gz ${tmpOpt}${interp_01}_${varea_namearray[${vid}]}_lh.nii.gz
  fslmaths ${outpth}${interp_rh}.nii.gz -mul ${mskPth}sub-12_ses-002_rh_${varea_namearray[${vid}]}.nii.gz ${tmpOpt}${interp_rh_01}_${varea_namearray[${vid}]}_rh.nii.gz



done


done



end_tme=$(date +%s)
nettme=$(expr $end_tme - $start_tme)
echo " "
echo "-----> Transform label to nii files took in $(($nettme / 3600))h:$(($nettme % 3600 / 60))m:$(($nettme % 60))s."
echo " "
