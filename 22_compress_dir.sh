#!/bin/bash
##This script is to compress 00_Dicom and 01_UntouchedNII#######################
strPth="/media/h/P04/Data/"
tar -zcvf ${strPth}sub-03_ses-001.tar.gz ${strPth}sub-03

# For session 2
strPth="/media/h/P04/Data/"
tar -zcvf ${strPth}sub-03_ses-002.tar.gz ${strPth}sub-03
