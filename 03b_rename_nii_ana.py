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

# Load environmental variables defining the input data path:
strDataPth = '/media/h/P04/Data/S03/Ses01/02_Preprocessing/00_Ana/'
outDataPth = '/media/h/P04/Data/S03/Ses01/02_Preprocessing/00_Ana/'
# Get list of files in results directory:
lstFls = glob.glob(strDataPth +'/sub3_mp2rage_0p8_wholebrain_1*.nii.gz')
refNiifile = [
        'mp2rage_0p8_wholebrain_1.',
        'mp2rage_0p8_wholebrain_1a.',
        'mp2rage_0p8_wholebrain_1b.',
        'mp2rage_0p8_wholebrain_1c.',
        'mp2rage_0p8_wholebrain_1_ph.',
        'mp2rage_0p8_wholebrain_1_pha.']
destNiifile = [
        'mp2rage_wb_INV1',
        'mp2rage_wb_T1',
        'mp2rage_wb_UNI',
        'mp2rage_wb_INV2',
        'mp2rage_wb_ph',
        'mp2rage_wb_pha']
# Rename nii files with '_e1' suffix:
for strTmp in lstFls:
    for strid in refNiifile:
        if strid in strTmp:
            # Rename file:
            os.rename((strTmp),
                  (outDataPth + destNiifile[refNiifile.index(strid)] + \
                   '.nii.gz'))
# Get list of files in results directory:
lstFls_json = glob.glob(strDataPth +'/sub3_mp2rage_0p8_wholebrain_1*.json')
# Rename nii files with '_e1' suffix:
for strTmp in lstFls_json:
    for strid in refNiifile:
        if strid in strTmp:
            # Rename file:
            os.rename((strTmp),
                  (outDataPth + destNiifile[refNiifile.index(strid)] + \
                   '.json'))
         