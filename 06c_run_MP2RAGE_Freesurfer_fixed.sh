#! /bin/bash

####
# Written by Sriranga Kashyap <kashyap.sriranga@gmail.com>
# Maastricht, 2018-05
####

Usage() {
    echo ""
    echo "${bold}++ Usage: run_MP2RAGE_Freesurfer.sh <subject_id> <stripped T1w> <brain masked T1> <expert options>"
    echo ""
    exit 1
}

if [ $# -eq 0 ]; then
    Usage
elif [ $# -eq 1 ]; then
    Usage
else
    subject_id=$1
    n_cores=16

    # Input volumes
    T1winput=$2
    T1input=$3

    mri_folder=${SUBJECTS_DIR}/${subject_id}/mri
    surf_folder=${SUBJECTS_DIR}/${subject_id}/surf
    scripts_folder=${SUBJECTS_DIR}/${subject_id}/scripts
    expert=$4

    # Generate FreeSurfer folder for subject
    echo "--------------------------------------------------------------------------------------------------------"
    echo "Running FreeSurfer analysis for ${subject_id}, will take a while..."
    echo "--------------------------------------------------------------------------------------------------------"
    recon-all -i $T1winput -s ${subject_id}

    # Do cubic regridding instead of the default linear
    mri_convert \
        ${mri_folder}/orig/001.mgz \
        ${mri_folder}/orig.mgz \
        --conform_min \
        --resample-type cubic

    mri_convert \
        $T1input \
        ${mri_folder}/t1_mp2rage.mgz \
        --conform_min \
        --resample-type cubic

    cp ${mri_folder}/orig.mgz ${mri_folder}/rawavg.mgz

    mri_add_xform_to_header \
        -c ${mri_folder}/transforms/talairach.xfm \
        ${mri_folder}/orig.mgz \
        ${mri_folder}/orig.mgz

    mri_add_xform_to_header \
        -c ${mri_folder}/transforms/talairach.xfm \
        ${mri_folder}/t1_mp2rage.mgz \
        ${mri_folder}/t1_mp2rage.mgz

    # Do the classic recon-all
    recon-all -all -parallel -expert $expert -hires -openmp 10 -s $subject_id

    # Make a fake T2 from the T1map
    mri_convert \
        ${mri_folder}/t1_mp2rage.mgz \
        ${mri_folder}/t1_mp2rage_tmp.nii.gz

    mri_convert \
        ${mri_folder}/wm.mgz \
        ${mri_folder}/wm.nii.gz

    fslmaths \
        ${mri_folder}/wm.nii.gz \
        -bin \
        ${mri_folder}/wm.nii.gz

    wmMeanT1=$(fslstats ${mri_folder}/t1_mp2rage_tmp.nii.gz -k ${mri_folder}/wm.nii.gz -M)

    ### 57 is a constant scaling factor
    fslmaths \
        ${mri_folder}/t1_mp2rage_tmp.nii.gz \
        -div $wmMeanT1 \
        -mul 57 \
        ${mri_folder}/t1_mp2rage_tmp.nii.gz \
        -odt float

    mri_convert \
        ${mri_folder}/t1_mp2rage_tmp.nii.gz \
        ${mri_folder}/t1_mp2rage.mgz

    rm ${mri_folder}/t1_mp2rage_tmp.nii.gz

    # Run a second pass for recon-all for pial optimisation
    echo "mris_make_surfaces -white NOWRITE -nsigma_above 2 -nsigma_below 3 -orig_pial woT2.pial -T1 brain.finalsurfs -T2 ${mri_folder}/t1_mp2rage" >>${scripts_folder}/expert-options

    recon-all -s ${subject_id} -pial -hires -parallel -openmp ${n_cores}

    cp ${surf_folder}/lh.white.preaparc ${surf_folder}/lh.white
    cp ${surf_folder}/rh.white.preaparc ${surf_folder}/rh.white

    mris_thickness ${subject_id} lh lh.wT2.thickness
    mris_thickness ${subject_id} rh rh.wT2.thickness

    # Final recon-all steps
    recon-all -subjid ${subject_id} \
        -cortribbon -parcstats -cortparc2 -parcstats2 -cortparc3 -parcstats3 \
        -pctsurfcon -hyporelabel -aparc2aseg -apas2aseg -segstats -wmparc \
        -balabels -hires -parallel -openmp ${n_cores}

fi
