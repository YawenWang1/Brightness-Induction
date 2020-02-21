#! /bin/bash
# cd to /media/h/P04/Data/S04/Ses01/03_GLM/05_func_reg_averages
# Ctrl click and Alt+shift+Down Arrow
# For inducer's luminance going up
#-------------------------------------------------------------------------------
fslmeants -i P04_S03_Lum_up_411_NA.nii.gz -o v2_center_up_meants.txt -m ../SriPlay/ROI_masks/func_space/masks/up_v2_center_msk.nii.gz --showall
fslmeants -i P04_S03_Lum_up_411_NA.nii.gz -o v1_center_up_meants.txt -m ../SriPlay/ROI_masks/func_space/masks/up_v1_center_msk.nii.gz --showall
fslmeants -i P04_S03_Lum_up_411_NA.nii.gz -o v3_center_up_meants.txt -m ../SriPlay/ROI_masks/func_space/masks/up_v3_center_msk.nii.gz --showall
fslmeants -i P04_S03_Lum_up_411_NA.nii.gz -o v3_edge_up_meants.txt -m ../SriPlay/ROI_masks/func_space/masks/up_v3_edge_msk.nii.gz --showall
fslmeants -i P04_S03_Lum_up_411_NA.nii.gz -o v2_edge_up_meants.txt -m ../SriPlay/ROI_masks/func_space/masks/up_v2_edge_msk.nii.gz --showall
fslmeants -i P04_S03_Lum_up_411_NA.nii.gz -o v1_edge_up_meants.txt -m ../SriPlay/ROI_masks/func_space/masks/up_v1_edge_msk.nii.gz --showall
fslmeants -i P04_S03_Lum_up_411_NA.nii.gz -o v1_background_up_meants.txt -m ../SriPlay/ROI_masks/func_space/masks/up_v1_background_msk.nii.gz --showall
fslmeants -i P04_S03_Lum_up_411_NA.nii.gz -o v2_background_up_meants.txt -m ../SriPlay/ROI_masks/func_space/masks/up_v2_background_msk.nii.gz --showall
fslmeants -i P04_S03_Lum_up_411_NA.nii.gz -o v3_background_up_meants.txt -m ../SriPlay/ROI_masks/func_space/masks/up_v3_background_msk.nii.gz --showall
#-------------------------------------------------------------------------------
# For inducer's luminance going down 

fslmeants -i P04_S03_Lum_down_411_NA.nii.gz -o v3_center_down_meants.txt -m ../SriPlay/ROI_masks/func_space/masks/down_v3_center_msk.nii.gz --showall
fslmeants -i P04_S03_Lum_down_411_NA.nii.gz -o v2_center_down_meants.txt -m ../SriPlay/ROI_masks/func_space/masks/down_v2_center_msk.nii.gz --showall
fslmeants -i P04_S03_Lum_down_411_NA.nii.gz -o v1_center_down_meants.txt -m ../SriPlay/ROI_masks/func_space/masks/down_v1_center_msk.nii.gz --showall
fslmeants -i P04_S03_Lum_down_411_NA.nii.gz -o v1_background_down_meants.txt -m ../SriPlay/ROI_masks/func_space/masks/down_v1_background_msk.nii.gz --showall
fslmeants -i P04_S03_Lum_down_411_NA.nii.gz -o v2_background_down_meants.txt -m ../SriPlay/ROI_masks/func_space/masks/down_v2_background_msk.nii.gz --showall
fslmeants -i P04_S03_Lum_down_411_NA.nii.gz -o v3_background_down_meants.txt -m ../SriPlay/ROI_masks/func_space/masks/down_v3_background_msk.nii.gz --showall
fslmeants -i P04_S03_Lum_down_411_NA.nii.gz -o v3_edge_down_meants.txt -m ../SriPlay/ROI_masks/func_space/masks/down_v3_edge_msk.nii.gz --showall
fslmeants -i P04_S03_Lum_down_411_NA.nii.gz -o v2_edge_down_meants.txt -m ../SriPlay/ROI_masks/func_space/masks/down_v2_edge_msk.nii.gz --showall
fslmeants -i P04_S03_Lum_down_411_NA.nii.gz -o v1_edge_down_meants.txt -m ../SriPlay/ROI_masks/func_space/masks/down_v1_edge_msk.nii.gz --showall
