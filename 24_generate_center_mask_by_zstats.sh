#! /bin/bash

#-------------------------------------------------------------------------------
fslmaths benson14atlas.V1_ctnr_centre_P02_S03_Ana_blkgrd_sqrtextbackgrd_zstat1.nii.gz -thr 1.47 -bin benson14atlas.V1_ctnr_centre_P02_S03_Ana_blkgrd_mask.nii.gz
fslmaths benson14atlas.V2_ctnr_centre_P02_S03_Ana_blkgrd_sqrtextbackgrd_zstat1.nii.gz -thr 1.47 -bin benson14atlas.V2_ctnr_centre_P02_S03_Ana_blkgrd_mask.nii.gz
fslmaths benson14atlas.V3_ctnr_centre_P02_S03_Ana_blkgrd_sqrtextbackgrd_zstat1.nii.gz -thr 1.47 -bin benson14atlas.V3_ctnr_centre_P02_S03_Ana_blkgrd_mask.nii.gz

#And then transfer it to functional space 
