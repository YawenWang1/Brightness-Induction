#! /bin/bash
# Apply transformation for results from pyprf took in 0h:0m:48s.

start_tme=$(date +%s)

# Define all the pRF files
export SUBJECTS_DIR=/media/g/P04/Data/BIDS/sub-12/ses-002/anat/fs
export varea_namearray=(1 "V1" "V2v" "V2d" "V3v" "V3d")
subjID='sub-12'

labelPth='/media/g/P04/Data/BIDS/sub-12/ses-002/anat/fs/sub-12/label/'
outpth='/media/g/P04/Data/BIDS/sub-12/ses-002/func/GLM/Anat_space/Masks/'

mkdir ${outpth}

for i in $(seq 1 5); do
for hemi in {"lh","rh"}; do
  currFile=${labelPth}${hemi}.pRF.${varea_namearray[${i}]}.label
  echo ${currFile}${hemi}.pRF.${varea_namearray}.label
  mri_label2vol --label ${currFile} --identity --fill-ribbon --subject ${subjID} --hemi ${hemi} --fillthresh 0.5 --o ${outpth}sub-12_ses-002_${hemi}_${varea_namearray[${i}]}.nii.gz

done
fslmaths ${outpth}sub-12_ses-002_lh_${varea_namearray[${i}]}.nii.gz -add ${outpth}sub-12_ses-002_rh_${varea_namearray[${i}]}.nii.gz ${outpth}sub-12_ses-002_${varea_namearray[${i}]}.nii.gz
done

fslmaths ${outpth}sub-12_ses-002_lh_V2v.nii.gz -add ${outpth}sub-12_ses-002_lh_V2d.nii.gz ${outpth}sub-12_ses-002_lh_V2.nii.gz
fslmaths ${outpth}sub-12_ses-002_lh_V3v.nii.gz -add ${outpth}sub-12_ses-002_lh_V3d.nii.gz ${outpth}sub-12_ses-002_lh_V3.nii.gz
fslmaths ${outpth}sub-12_ses-002_rh_V2v.nii.gz -add ${outpth}sub-12_ses-002_rh_V2d.nii.gz ${outpth}sub-12_ses-002_rh_V2.nii.gz
fslmaths ${outpth}sub-12_ses-002_rh_V3v.nii.gz -add ${outpth}sub-12_ses-002_rh_V3d.nii.gz ${outpth}sub-12_ses-002_rh_V3.nii.gz

fslmaths ${outpth}sub-12_ses-002_lh_V2.nii.gz -add ${outpth}sub-12_ses-002_rh_V2.nii.gz ${outpth}sub-12_ses-002_V2.nii.gz
fslmaths ${outpth}sub-12_ses-002_lh_V3.nii.gz -add ${outpth}sub-12_ses-002_rh_V3.nii.gz ${outpth}sub-12_ses-002_V3.nii.gz


end_tme=$(date +%s)
nettme=$(expr $end_tme - $start_tme)
echo " "
echo "-----> Transform label to nii files took in $(($nettme / 3600))h:$(($nettme % 3600 / 60))m:$(($nettme % 60))s."
echo " "
