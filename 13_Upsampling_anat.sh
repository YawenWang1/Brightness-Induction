#!/bin/bash
# This script is for unsamp;ing 002_fun_to_fs_InverseWarped and wm from freesurfer
#--------------------------------------------------------------------------------------

# Define all the pRF files
funPth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/Fun_space/'
export Files=(1 "sub-02_ses-001_prf_to_ana_InverseWarped" \
"sub-02_ses-002_fun_to_ana_InverseWarped" \
"sub-02_ses-002_INV2_reg2fun" \
"sub-02_ses-002_T1_recip_brain" \
"sub-02_ses-002_T1_recip_brain_STEDI_n50_s0pt5_r0pt5_g1_N4" \
"sub-02_ses-002_T1_recip_brain_ncrb_reg2fun")
Outpth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/Fun_space/upsampling'
mkdir ${Outpth}

for i in {3..6}; do

  for j in {1..2}; do
      if [ "$j" -eq "1" ]; then
          N4BiasFieldCorrection \
          --image-dimensionality 3 \
          --shrink-factor 4 \
          --rescale-intensities 1 \
          --bspline-fitting [200] \
          --convergence [200x200x200x200,1e-9] \
          --input-image ${funPth}${Files[${i}]}.nii.gz \
          --output ${funPth}${Files[${i}]}_N4.nii.gz \

      else
          N4BiasFieldCorrection \
          --image-dimensionality 3 \
          --shrink-factor 2 \
          --rescale-intensities 1 \
          --bspline-fitting [200] \
          --convergence [50x50x50x50,1e-9] \
          --input-image ${funPth}${Files[${i}]}.nii.gz \
          --output ${funPth}${Files[${i}]}_N4.nii.gz \

      fi

  done

$ANTSPATH/ResampleImage \
3 \
${funPth}${Files[${i}]}_N4.nii.gz \
${Outpth}/${Files[${i}]}_N4_pt4.nii.gz \
0.4x0.4x0.4 \
0 \
3['l'] \
6


done

#
# for i in {1..5}; do
#
# $ANTSPATH/ResampleImage \
# 3 \
# ${funPth}${Files[${i}]}.nii.gz \
# ${Outpth}/${Files[${i}]}_pt4.nii.gz \
# 0.4x0.4x0.4 \
# 0 \
# 3['l'] \
# 6
#
#
# done
