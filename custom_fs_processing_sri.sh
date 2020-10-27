# FREESURFER_HOME='/usr/local/freesurfer'
# source $FREESURFER_HOME/SetUpFreeSurfer.sh
# export OMP_NUM_THREADS=16

export SUBJECTS_DIR=/media/h/P04/Data/BIDS/sub-02/ses-002/anat
subject=sub-02
n_cores=16

# Input volumes
# UNI image after spm
T1winput=${SUBJECTS_DIR}/msub-02_ses-002_acq-MP2RAGE_run-1_mod-UNI_T1w_brain.nii.gz
# None skull T1
T1input=${SUBJECTS_DIR}/sub-02_ses-002_acq-MP2RAGE_run-1_mod-T1_brain.nii.gz

mri_folder=${SUBJECTS_DIR}/${subject}/mri
surf_folder=${SUBJECTS_DIR}/${subject}/surf
scripts_folder=${SUBJECTS_DIR}/${subject}/scripts

expert=${SUBJECTS_DIR}/expert.opts

# Generate FreeSurfer folder for subject
echo "--------------------------------------------------------------------------------------------------------"
echo "Running FreeSurfer analysis for ${subject}, will take a while..."
echo "--------------------------------------------------------------------------------------------------------"
recon-all -i $T1winput -subjid ${subject}

# Make input volume compatible for FreeSurfer pipeline
mri_convert $T1input ${mri_folder}/t1_mp2rage.mgz --conform_min
mri_convert ${mri_folder}/orig/001.mgz ${mri_folder}/orig.mgz --conform_min
cp ${mri_folder}/orig.mgz ${mri_folder}/rawavg.mgz

mri_add_xform_to_header -c ${mri_folder}/transforms/talairach.xfm ${mri_folder}/orig.mgz ${mri_folder}/orig.mgz
mri_add_xform_to_header -c ${mri_folder}/transforms/talairach.xfm ${mri_folder}/t1_mp2rage.mgz ${mri_folder}/t1_mp2rage.mgz

# Initial Recon-all Steps
recon-all -subjid ${subject} -talairach -nuintensitycor -normalization -hires -expert $expert -parallel -openmp ${n_cores}

# Generate brain mask
mri_convert ${mri_folder}/T1.mgz ${mri_folder}/brainmask.mgz
mri_em_register -mask ${mri_folder}/brainmask.mgz ${mri_folder}/nu.mgz $FREESURFER_HOME/average/RB_all_2016-05-10.vc700.gca ${mri_folder}/transforms/talairach_with_skull.lta

recon-all -subjid ${subject} -skullstrip -clean-bm -no-wsgcaatlas -hires -parallel -openmp ${n_cores}

# Call recon-all to run "-autorecon2" stage
recon-all -subjid ${subject} -autorecon2 -hires -parallel -openmp ${n_cores}

# Backup first "mris_make_surfaces" pass output
# Didn't manage to copy
cp ${surf_folder}/lh.pial ${surf_folder}/lh.woT2.pial
cp ${surf_folder}/rh.pial ${surf_folder}/rh.woT2.pial

cp ${surf_folder}/lh.thickness ${surf_folder}/lh.woT2.thickness
cp ${surf_folder}/rh.thickness ${surf_folder}/rh.woT2.thickness

# Intermediate recon-all steps. Inflation to sphere runs serials as parallel consumes to much memory..
recon-all -subjid ${subject} -sphere -hires -openmp ${n_cores}
recon-all -subjid ${subject} -surfreg -jacobian_white -avgcurv -cortparc -hires -parallel -openmp ${n_cores}

# Normalize T1 input volume using wm mask
mri_convert ${mri_folder}/t1_mp2rage.mgz ${mri_folder}/t1_mp2rage_tmp.nii.gz
mri_convert ${mri_folder}/wm.mgz ${mri_folder}/wm.nii.gz
fslmaths ${mri_folder}/wm.nii.gz -bin ${mri_folder}/wm.nii.gz
wmMeanT2=`fsl5.0-fslstats ${mri_folder}/t1_mp2rage_tmp.nii.gz -k ${mri_folder}/wm.nii.gz -M`
fsl5.0-fslmaths ${mri_folder}/t1_mp2rage_tmp.nii.gz -div $wmMeanT2 -mul 57 ${mri_folder}/t1_mp2rage_tmp.nii.gz -odt float
mri_convert ${mri_folder}/t1_mp2rage_tmp.nii.gz ${mri_folder}/t1_mp2rage.mgz
rm ${mri_folder}/t1_mp2rage_tmp.nii.gz

# Write additional parameters for second pass of "mris_make_surfaces" to expert file
echo "mris_make_surfaces -white NOWRITE -nsigma_above 2 -nsigma_below 3 -orig_pial woT2.pial -T1 brain.finalsurfs -T2 ${mri_folder}/t1_mp2rage" >> ${scripts_folder}/expert-options

# Run second pass "mris_make_surfaces" with T1 volume to optimize pial surface placement
recon-all -subjid ${subject} -pial -hires -parallel -openmp ${n_cores}

cp ${surf_folder}/lh.white.preaparc ${surf_folder}/lh.white
cp ${surf_folder}/rh.white.preaparc ${surf_folder}/rh.white

# Don't know why exactly, but have to manually re-compute cortical thickness maps using new pial surface
mris_thickness ${subject} lh lh.wT2.thickness
mris_thickness ${subject} rh rh.wT2.thickness

# Final recon-all steps
recon-all -subjid ${subject} -cortribbon -parcstats -cortparc2 -parcstats2 -cortparc3 -parcstats3 -pctsurfcon -hyporelabel -aparc2aseg -apas2aseg -segstats -wmparc -balabels -hires -parallel -openmp ${n_cores}

echo "--------------------------------------------------------------------------------------------------------"
echo "FreeSurfer analysis for ${subject} done..."
echo "--------------------------------------------------------------------------------------------------------"

#########################################################
# SUBJECTS_DIR=$PWD
#
# for s in {1..9}
# do
# subject=sub${s}
#
# docker run -ti --rm -v /$PWD:/subjects nben/neuropythy atlas --verbose $subject
#
# export subjid=$subject
# export roiname_array=(1 "V1v" "V1d" "V2v" "V2d")
#
# for i in {1..4}
# do
#  mri_cor2label --i ${SUBJECTS_DIR}/${subjid}/surf/lh.wang15_mplbl.mgz --id ${i} --l lh.wang15_mplbl.${roiname_array[${i}]}.label --surf ${subjid} lh inflated
#  mri_cor2label --i ${SUBJECTS_DIR}/${subjid}/surf/rh.wang15_mplbl.mgz --id ${i} --l rh.wang15_mplbl.${roiname_array[${i}]}.label --surf ${subjid} rh inflated
#
# done
#
# mri_mergelabels -i ${SUBJECTS_DIR}/${subjid}/label/lh.wang15_mplbl.V1v.label -i ${SUBJECTS_DIR}/${subjid}/label/lh.wang15_mplbl.V1d.label -o ${SUBJECTS_DIR}/${subjid}/label/lh.wang15_mplbl.V1.label
# mri_mergelabels -i ${SUBJECTS_DIR}/${subjid}/label/lh.wang15_mplbl.V2v.label -i ${SUBJECTS_DIR}/${subjid}/label/lh.wang15_mplbl.V2d.label -o ${SUBJECTS_DIR}/${subjid}/label/lh.wang15_mplbl.V2.label
# mri_mergelabels -i ${SUBJECTS_DIR}/${subjid}/label/rh.wang15_mplbl.V1v.label -i ${SUBJECTS_DIR}/${subjid}/label/rh.wang15_mplbl.V1d.label -o ${SUBJECTS_DIR}/${subjid}/label/rh.wang15_mplbl.V1.label
# mri_mergelabels -i ${SUBJECTS_DIR}/${subjid}/label/rh.wang15_mplbl.V2v.label -i ${SUBJECTS_DIR}/${subjid}/label/rh.wang15_mplbl.V2d.label -o ${SUBJECTS_DIR}/${subjid}/label/rh.wang15_mplbl.V2.label
#
# export roiname_array=(1 "V1" "V2")
#
# for i in {1..2}
# do
#  mri_cor2label --i ${SUBJECTS_DIR}/${subjid}/surf/lh.benson14_varea.mgz --id ${i} --l lh.benson14_varea.${roiname_array[${i}]}.label --surf ${subjid} lh inflated
#  mri_cor2label --i ${SUBJECTS_DIR}/${subjid}/surf/rh.benson14_varea.mgz --id ${i} --l rh.benson14_varea.${roiname_array[${i}]}.label --surf ${subjid} rh inflated
# done
#
# done
# #########################################################
# SUBJECTS_DIR=$PWD

# for s in {1..9}
# do
# # s=1
# subjid=sub${s}
#
# for depth in {0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9} # 0.1 = 90% GM, 0.9 = 10% GM
# do
# #suffix=`echo 1-$depth | bc`
# a=`echo "(1.0-$depth)*100" | bc`
# suffix=`echo ${a%%.*}`
#
# mris_expand -thickness ${SUBJECTS_DIR}/${subjid}/surf/lh.white $depth ${SUBJECTS_DIR}/${subjid}/surf/lh.depth.${suffix}
# mris_expand -thickness ${SUBJECTS_DIR}/${subjid}/surf/rh.white $depth ${SUBJECTS_DIR}/${subjid}/surf/rh.depth.${suffix}
#
# done
#
# done
#
# for s in {1..9}
# do
# subjid=sub${s}
# cp ${SUBJECTS_DIR}/${subjid}/surf/lh.white ${SUBJECTS_DIR}/${subjid}/surf/lh.depth.100
# cp ${SUBJECTS_DIR}/${subjid}/surf/rh.white ${SUBJECTS_DIR}/${subjid}/surf/rh.depth.100
# cp ${SUBJECTS_DIR}/${subjid}/surf/lh.pial ${SUBJECTS_DIR}/${subjid}/surf/lh.depth.0
# cp ${SUBJECTS_DIR}/${subjid}/surf/rh.pial ${SUBJECTS_DIR}/${subjid}/surf/rh.depth.0
# done
#
# for s in {1..9}
# do
# for depth in {-0.4,-0.3,-0.2,-0.1}
# do
# #depth2=`echo -1*$depth | bc`
# #suffix=`echo 1+$depth2 | bc`
# subjid=sub${s}
# a=`echo "(-1.0+$depth)*-100" | bc`
# suffix=`echo ${a%%.*}`
# mris_expand -thickness ${SUBJECTS_DIR}/${subjid}/surf/lh.white $depth ${SUBJECTS_DIR}/${subjid}/surf/lh.depth.${suffix} &
# mris_expand -thickness ${SUBJECTS_DIR}/${subjid}/surf/rh.white $depth ${SUBJECTS_DIR}/${subjid}/surf/rh.depth.${suffix} &
# done
# done
#
# for s in {1..9}
# do
# for depth in {1.1,1.2,1.3} # Pial surface is 0
# do
# #suffix=`echo 1-$depth | bc`
# a=`echo "($depth-1.0)*-100" | bc`
# suffix=`echo ${a%%.*}`
# subjid=sub${s}
# mris_expand -thickness ${SUBJECTS_DIR}/${subjid}/surf/lh.white $depth ${SUBJECTS_DIR}/${subjid}/surf/lh.depth.${suffix} &
# mris_expand -thickness ${SUBJECTS_DIR}/${subjid}/surf/rh.white $depth ${SUBJECTS_DIR}/${subjid}/surf/rh.depth.${suffix} &
#
# done
# done
