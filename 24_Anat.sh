#! /bin/bash
################################################################################

anatPth='/media/h/P04/Data/BIDS/sub-02/ses-002/anat/'
Img=${anatPth}msub-02_ses-002_acq-MP2RAGE_run-1_mod-UNI_T1w_brain
echo "-----> N4 Bias correction for UNI brain---------."
echo ""
## Run N4 many times
for i in {1..3}; do
    if [ "$i" -eq "1" ]; then
        N4BiasFieldCorrection \
        --image-dimensionality 3 \
        --shrink-factor 4 \
        --rescale-intensities 1 \
        --bspline-fitting [200] \
        --convergence [200x200x200x200,1e-9] \
        --input-image ${Img}.nii.gz \
        --output ${Img}_N4.nii.gz
    else
        N4BiasFieldCorrection \
        --image-dimensionality 3 \
        --shrink-factor 2 \
        --rescale-intensities 1 \
        --bspline-fitting [200] \
        --convergence [50x50x50x50,1e-9] \
        --input-image ${Img}.nii.gz \
        --output ${Img}_N4.nii.gz
    fi

done
