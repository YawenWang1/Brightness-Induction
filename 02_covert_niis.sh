#!/bin/bash
##This script is to create nifti files from .IMA files #########################
destPth="/media/h/P04/Data/S04/Ses01/"
dcm2niix -ba y -z y -o "${destPth}01_UntouchedNII/" -f 'sub4_%p_%e' "${destPth}00_Dicom/20191217/recon/"
