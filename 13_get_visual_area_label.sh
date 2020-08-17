#! /bin/bash
# Get label for occipital cortex
export subjid=sub-02
export SUBJECTS_DIR=/media/h/P04/Data/BIDS/sub-02/ses-002/anat
export roiname_array=(1 "V1" "V2" "V3")
for i in {1..3}
do
mri_cor2label --i ${SUBJECTS_DIR}/${subjid}/surf/rh.benson14_varea.mgz --id ${i} --l rh.benson14varea.${roiname_array[${i}]}.sphere.label --surf ${subjid} rh sphere
done
for i in {1..3}
do
mri_cor2label --i ${SUBJECTS_DIR}/${subjid}/surf/lh.benson14_varea.mgz --id ${i} --l lh.benson14varea.${roiname_array[${i}]}.sphere.label --surf ${subjid} lh sphere
done


mri_cor2label --i ${SUBJECTS_DIR}/${subjid}/surf/rh.benson14_varea.mgz --id ${i} --l rh.benson14varea.${roiname_array[${i}]}.label --surf ${subjid} rh inflated
mri_cor2label --i ${SUBJECTS_DIR}/${subjid}/surf/lh.benson14_varea.mgz --id ${i} --l lh.benson14varea.${roiname_array[${i}]}.label --surf ${subjid} lh inflated
