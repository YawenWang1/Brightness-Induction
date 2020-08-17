#! /bin/bash

#-------------------------------------------------------------------------------
# Covert zscores to p value
# For each conditon
fslmaths zstat1.nii.gz -ztop zstat1_ztop.nii.gz



# In the end, save a txt file with all the p-threshold :fdr_p_thr.txt

#-------------------------------------------------------------------------------
# Induder's luminance going up
# cd /media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/Anat_space/00_Lum_Up
fslmaths up_zstat1_reg2fsanat.nii.gz -thr 1 -binv up_zstat_mask.nii.gz
#-----------------------------------------------------------------------------------------------------
# cd ../../../01_Lum_Down.gfeat/cope2.feat/stats/
# Induder's luminance going down
cd /media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/Anat_space/01_Lum_Down
fslmaths down_zstat1_reg2fsanat.nii.gz -thr 1 -binv down_zstat_mask.nii.gz


# ------------------------------------------------------------------------------
cd /media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/Anat_space/Masks
# Contrast between Up and Down
fslmaths up_zstat_mask.nii.gz -mul sub-02_ses-002_v3_edge sub-02_ses-002_up_zstat_v3_edge.nii.gz
fslmaths up_zstat_mask.nii.gz -mul sub-02_ses-002_v2_edge sub-02_ses-002_up_zstat_v2_edge.nii.gz
fslmaths up_zstat_mask.nii.gz -mul sub-02_ses-002_v1_edge sub-02_ses-002_up_zstat_v1_edge.nii.gz

fslmaths up_zstat_mask.nii.gz -mul sub-02_ses-002_v3_background sub-02_ses-002_up_zstat_v3_background.nii.gz
fslmaths up_zstat_mask.nii.gz -mul sub-02_ses-002_v2_background sub-02_ses-002_up_zstat_v2_background.nii.gz
fslmaths up_zstat_mask.nii.gz -mul sub-02_ses-002_v1_background sub-02_ses-002_up_zstat_v1_background.nii.gz


fslmaths up_zstat_mask.nii.gz -mul sub-02_ses-002_v3_centre sub-02_ses-002_up_zstat_v3_centre.nii.gz
fslmaths up_zstat_mask.nii.gz -mul sub-02_ses-002_v2_centre sub-02_ses-002_up_zstat_v2_centre.nii.gz
fslmaths up_zstat_mask.nii.gz -mul sub-02_ses-002_v1_centre sub-02_ses-002_up_zstat_v1_centre.nii.gz

fslmaths down_zstat_mask.nii.gz -mul sub-02_ses-002_v3_edge sub-02_ses-002_down_zstat_v3_edge.nii.gz
fslmaths down_zstat_mask.nii.gz -mul sub-02_ses-002_v2_edge sub-02_ses-002_down_zstat_v2_edge.nii.gz
fslmaths down_zstat_mask.nii.gz -mul sub-02_ses-002_v1_edge sub-02_ses-002_down_zstat_v1_edge.nii.gz

fslmaths down_zstat_mask.nii.gz -mul sub-02_ses-002_v3_background sub-02_ses-002_down_zstat_v3_background.nii.gz
fslmaths down_zstat_mask.nii.gz -mul sub-02_ses-002_v2_background sub-02_ses-002_down_zstat_v2_background.nii.gz
fslmaths down_zstat_mask.nii.gz -mul sub-02_ses-002_v1_background sub-02_ses-002_down_zstat_v1_background.nii.gz


fslmaths down_zstat_mask.nii.gz -mul sub-02_ses-002_v3_centre sub-02_ses-002_down_zstat_v3_centre.nii.gz
fslmaths down_zstat_mask.nii.gz -mul sub-02_ses-002_v2_centre sub-02_ses-002_down_zstat_v2_centre.nii.gz
fslmaths down_zstat_mask.nii.gz -mul sub-02_ses-002_v1_centre sub-02_ses-002_down_zstat_v1_centre.nii.gz

fslmaths down_zstat_mask.nii.gz -mul sub-02_ses-002_v3 sub-02_ses-002_down_zstat_v3.nii.gz
fslmaths down_zstat_mask.nii.gz -mul sub-02_ses-002_v2 sub-02_ses-002_down_zstat_v2.nii.gz
fslmaths down_zstat_mask.nii.gz -mul sub-02_ses-002_v1 sub-02_ses-002_down_zstat_v1.nii.gz


fslmaths up_zstat_mask.nii.gz -mul sub-02_ses-002_v3 sub-02_ses-002_up_zstat_v3.nii.gz
fslmaths up_zstat_mask.nii.gz -mul sub-02_ses-002_v2 sub-02_ses-002_up_zstat_v2.nii.gz
fslmaths up_zstat_mask.nii.gz -mul sub-02_ses-002_v1 sub-02_ses-002_up_zstat_v1.nii.gz

#-------------------------------------------------------------------------------
