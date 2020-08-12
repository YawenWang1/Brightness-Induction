#! /bin/bash
# cd to /media/h/P04/Data/S04/Ses01/03_GLM/05_func_reg_averages
# Ctrl click and Alt+shift+Down Arrow
# For inducer's luminance going up
export output='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/Anat_space/fslmeants'
export maskpth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/Anat_space/Masks/final/fun_space/'
mkdir ${output}

cd /media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/BI/BI_fun_01_MoCo_Dist_Corr_Coreg.feat
#-----------------------------------------------------------------------_inter--------
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_01_v2_center_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v2_centre_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_01_v1_center_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v1_centre_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_01_v3_center_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v3_centre_reg2run.nii.gz --showall

fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_01_v1_background_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v1_background_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_01_v2_background_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v2_background_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_01_v3_background_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v3_background_reg2run.nii.gz --showall

fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_01_v1_edge_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v1_edge_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_01_v2_edge_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v2_edge_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_01_v3_edge_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v3_edge_reg2run.nii.gz --showall


fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_01_v2_center_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v2_centre_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_01_v1_center_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v1_centre_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_01_v3_center_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v3_centre_reg2run.nii.gz --showall

fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_01_v1_background_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v1_background_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_01_v2_background_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v2_background_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_01_v3_background_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v3_background_reg2run.nii.gz --showall

fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_01_v1_edge_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v1_edge_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_01_v2_edge_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v2_edge_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_01_v3_edge_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v3_edge_reg2run.nii.gz --showall


#------------filtered_func_data.nii.gz -o ${output}/fun_02_v2_center_up_meants_tc.txt -m /media/h/P04/Data/BIDS/sub-01/ses-001/func/GLM/pRF/ROI_fun_space/up_v2_centre.nii.gz --showall
cd /media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/BI/BI_fun_02_MoCo_Dist_Corr_Coreg.feat

fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_02_v2_center_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v2_centre_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_02_v1_center_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v1_centre_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_02_v3_center_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v3_centre_reg2run.nii.gz --showall

fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_02_v1_background_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v1_background_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_02_v2_background_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v2_background_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_02_v3_background_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v3_background_reg2run.nii.gz --showall

fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_02_v1_edge_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v1_edge_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_02_v2_edge_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v2_edge_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_02_v3_edge_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v3_edge_reg2run.nii.gz --showall


fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_02_v2_center_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v2_centre_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_02_v1_center_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v1_centre_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_02_v3_center_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v3_centre_reg2run.nii.gz --showall

fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_02_v1_background_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v1_background_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_02_v2_background_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v2_background_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_02_v3_background_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v3_background_reg2run.nii.gz --showall

fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_02_v1_edge_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v1_edge_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_02_v2_edge_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v2_edge_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_02_v3_edge_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v3_edge_reg2run.nii.gz --showall

#-----------------------------------------------------------------------_inter--------
cd /media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/BI/BI_fun_03_MoCo_Dist_Corr_Coreg.feat

fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_03_v2_center_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v2_centre_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_03_v1_center_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v1_centre_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_03_v3_center_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v3_centre_reg2run.nii.gz --showall

fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_03_v1_background_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v1_background_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_03_v2_background_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v2_background_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_03_v3_background_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v3_background_reg2run.nii.gz --showall

fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_03_v1_edge_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v1_edge_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_03_v2_edge_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v2_edge_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_03_v3_edge_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v3_edge_reg2run.nii.gz --showall


fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_03_v2_center_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v2_centre_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_03_v1_center_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v1_centre_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_03_v3_center_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v3_centre_reg2run.nii.gz --showall

fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_03_v1_background_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v1_background_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_03_v2_background_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v2_background_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_03_v3_background_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v3_background_reg2run.nii.gz --showall

fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_03_v1_edge_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v1_edge_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_03_v2_edge_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v2_edge_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_03_v3_edge_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v3_edge_reg2run.nii.gz --showall


#-----------------------------------------------------------------------_inter--------
cd /media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/BI/BI_fun_05_MoCo_Dist_Corr_Coreg.feat

fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_05_v2_center_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v2_centre_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_05_v1_center_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v1_centre_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_05_v3_center_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v3_centre_reg2run.nii.gz --showall

fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_05_v1_background_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v1_background_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_05_v2_background_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v2_background_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_05_v3_background_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v3_background_reg2run.nii.gz --showall

fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_05_v1_edge_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v1_edge_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_05_v2_edge_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v2_edge_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_05_v3_edge_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v3_edge_reg2run.nii.gz --showall


fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_05_v2_center_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v2_centre_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_05_v1_center_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v1_centre_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_05_v3_center_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v3_centre_reg2run.nii.gz --showall

fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_05_v1_background_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v1_background_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_05_v2_background_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v2_background_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_05_v3_background_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v3_background_reg2run.nii.gz --showall

fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_05_v1_edge_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v1_edge_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_05_v2_edge_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v2_edge_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_05_v3_edge_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v3_edge_reg2run.nii.gz --showall


#-----------------------------------------------------------------------_inter--------
cd /media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/BI/BI_fun_06_MoCo_Dist_Corr_Coreg.feat

fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_06_v2_center_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v2_centre_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_06_v1_center_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v1_centre_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_06_v3_center_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v3_centre_reg2run.nii.gz --showall

fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_06_v1_background_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v1_background_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_06_v2_background_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v2_background_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_06_v3_background_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v3_background_reg2run.nii.gz --showall

fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_06_v1_edge_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v1_edge_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_06_v2_edge_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v2_edge_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_06_v3_edge_up_meants_tc.txt -m ${maskpth}sub-02_ses-002_up_zstat_v3_edge_reg2run.nii.gz --showall


fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_06_v2_center_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v2_centre_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_06_v1_center_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v1_centre_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_06_v3_center_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v3_centre_reg2run.nii.gz --showall

fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_06_v1_background_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v1_background_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_06_v2_background_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v2_background_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_06_v3_background_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v3_background_reg2run.nii.gz --showall

fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_06_v1_edge_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v1_edge_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_06_v2_edge_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v2_edge_reg2run.nii.gz --showall
fslmeants -i filtered_func_data.nii.gz -o ${output}/fun_06_v3_edge_down_meants_tc.txt -m ${maskpth}sub-02_ses-002_down_zstat_v3_edge_reg2run.nii.gz --showall
