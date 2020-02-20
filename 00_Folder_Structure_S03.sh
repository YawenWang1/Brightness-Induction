#!/bin/bash
###############################################################################
# The purpose of this script is to create a folder structure for a project    #
###############################################################################

# Define project number:
project_id="P04"
# Define subject Number
subject_id="S04"
# Define session Number
session_id="Ses01"
# Define Parent directory
parPath="/media/h/"
# cd the pwd to the current subject
# project directory:
#------------------------------------------------------------------------------
# Define parent folder in h drive:
# cd the pwd to the current subject
# project directory:
strPathProject="${parPath}${project_id}/Data"
mkdir $strPathProject
# subject/ directory
strPathSubject="${strPathProject}/${subject_id}"
mkdir $strPathSubject
# session directory
strPathSession="${strPathSubject}/${session_id}"
mkdir $strPathSession
# Path for Dicom
strPathDicom="${strPathSession}/00_Dicom"
# cd $strPathConvnii
mkdir $strPathDicom
# Path for 01_UntouchedNII
strPathUNII="${strPathSession}/01_UntouchedNII"
# cd $strPathConvnii
mkdir $strPathUNII
# preprocessing
strPathPreprocessing="${strPathSession}/02_Preprocessing"
mkdir $strPathPreprocessing
# Path for anatomical data
strPathAna="${strPathPreprocessing}/00_Ana"
# cd $strPathConvnii
mkdir $strPathAna
# Path for functional data
strPathFun="${strPathPreprocessing}/01_Func"
# cd $strPathConvnii
mkdir $strPathFun
# Path for functional data ()
strPathFunDown="${strPathFun}/00_fun_se"
# cd $strPathConvnii
mkdir $strPathFunDown
# Path for functional data (ope)
strPathFunOpe="${strPathFun}/01_fun_se_op"
# cd $strPathConvnii
mkdir $strPathFunOpe
# Path for functional data (mean)
strPathFunMean="${strPathFun}/02_fun_mean_images"
# cd $strPathConvnii
mkdir $strPathFunMean
# Path for functional data (mask)
strPathFunMsk="${strPathFun}/03_fun_masks"
# cd $strPathConvnii
mkdir $strPathFunMsk
# Path for functional data (distion correction )
strPathDT="${strPathFun}/04_dist_correction"
# cd $strPathConvnii
mkdir $strPathDT
# Path for functional data (Motion correction )
strPathMoCo="${strPathFun}/05_MoCo"
# cd $strPathConvnii
mkdir $strPathMoCo
# Path for codes
strPathGLM="${strPathSession}/03_GLM"
# cd $strPathConvnii
mkdir $strPathGLM
# Path for codes
strPathScripts="${strPathSession}/04_Scripts"
# cd $strPathConvnii
mkdir $strPathScripts
# Path for preprossed anatomy
strPathAna="${strPathGLM}/00_Ana"
# cd $strPathConvnii
mkdir $strPathAna
# Path for black background condition
strPathBlkBck="${strPathGLM}/01_BlkBck"
# cd $strPathConvnii
mkdir $strPathBlkBck
# Path for gray background condition
strPathGrayBck="${strPathGLM}/02_GrayBck"
# cd $strPathConvnii
mkdir $strPathGrayBck
# Path for prf
strPathpRF="${strPathGLM}/03_pRF"
# cd $strPathConvnii
mkdir $strPathpRF
# Path for behavior data from 7T
strPathPsy="${strPathSession}/05_7T_psy"
mkdir $strPathPsy
# Path for scanning parameters
strPathScanPara="${strPathSession}/06_scan_para"
# cd $strPathConvnii
mkdir $strPathScanPara
# Path for Protocol
strPathPrt="${strPathSession}/07_log"
# cd $strPathConvnii
mkdir $strPathPrt
