#! /bin/bash
# Ctrl click and Alt+shift+Down Arrow
# For inducer's luminance going up
export output='/media/g/P04/Data/BIDS/sub-12/ses-002/func/GLM/BI/fslmeants_sig'
export maskpth='/media/g/P04/Data/BIDS/sub-12/ses-002/func/GLM/Anat_space/Masks/final/fun_space/'
mkdir ${output}
mkdir ${output}/rh
mkdir ${output}/lh
mkdir ${output}/Twosides
for runid in $(seq 1 6); do
  cd /media/g/P04/Data/BIDS/sub-12/ses-002/func/GLM/BI/BI_fun_0${runid}_MoCo_Dist_Corr_Coreg_3EV.feat
  echo "current run is : ${runid}" \\r

  # Calculate % signal change
  fslmaths stats/pe1.nii.gz -div mean_func.nii.gz -mul 1.28 stats/Sig_change_pe1.nii.gz
  fslmaths stats/pe2.nii.gz -div mean_func.nii.gz -mul 1.28 stats/Sig_change_pe2.nii.gz

  #-----------------------------------------------------------------------_inter--------
  # Left side
  fslmeants -i stats/Sig_change_pe1.nii.gz -o ${output}/lh/lh_fun_0${runid}_PE1_V1_center_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_lh_V1_centre_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe1.nii.gz -o ${output}/lh/lh_fun_0${runid}_PE1_V2_center_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_lh_V2_centre_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe1.nii.gz -o ${output}/lh/lh_fun_0${runid}_PE1_V3_center_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_lh_V3_centre_reg2run.nii.gz --showall

  fslmeants -i stats/Sig_change_pe1.nii.gz -o ${output}/lh/lh_fun_0${runid}_PE1_V1_background_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_lh_V1_background_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe1.nii.gz -o ${output}/lh/lh_fun_0${runid}_PE1_V2_background_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_lh_V2_background_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe1.nii.gz -o ${output}/lh/lh_fun_0${runid}_PE1_V3_background_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_lh_V3_background_reg2run.nii.gz --showall

  fslmeants -i stats/Sig_change_pe1.nii.gz -o ${output}/lh/lh_fun_0${runid}_PE1_V1_edge_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_lh_V1_edge_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe1.nii.gz -o ${output}/lh/lh_fun_0${runid}_PE1_V2_edge_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_lh_V2_edge_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe1.nii.gz -o ${output}/lh/lh_fun_0${runid}_PE1_V3_edge_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_lh_V3_edge_reg2run.nii.gz --showall

  fslmeants -i stats/Sig_change_pe2.nii.gz -o ${output}/lh/lh_fun_0${runid}_PE2_V1_center_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_lh_V1_centre_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe2.nii.gz -o ${output}/lh/lh_fun_0${runid}_PE2_V2_center_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_lh_V2_centre_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe2.nii.gz -o ${output}/lh/lh_fun_0${runid}_PE2_V3_center_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_lh_V3_centre_reg2run.nii.gz --showall

  fslmeants -i stats/Sig_change_pe2.nii.gz -o ${output}/lh/lh_fun_0${runid}_PE2_V1_background_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_lh_V1_background_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe2.nii.gz -o ${output}/lh/lh_fun_0${runid}_PE2_V2_background_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_lh_V2_background_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe2.nii.gz -o ${output}/lh/lh_fun_0${runid}_PE2_V3_background_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_lh_V3_background_reg2run.nii.gz --showall

  fslmeants -i stats/Sig_change_pe2.nii.gz -o ${output}/lh/lh_fun_0${runid}_PE2_V1_edge_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_lh_V1_edge_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe2.nii.gz -o ${output}/lh/lh_fun_0${runid}_PE2_V2_edge_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_lh_V2_edge_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe2.nii.gz -o ${output}/lh/lh_fun_0${runid}_PE2_V3_edge_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_lh_V3_edge_reg2run.nii.gz --showall

  # Right hemisphere${runid}
  fslmeants -i stats/Sig_change_pe1.nii.gz -o ${output}/rh/rh_fun_0${runid}_PE1_V1_center_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_rh_V1_centre_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe1.nii.gz -o ${output}/rh/rh_fun_0${runid}_PE1_V2_center_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_rh_V2_centre_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe1.nii.gz -o ${output}/rh/rh_fun_0${runid}_PE1_V3_center_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_rh_V3_centre_reg2run.nii.gz --showall

  fslmeants -i stats/Sig_change_pe1.nii.gz -o ${output}/rh/rh_fun_0${runid}_PE1_V1_background_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_rh_V1_background_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe1.nii.gz -o ${output}/rh/rh_fun_0${runid}_PE1_V2_background_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_rh_V2_background_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe1.nii.gz -o ${output}/rh/rh_fun_0${runid}_PE1_V3_background_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_rh_V3_background_reg2run.nii.gz --showall

  fslmeants -i stats/Sig_change_pe1.nii.gz -o ${output}/rh/rh_fun_0${runid}_PE1_V1_edge_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_rh_V1_edge_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe1.nii.gz -o ${output}/rh/rh_fun_0${runid}_PE1_V2_edge_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_rh_V2_edge_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe1.nii.gz -o ${output}/rh/rh_fun_0${runid}_PE1_V3_edge_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_rh_V3_edge_reg2run.nii.gz --showall

  fslmeants -i stats/Sig_change_pe2.nii.gz -o ${output}/rh/rh_fun_0${runid}_PE2_V1_center_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_rh_V1_centre_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe2.nii.gz -o ${output}/rh/rh_fun_0${runid}_PE2_V2_center_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_rh_V2_centre_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe2.nii.gz -o ${output}/rh/rh_fun_0${runid}_PE2_V3_center_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_rh_V3_centre_reg2run.nii.gz --showall

  fslmeants -i stats/Sig_change_pe2.nii.gz -o ${output}/rh/rh_fun_0${runid}_PE2_V1_background_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_rh_V1_background_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe2.nii.gz -o ${output}/rh/rh_fun_0${runid}_PE2_V2_background_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_rh_V2_background_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe2.nii.gz -o ${output}/rh/rh_fun_0${runid}_PE2_V3_background_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_rh_V3_background_reg2run.nii.gz --showall

  fslmeants -i stats/Sig_change_pe2.nii.gz -o ${output}/rh/rh_fun_0${runid}_PE2_V1_edge_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_rh_V1_edge_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe2.nii.gz -o ${output}/rh/rh_fun_0${runid}_PE2_V2_edge_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_rh_V2_edge_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe2.nii.gz -o ${output}/rh/rh_fun_0${runid}_PE2_V3_edge_meants_tc.txt -m ${maskpth}LefRight/sub-12_ses-002_rh_V3_edge_reg2run.nii.gz --showall
  # ---------------------------------------------------------------------------------------
  # Two sides altogether
  fslmeants -i stats/Sig_change_pe1.nii.gz -o ${output}/Twosides/BS_fun_0${runid}_PE1_V1_center_meants_tc.txt -m ${maskpth}sub-12_ses-002_V1_centre_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe1.nii.gz -o ${output}/Twosides/BS_fun_0${runid}_PE1_V2_center_meants_tc.txt -m ${maskpth}sub-12_ses-002_V2_centre_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe1.nii.gz -o ${output}/Twosides/BS_fun_0${runid}_PE1_V3_center_meants_tc.txt -m ${maskpth}sub-12_ses-002_V3_centre_reg2run.nii.gz --showall

  fslmeants -i stats/Sig_change_pe1.nii.gz -o ${output}/Twosides/BS_fun_0${runid}_PE1_V1_background_meants_tc.txt -m ${maskpth}sub-12_ses-002_V1_background_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe1.nii.gz -o ${output}/Twosides/BS_fun_0${runid}_PE1_V2_background_meants_tc.txt -m ${maskpth}sub-12_ses-002_V2_background_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe1.nii.gz -o ${output}/Twosides/BS_fun_0${runid}_PE1_V3_background_meants_tc.txt -m ${maskpth}sub-12_ses-002_V3_background_reg2run.nii.gz --showall

  fslmeants -i stats/Sig_change_pe1.nii.gz -o ${output}/Twosides/BS_fun_0${runid}_PE1_V1_edge_meants_tc.txt -m ${maskpth}sub-12_ses-002_V1_edge_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe1.nii.gz -o ${output}/Twosides/BS_fun_0${runid}_PE1_V2_edge_meants_tc.txt -m ${maskpth}sub-12_ses-002_V2_edge_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe1.nii.gz -o ${output}/Twosides/BS_fun_0${runid}_PE1_V3_edge_meants_tc.txt -m ${maskpth}sub-12_ses-002_V3_edge_reg2run.nii.gz --showall

  fslmeants -i stats/Sig_change_pe2.nii.gz -o ${output}/Twosides/BS_fun_0${runid}_PE2_V1_center_meants_tc.txt -m ${maskpth}sub-12_ses-002_V1_centre_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe2.nii.gz -o ${output}/Twosides/BS_fun_0${runid}_PE2_V2_center_meants_tc.txt -m ${maskpth}sub-12_ses-002_V2_centre_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe2.nii.gz -o ${output}/Twosides/BS_fun_0${runid}_PE2_V3_center_meants_tc.txt -m ${maskpth}sub-12_ses-002_V3_centre_reg2run.nii.gz --showall

  fslmeants -i stats/Sig_change_pe2.nii.gz -o ${output}/Twosides/BS_fun_0${runid}_PE2_V1_background_meants_tc.txt -m ${maskpth}sub-12_ses-002_V1_background_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe2.nii.gz -o ${output}/Twosides/BS_fun_0${runid}_PE2_V2_background_meants_tc.txt -m ${maskpth}sub-12_ses-002_V2_background_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe2.nii.gz -o ${output}/Twosides/BS_fun_0${runid}_PE2_V3_background_meants_tc.txt -m ${maskpth}sub-12_ses-002_V3_background_reg2run.nii.gz --showall

  fslmeants -i stats/Sig_change_pe2.nii.gz -o ${output}/Twosides/BS_fun_0${runid}_PE2_V1_edge_meants_tc.txt -m ${maskpth}sub-12_ses-002_V1_edge_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe2.nii.gz -o ${output}/Twosides/BS_fun_0${runid}_PE2_V2_edge_meants_tc.txt -m ${maskpth}sub-12_ses-002_V2_edge_reg2run.nii.gz --showall
  fslmeants -i stats/Sig_change_pe2.nii.gz -o ${output}/Twosides/BS_fun_0${runid}_PE2_V3_edge_meants_tc.txt -m ${maskpth}sub-12_ses-002_V3_edge_reg2run.nii.gz --showall

done
