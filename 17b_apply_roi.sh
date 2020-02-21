#!/bin/bash
#-------------------------------------------------------------------------------
# Define
# strPthIn="/media/h/P04/Data/S04/Ses01/03_GLM/04_ASpace/05_0p8/"
# strPthIn01="/media/h/P04/Data/S04/Ses01/03_GLM/04_ASpace/05_0p8/00_Lum_Up/"
# strPthIn02="/media/h/P04/Data/S04/Ses01/03_GLM/04_ASpace/05_0p8/01_Lum_Down/"
strPthIn="/media/h/P04/Data/S04/Ses01/03_GLM/04_ASpace/06_0p8/"
# strPthIn01="/media/h/P04/Data/S04/Ses01/03_GLM/04_ASpace/00_Lum_Up/0p8/"
strPthIn02="/media/h/P04/Data/S04/Ses01/03_GLM/04_ASpace/01_Lum_Down/0p8/"
# strPthIn02="/media/h/P04/Data/S04/Ses01/03_GLM/04_ASpace/04_up_sub_down/"

# tstatsfile01=${strPthIn01}tstat1_To_brain.nii.gz
# # # Apply ROI to tstats from glm
# # fslmaths ${tstatsfile} -mul V1_Center_95_0p8.nii.gz 0p8_tstats_v1_center_95.nii.gz
# # fslmaths ${tstatsfile} -mul V1_Edge_95_0p8.nii.gz  0p8_tstats_v1_edge_95.nii.gz
# # fslmaths ${tstatsfile} -mul V1_Bckgrd_95_0p8.nii.gz  0p8_tstats_v1_bckgrd_95.nii.gz
# # fslmaths ${tstatsfile} -mul V2_Bckgrd_95_0p8.nii.gz  0p8_tstats_v2_bckgrd_95.nii.gz
# # fslmaths ${tstatsfile} -mul V2_Edge_95_0p8.nii.gz  0p8_tstats_v2_edge_95.nii.gz
# # fslmaths ${tstatsfile} -mul V2_Center_95_0p8.nii.gz 0p8_tstats_v2_center_95.nii.gz
# # fslmaths ${tstatsfile} -mul V3_Center_95_0p8.nii.gz 0p8_tstats_v3_center_95.nii.gz
# # fslmaths ${tstatsfile} -mul V3_Edge_95_0p8.nii.gz  0p8_tstats_v3_edge_95.nii.gz
# # fslmaths ${tstatsfile} -mul V3_Bckgrd_95_0p8.nii.gz  0p8_tstats_v3_bckgrd_95.nii.gz
#
# fslmaths ${tstatsfile01} -mul ${strPthIn}V1_Center_95_0p8.nii.gz ${strPthIn01}0p8_tstats_up_v1_center_95.nii.gz
# fslmaths ${tstatsfile01} -mul ${strPthIn}V1_Edge_95_0p8.nii.gz  ${strPthIn01}0p8_tstats_up_v1_edge_95.nii.gz
# fslmaths ${tstatsfile01} -mul ${strPthIn}V1_Bckgrd_95_0p8.nii.gz ${strPthIn01}0p8_tstats_up_v1_bckgrd_95.nii.gz
# fslmaths ${tstatsfile01} -mul ${strPthIn}V2_Bckgrd_95_0p8.nii.gz  ${strPthIn01}0p8_tstats_up_v2_bckgrd_95.nii.gz
# fslmaths ${tstatsfile01} -mul ${strPthIn}V2_Edge_95_0p8.nii.gz  ${strPthIn01}0p8_tstats_up_v2_edge_95.nii.gz
# fslmaths ${tstatsfile01} -mul ${strPthIn}V2_Center_95_0p8.nii.gz ${strPthIn01}0p8_tstats_up_v2_center_95.nii.gz
# fslmaths ${tstatsfile01} -mul ${strPthIn}V3_Center_95_0p8.nii.gz ${strPthIn01}0p8_tstats_up_v3_center_95.nii.gz
# fslmaths ${tstatsfile01} -mul ${strPthIn}V3_Edge_95_0p8.nii.gz  ${strPthIn01}0p8_tstats_up_v3_edge_95.nii.gz
# fslmaths ${tstatsfile01} -mul ${strPthIn}V3_Bckgrd_95_0p8.nii.gz  ${strPthIn01}0p8_tstats_up_v3_bckgrd_95.nii.gz

tstatsfile02=${strPthIn02}tstat1_To_brain.nii.gz

fslmaths ${tstatsfile02} -mul ${strPthIn}V1_Center_95_0p8.nii.gz ${strPthIn02}0p8_tstats_down_v1_center_95.nii.gz
fslmaths ${tstatsfile02} -mul ${strPthIn}V1_Edge_95_0p8.nii.gz  ${strPthIn02}0p8_tstats_down_v1_edge_95.nii.gz
fslmaths ${tstatsfile02} -mul ${strPthIn}V1_Bckgrd_95_0p8.nii.gz ${strPthIn02}0p8_tstats_down_v1_bckgrd_95.nii.gz
fslmaths ${tstatsfile02} -mul ${strPthIn}V2_Bckgrd_95_0p8.nii.gz  ${strPthIn02}0p8_tstats_down_v2_bckgrd_95.nii.gz
fslmaths ${tstatsfile02} -mul ${strPthIn}V2_Edge_95_0p8.nii.gz  ${strPthIn02}0p8_tstats_down_v2_edge_95.nii.gz
fslmaths ${tstatsfile02} -mul ${strPthIn}V2_Center_95_0p8.nii.gz ${strPthIn02}0p8_tstats_down_v2_center_95.nii.gz
fslmaths ${tstatsfile02} -mul ${strPthIn}V3_Center_95_0p8.nii.gz ${strPthIn02}0p8_tstats_down_v3_center_95.nii.gz
fslmaths ${tstatsfile02} -mul ${strPthIn}V3_Edge_95_0p8.nii.gz  ${strPthIn02}0p8_tstats_down_v3_edge_95.nii.gz
fslmaths ${tstatsfile02} -mul ${strPthIn}V3_Bckgrd_95_0p8.nii.gz  ${strPthIn02}0p8_tstats_down_v3_bckgrd_95.nii.gz



# # Apply ROI to beta value from glm
# pefile=${strPthIn}pe1_To_brain.nii.gz
# fslmaths ${pefile} -mul ${strPthIn}V1_Center_95_0p8.nii.gz ${strPthIn}0p8_pe_v1_center_95.nii.gz
# fslmaths ${pefile} -mul ${strPthIn}V1_Edge_95_0p8.nii.gz  ${strPthIn}0p8_pe_v1_edge_95.nii.gz
# fslmaths ${pefile} -mul ${strPthIn}V1_Bckgrd_95_0p8.nii.gz ${strPthIn}0p8_pe_v1_bckgrd_95.nii.gz
# fslmaths ${pefile} -mul ${strPthIn}V2_Bckgrd_95_0p8.nii.gz  ${strPthIn}0p8_pe_v2_bckgrd_95.nii.gz
# fslmaths ${pefile} -mul ${strPthIn}V2_Edge_95_0p8.nii.gz  ${strPthIn}0p8_pe_v2_edge_95.nii.gz
# fslmaths ${pefile} -mul ${strPthIn}V2_Center_95_0p8.nii.gz ${strPthIn}0p8_pe_v2_center_95.nii.gz
# fslmaths ${pefile} -mul ${strPthIn}V3_Center_95_0p8.nii.gz ${strPthIn}0p8_pe_v3_center_95.nii.gz
# fslmaths ${pefile} -mul ${strPthIn}V3_Edge_95_0p8.nii.gz  ${strPthIn}0p8_pe_v3_edge_95.nii.gz
# fslmaths ${pefile} -mul ${strPthIn}V3_Bckgrd_95_0p8.nii.gz  ${strPthIn}0p8_pe_v3_bckgrd_95.nii.gz
# #



# # Apply ROI to beta value from glm
# pefile01=${strPthIn01}pe1_To_brain.nii.gz
# fslmaths ${pefile01} -mul ${strPthIn}V1_Center_95_0p8.nii.gz ${strPthIn01}0p8_pe_up_v1_center_95.nii.gz
# fslmaths ${pefile01} -mul ${strPthIn}V1_Edge_95_0p8.nii.gz  ${strPthIn01}0p8_pe_up_v1_edge_95.nii.gz
# fslmaths ${pefile01} -mul ${strPthIn}V1_Bckgrd_95_0p8.nii.gz ${strPthIn01}0p8_pe_up_v1_bckgrd_95.nii.gz
# fslmaths ${pefile01} -mul ${strPthIn}V2_Bckgrd_95_0p8.nii.gz  ${strPthIn01}0p8_pe_up_v2_bckgrd_95.nii.gz
# fslmaths ${pefile01} -mul ${strPthIn}V2_Edge_95_0p8.nii.gz  ${strPthIn01}0p8_pe_up_v2_edge_95.nii.gz
# fslmaths ${pefile01} -mul ${strPthIn}V2_Center_95_0p8.nii.gz ${strPthIn01}0p8_pe_up_v2_center_95.nii.gz
# fslmaths ${pefile01} -mul ${strPthIn}V3_Center_95_0p8.nii.gz ${strPthIn01}0p8_pe_up_v3_center_95.nii.gz
# fslmaths ${pefile01} -mul ${strPthIn}V3_Edge_95_0p8.nii.gz  ${strPthIn01}0p8_pe_up_v3_edge_95.nii.gz
# fslmaths ${pefile01} -mul ${strPthIn}V3_Bckgrd_95_0p8.nii.gz  ${strPthIn01}0p8_pe_up_v3_bckgrd_95.nii.gz

pefile02=${strPthIn02}pe1_To_brain.nii.gz


fslmaths ${pefile02} -mul ${strPthIn}V1_Center_95_0p8.nii.gz ${strPthIn02}0p8_pe_down_v1_center_95.nii.gz
fslmaths ${pefile02} -mul ${strPthIn}V1_Edge_95_0p8.nii.gz  ${strPthIn02}0p8_pe_down_v1_edge_95.nii.gz
fslmaths ${pefile02} -mul ${strPthIn}V1_Bckgrd_95_0p8.nii.gz ${strPthIn02}0p8_pe_down_v1_bckgrd_95.nii.gz
fslmaths ${pefile02} -mul ${strPthIn}V2_Bckgrd_95_0p8.nii.gz  ${strPthIn02}0p8_pe_down_v2_bckgrd_95.nii.gz
fslmaths ${pefile02} -mul ${strPthIn}V2_Edge_95_0p8.nii.gz  ${strPthIn02}0p8_pe_down_v2_edge_95.nii.gz
fslmaths ${pefile02} -mul ${strPthIn}V2_Center_95_0p8.nii.gz ${strPthIn02}0p8_pe_down_v2_center_95.nii.gz
fslmaths ${pefile02} -mul ${strPthIn}V3_Center_95_0p8.nii.gz ${strPthIn02}0p8_pe_down_v3_center_95.nii.gz
fslmaths ${pefile02} -mul ${strPthIn}V3_Edge_95_0p8.nii.gz  ${strPthIn02}0p8_pe_down_v3_edge_95.nii.gz
fslmaths ${pefile02} -mul ${strPthIn}V3_Bckgrd_95_0p8.nii.gz  ${strPthIn02}0p8_pe_down_v3_bckgrd_95.nii.gz
