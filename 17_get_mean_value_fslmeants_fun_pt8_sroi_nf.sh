#! /bin/bash
# cd to /media/g/P04/Data/S04/Ses01/03_GLM/05_func_reg_averages
# Ctrl click and Alt+shift+Down Arrow
# For inducer's luminance going up
export output='/media/g/P04/Data/BIDS/sub-12/ses-002/func/GLM/BI/fslmeants_sroi_nf'
export maskpth='/media/g/P04/Data/BIDS/sub-12/ses-002/func/GLM/Anat_space/Masks/final/fun_space/'
mkdir ${output}
mkdir ${output}/rh
mkdir ${output}/lh
mkdir ${output}/Twosides
for runid in $(seq 1 6); do
  cd /media/g/P04/Data/BIDS/sub-12/ses-002/func/GLM/BI/BI_fun_0${runid}_MoCo_Dist_Corr_Coreg_3EV.feat
  echo "current run is : ${runid}" \\r

  #-----------------------------------------------------------------------_inter--------
  # Left side
  fslmeants -i filtered_func_data.nii.gz -o ${output}/lh/lh_fun_0${runid}_V1_center_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_sroi_nf_lh_V1_centre_reg2run.nii.gz --showall
  fslmeants -i filtered_func_data.nii.gz -o ${output}/lh/lh_fun_0${runid}_V2_center_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_sroi_nf_lh_V2_centre_reg2run.nii.gz --showall
  fslmeants -i filtered_func_data.nii.gz -o ${output}/lh/lh_fun_0${runid}_V3_center_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_sroi_nf_lh_V3_centre_reg2run.nii.gz --showall

  fslmeants -i filtered_func_data.nii.gz -o ${output}/lh/lh_fun_0${runid}_V1_background_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_sroi_nf_lh_V1_background_reg2run.nii.gz --showall
  fslmeants -i filtered_func_data.nii.gz -o ${output}/lh/lh_fun_0${runid}_V2_background_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_sroi_nf_lh_V2_background_reg2run.nii.gz --showall
  fslmeants -i filtered_func_data.nii.gz -o ${output}/lh/lh_fun_0${runid}_V3_background_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_sroi_nf_lh_V3_background_reg2run.nii.gz --showall

  fslmeants -i filtered_func_data.nii.gz -o ${output}/lh/lh_fun_0${runid}_V1_edge_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_sroi_nf_lh_V1_edge_reg2run.nii.gz --showall
  fslmeants -i filtered_func_data.nii.gz -o ${output}/lh/lh_fun_0${runid}_V2_edge_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_sroi_nf_lh_V2_edge_reg2run.nii.gz --showall
  # fslmeants -i filtered_func_data.nii.gz -o ${output}/lh/lh_fun_0${runid}_V3_edge_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_sroi_nf_lh_V3_edge_reg2run.nii.gz --showall

  # Right hemisphere${runid}
  fslmeants -i filtered_func_data.nii.gz -o ${output}/rh/rh_fun_0${runid}_V1_center_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_sroi_nf_rh_V1_centre_reg2run.nii.gz --showall
  fslmeants -i filtered_func_data.nii.gz -o ${output}/rh/rh_fun_0${runid}_V2_center_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_sroi_nf_rh_V2_centre_reg2run.nii.gz --showall
  fslmeants -i filtered_func_data.nii.gz -o ${output}/rh/rh_fun_0${runid}_V3_center_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_sroi_nf_rh_V3_centre_reg2run.nii.gz --showall

  fslmeants -i filtered_func_data.nii.gz -o ${output}/rh/rh_fun_0${runid}_V1_background_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_sroi_nf_rh_V1_background_reg2run.nii.gz --showall
  fslmeants -i filtered_func_data.nii.gz -o ${output}/rh/rh_fun_0${runid}_V2_background_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_sroi_nf_rh_V2_background_reg2run.nii.gz --showall
  fslmeants -i filtered_func_data.nii.gz -o ${output}/rh/rh_fun_0${runid}_V3_background_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_sroi_nf_rh_V3_background_reg2run.nii.gz --showall

  fslmeants -i filtered_func_data.nii.gz -o ${output}/rh/rh_fun_0${runid}_V1_edge_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_sroi_nf_rh_V1_edge_reg2run.nii.gz --showall
  fslmeants -i filtered_func_data.nii.gz -o ${output}/rh/rh_fun_0${runid}_V2_edge_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_sroi_nf_rh_V2_edge_reg2run.nii.gz --showall
  # fslmeants -i filtered_func_data.nii.gz -o ${output}/rh/rh_fun_0${runid}_V3_edge_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_sroi_nf_rh_V3_edge_reg2run.nii.gz --showall
  # ---------------------------------------------------------------------------------------
  # Two sides altogether
  fslmeants -i filtered_func_data.nii.gz -o ${output}/Twosides/BS_fun_0${runid}_V1_center_meants_tc.txt -m ${maskpth}sub-12_ses-002_sroi_nf_V1_centre_reg2run.nii.gz --showall
  fslmeants -i filtered_func_data.nii.gz -o ${output}/Twosides/BS_fun_0${runid}_V2_center_meants_tc.txt -m ${maskpth}sub-12_ses-002_sroi_nf_V2_centre_reg2run.nii.gz --showall
  fslmeants -i filtered_func_data.nii.gz -o ${output}/Twosides/BS_fun_0${runid}_V3_center_meants_tc.txt -m ${maskpth}sub-12_ses-002_sroi_nf_V3_centre_reg2run.nii.gz --showall

  fslmeants -i filtered_func_data.nii.gz -o ${output}/Twosides/BS_fun_0${runid}_V1_background_meants_tc.txt -m ${maskpth}sub-12_ses-002_sroi_nf_V1_background_reg2run.nii.gz --showall
  fslmeants -i filtered_func_data.nii.gz -o ${output}/Twosides/BS_fun_0${runid}_V2_background_meants_tc.txt -m ${maskpth}sub-12_ses-002_sroi_nf_V2_background_reg2run.nii.gz --showall
  fslmeants -i filtered_func_data.nii.gz -o ${output}/Twosides/BS_fun_0${runid}_V3_background_meants_tc.txt -m ${maskpth}sub-12_ses-002_sroi_nf_V3_background_reg2run.nii.gz --showall

  fslmeants -i filtered_func_data.nii.gz -o ${output}/Twosides/BS_fun_0${runid}_V1_edge_meants_tc.txt -m ${maskpth}sub-12_ses-002_sroi_nf_V1_edge_reg2run.nii.gz --showall
  fslmeants -i filtered_func_data.nii.gz -o ${output}/Twosides/BS_fun_0${runid}_V2_edge_meants_tc.txt -m ${maskpth}sub-12_ses-002_sroi_nf_V2_edge_reg2run.nii.gz --showall
  # fslmeants -i filtered_func_data.nii.gz -o ${output}/Twosides/BS_fun_0${runid}_V3_edge_meants_tc.txt -m ${maskpth}sub-12_ses-002_sroi_nf_V3_edge_reg2run.nii.gz --showall

done
