#! /bin/bash

# Register pRF to anatomy
#--------------------------------------------------------------------------------------

# Define all the pRF files
export SUBJECTS_DIR='/media/h/P04/Data/BIDS/sub-02/ses-002/anat'
export Manat=(1 "sub-02_ses-002_acq-MP2RAGE_run-1_mod-T1_T1w" "sub-02_ses-002_acq-MP2RAGE_run-1_mod-T1_T1w_cps" "sub-02_ses-002_acq-MP2RAGE_run-1_mod-T1_T1w_recip" "sub-02_ses-002_acq-MP2RAGE_run-1_mod-INV2_T1w" \
"sub-02_ses-002_T1_recip_brain_ncrb" "sub-02_ses-002_T1_brain_ncrb")
export OutFun=(1 "sub-02_ses-002_T1_reg2fun" "sub-02_ses-002_T1_cps_reg2fun" "sub-02_ses-002_T1_recip" "sub-02_ses-002_INV2_reg2fun" "sub-02_ses-002_T1_recip_brain_ncrb_reg2fun" "sub-02_ses-002_T1_brain_ncrb_reg2fun")
trfPth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/TRFs/'
anatPth='/media/h/P04/Data/BIDS/sub-02/ses-002/anat/'
funPth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/'
moving_fun=${funPth}sub-02_ses-002_task-BI_acq-EP3D_dir-RL_run-1_echo-1_bold_fixed_dc_template0.nii.gz

# fixed_anat=${anatPth}msub-02_ses-002_acq-MP2RAGE_run-1_mod-UNI_T1w_brain.nii.gz
Outpth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/Fun_space/'
mkdir ${Outpth}

FunOutpth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/fun_space/'

mkdir ${FunOutpth}
FunOutpth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/fun_space/pRF/'
mkdir ${FunOutpth}


for i in {1..6}; do

$ANTSPATH/antsApplyTransforms -d 3 \
-i ${anatPth}${Manat[${i}]}.nii.gz \
-o ${Outpth}${OutFun[${i}]}.nii.gz \
-n LanczosWindowedSinc \
-r ${moving_fun} \
-t [${trfPth}sub-02_ses-002_fun_to_ana_0GenericAffine.mat,1] \
-v

done

funPth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/'
moving_fun=${funPth}sub-02_ses-002_task-BI_acq-EP3D_dir-RL_run-1_echo-1_bold_fixed_dc_template0.nii.gz
trfPth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/TRFs/'

anatPth='/media/h/P04/Data/BIDS/sub-02/ses-002/anat/'
Img=${anatPth}sub-02_ses-002_acq-MP2RAGE_run-1_mod-UNI_T1w_pt4.nii.gz

$ANTSPATH/antsApplyTransforms -d 3 \
-i sub-02_wm_reg2fun.nii.gz \
-o sub-02_wm_ana.nii.gz \
-n GenericLabel \
-r ${Img} \
-t ${trfPth}sub-02_ses-002_fun_to_ana_0GenericAffine.mat \
-v
