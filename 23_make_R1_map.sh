#! /bin/bash

export FSLOUTPUTTYPE=NIFTI

fslmaths $1 \
-div 1e3 -recip -mul 1e3 -uthr 4095 \
${1%.*}_recip.nii
