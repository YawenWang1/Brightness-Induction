#! /bin/bash

fslmeants -i All_In_One_SqrUniBckgrd_410_NA.nii.gz -o v1_center_sqruni_meants.txt -m ../06_Aspace/ROI_masks_glm/func_space/func_benson14atlas.V1_ctnr_centre_P02_S03_Ana_blkgrd_mask.nii.gz --showall
fslmeants -i All_In_One_SqrUniBckgrd_410_NA.nii.gz -o v2_center_sqruni_meants.txt -m ../06_Aspace/ROI_masks_glm/func_space/func_benson14atlas.V2_ctnr_centre_P02_S03_Ana_blkgrd_mask.nii.gz --showall
fslmeants -i All_In_One_SqrUniBckgrd_410_NA.nii.gz -o v3_center_sqruni_meants.txt -m ../06_Aspace/ROI_masks_glm/func_space/func_benson14atlas.V3_ctnr_centre_P02_S03_Ana_blkgrd_mask.nii.gz --showall
fslmeants -i All_In_One_SqrTextBckgrd_410_NA.nii.gz -o v3_center_sqrtextbckgrd_meants.txt -m ../06_Aspace/ROI_masks_glm/func_space/func_benson14atlas.V3_ctnr_centre_P02_S03_Ana_blkgrd_mask.nii.gz --showall
fslmeants -i All_In_One_SqrTextBckgrd_410_NA.nii.gz -o v2_center_sqrtextbckgrd_meants.txt -m ../06_Aspace/ROI_masks_glm/func_space/func_benson14atlas.V2_ctnr_centre_P02_S03_Ana_blkgrd_mask.nii.gz --showall
fslmeants -i All_In_One_SqrTextBckgrd_410_NA.nii.gz -o v1_center_sqrtextbckgrd_meants.txt -m ../06_Aspace/ROI_masks_glm/func_space/func_benson14atlas.V1_ctnr_centre_P02_S03_Ana_blkgrd_mask.nii.gz --showall
fslmeants -i All_In_One_TextBckgrd_410_NA.nii.gz -o v1_center_textbckgrd_meants.txt -m ../06_Aspace/ROI_masks_glm/func_space/func_benson14atlas.V1_ctnr_centre_P02_S03_Ana_blkgrd_mask.nii.gz --showall
fslmeants -i All_In_One_TextBckgrd_410_NA.nii.gz -o v2_center_textbckgrd_meants.txt -m ../06_Aspace/ROI_masks_glm/func_space/func_benson14atlas.V2_ctnr_centre_P02_S03_Ana_blkgrd_mask.nii.gz --showall
fslmeants -i All_In_One_TextBckgrd_410_NA.nii.gz -o v3_center_textbckgrd_meants.txt -m ../06_Aspace/ROI_masks_glm/func_space/func_benson14atlas.V3_ctnr_centre_P02_S03_Ana_blkgrd_mask.nii.gz --showall
