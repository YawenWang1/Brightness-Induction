#! /bin/bash
# cd to /media/h/P04/Data/S04/Ses01/03_GLM/05_func_reg_averages
# Ctrl click and Alt+shift+Down Arrow
# For inducer's luminance going up
export output='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/BI/fslmeants_pt005'
export maskpth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/Anat_space/Masks/final/fun_space/'
mkdir ${output}

cd /media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/BI/BI_fun_01_MoCo_Dist_Corr_Coreg_7EV.feat
#-----------------------------------------------------------------------_inter--------
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_01_center_pt005_meants_tc.txt -m ${maskpth}center_pt005.nii.gz --showall

fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_01_background_pt005_meants_tc.txt -m ${maskpth}background_pt005.nii.gz --showall



#------------filtered_func_data.nii.gz -o ${output}/fun_02_v2_center_pt005_up_meants_tc.txt -m /media/h/P04/Data/BIDS/sub-01/ses-001/func/GLM/pRF/ROI_fun_space/up_v2_centre.nii.gz --showall
cd /media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/BI/BI_fun_02_MoCo_Dist_Corr_Coreg_7EV.feat
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_02_center_pt005_meants_tc.txt -m ${maskpth}center_pt005.nii.gz --showall

fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_02_background_pt005_meants_tc.txt -m ${maskpth}background_pt005.nii.gz --showall


#-----------------------------------------------------------------------_inter--------
cd /media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/BI/BI_fun_03_MoCo_Dist_Corr_Coreg_7EV.feat

fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_03_center_pt005_meants_tc.txt -m ${maskpth}center_pt005.nii.gz --showall

fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_03_background_pt005_meants_tc.txt -m ${maskpth}background_pt005.nii.gz --showall
#-----------------------------------------------------------------------_inter--------
cd /media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/BI/BI_fun_04_MoCo_Dist_Corr_Coreg_7EV.feat

fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_04_center_pt005_meants_tc.txt -m ${maskpth}center_pt005.nii.gz --showall

fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_04_background_pt005_meants_tc.txt -m ${maskpth}background_pt005.nii.gz --showall



#-----------------------------------------------------------------------_inter--------
cd /media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/BI/BI_fun_05_MoCo_Dist_Corr_Coreg_7EV.feat

fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_05_center_pt005_meants_tc.txt -m ${maskpth}center_pt005.nii.gz --showall

fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_05_background_pt005_meants_tc.txt -m ${maskpth}background_pt005.nii.gz --showall


#-----------------------------------------------------------------------_inter--------
cd /media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/BI/BI_fun_06_MoCo_Dist_Corr_Coreg_7EV.feat

fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_06_center_pt005_meants_tc.txt -m ${maskpth}center_pt005.nii.gz --showall

fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_06_background_pt005_meants_tc.txt -m ${maskpth}background_pt005.nii.gz --showall
