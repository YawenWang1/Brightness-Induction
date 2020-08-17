#! /bin/bash
# Apply transformation for results from pyprf took in 0h:0m:48s.

start_tme=$(date +%s)

# Define all the pRF files
export SUBJECTS_DIR=/media/h/P04/Data/BIDS/sub-02/ses-001/anat/MPRAGE
export prf_namearray=(1 "polar_angle" "PE_01" "eccentricity" "R2" "SD" "x_pos" "y_pos")

anatPth='/media/h/P04/Data/BIDS/sub-02/ses-001/anat/sub-02/mri/nii/'
trfPth='/media/h/P04/Data/BIDS/sub-02/ses-001/func/TRFs/'
prfPth='/media/h/P04/Data/BIDS/sub-02/ses-001/func/GLM/pRF/Anat_space/'

# Move all the prf to surface (left and right hemisphere)
prfsrfOptPth='/media/h/P04/Data/BIDS/sub-02/ses-001/func/GLM/pRF/Anat_space/In_surface/'
mkdir ${prfsrfOptPth}
subjID='sub-02'


strPathOrig=$PWD
# -----------------------------------------------------------------------------
# Get all the pRF results
cd ${prfPth}
# Get all the pRF overlay results
#pRF_results_overlay=( $(ls | grep pRF_resultspRF_ | grep .nii.gz) )
pRF_results_overlay=( $(ls | grep .nii.gz) )

numpRF=${#pRF_results_overlay[@]}
numpRF=$(($numpRF - 1))
echo ${numpRF}
# -----------------------------------------------------------------------------
cd ${strPathOrig}


for hemi in {"lh","rh"}; do
for i in $(seq 0 $numpRF); do

  # Get the name of the current prf roi
  interp01=$(cut -d '.' -f 1 <<< ${pRF_results_overlay[${i}]})
  # interp02=$(cut -d '_' -f 7,8 <<< ${interp01})

  # interp02=$(cut -d '_' -f 1,2,3,4,7,8 <<< ${interp01})

  mri_vol2surf \
  --mov ${prfPth}${pRF_results_overlay[${i}]} \
  --regheader ${subjID} \
  --hemi ${hemi} \
  --o ${prfsrfOptPth}${interp01}_${hemi}.nii.gz \
  --interp nearest
done
done
end_tme=$(date +%s)
nettme=$(expr $end_tme - $start_tme)
echo " "
echo "-----> Apply transformation for results from pyprf took in $(($nettme / 3600))h:$(($nettme % 3600 / 60))m:$(($nettme % 60))s."
echo " "
