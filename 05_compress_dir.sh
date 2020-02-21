#!/bin/bash
##This script is to compress 00_Dicom and 01_UntouchedNII#######################
strPth="/media/h/P04/Data/S04/Ses01/"
tar -zcvf ${strPth}00_Dicom.tar.gz ${strPth}00_Dicom/
tar -zcvf ${strPth}01_UntouchedNII.tar.gz ${strPth}01_UntouchedNII
