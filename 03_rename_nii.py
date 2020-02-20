#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Sep 13 17:25:17 2019

"""
"""
Rename nii images (remove `_e1` suffix).

The dicom to nii conversion tool (dcm2niix) sometime appends a suffix (`_e1`)
to nii files. It does not seem to be possible to disable this, and it is not
clear under which circumstances the suffix is added. Thus, it has to be
removed.
"""

# Part of LGN pRF analysis pipeline.
# Copyright (C) 2018  Ingo Marquardt
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <http://www.gnu.org/licenses/>.

import os
from os.path import isfile, join
import glob

projectFolder = 'P04'
subjectID     = 'S04'
# Load environmental variables defining the input data path:
# OutDataPth is also the Nii orginal Paths
outDataPth = '/media/h/' + projectFolder + '/Data/' + \
    subjectID + '/Ses01/02_Preprocessing/01_Func/'
    
# Get list of files in results directory:
lstFls = glob.glob(outDataPth +'/*.nii.gz')
refNiifile = [
        '0p8_52slices_TR2604_func_run1',
        '0p8_52slices_TR2604_func_run2',
        '0p8_52slices_TR2604_func_run3',
        '0p8_52slices_TR2604_func_run4',
        '0p8_52slices_TR2604_func_run5',
        '0p8_52slices_TR2604_func_run6',
        '1p0_52slc_pRF_TR2604_run1']
# Rename nii files with '_e1' suffix:
for strTmp in lstFls:
    for strid in refNiifile:
        if strid in strTmp:
            if '_oPE' in strTmp:
                # Rename file:
                os.rename((strTmp),
                  (outDataPth + '01_fun_se_op' + '/' + 'fun_0' + \
                   str(refNiifile.index(strid)+1) + '_ope.nii.gz'))
            else:
                os.rename((strTmp),
                         (outDataPth + '00_fun_se' + '/'  + 'fun_0' + \
                          str(refNiifile.index(strid)+1) + '.nii.gz'))


# Get list of files in results directory:
lstFls_json = glob.glob(outDataPth +'/*.json')
# Rename nii files with '_e1' suffix:
for strTmp in lstFls_json:
    for strid in refNiifile:
        if strid in strTmp:
            if '_oPE' in strTmp:
                # Rename file:
                os.rename((strTmp),
                  (outDataPth + '01_fun_se_op' + '/' + 'fun_0' + \
                   str(refNiifile.index(strid)+1) + '_ope.json'))
            else:
                os.rename((strTmp),
                  (outDataPth + '00_fun_se' + '/'  + 'fun_0' + \
                   str(refNiifile.index(strid)+1) + '.json'))
