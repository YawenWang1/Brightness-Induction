#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jan 24 16:26:03 2020

This script is for plot the glm results after applying roi

@author: yawen
"""

import os
import copy
import time
import numpy as np
import nibabel as nib
import glob

# -----------------------------------------------------------------------------
# *** Check time
#varTme_01 = time.clock()

# *** Define parameters
data_path = '/media/h/P04/Data/S04/Ses01/03_GLM/tst/07_ctr/'

niiFiles=glob.glob(data_path + '/*.nii.gz')

# *** Define some functions
def fncLoadNii(strPathIn):
    """Load nii files."""
    print(('---------Loading: ' + strPathIn))
    # Load nii file (this doesn't load the data into memory yet):
    niiTmp = nib.load(strPathIn)
    # Load data into array:
    aryTmp = niiTmp.get_data().astype(np.float32)

    # Get headers:
    hdrTmp = niiTmp.header
    # Get 'affine':
    niiAff = niiTmp.affine
    # Output nii data as numpy array and header:
    return aryTmp, hdrTmp, niiAff

# Define the list to store the value 
meanLst = []
for fileid in range(len(niiFiles)):
#for fileid in range(1):
    # Current file
    currIn = niiFiles[fileid]
    # Print current file name 
    print(currIn)
    # Load nii file
    currNii = fncLoadNii(currIn)
    tmp = currNii[0]
    meanLst.append(np.median(tmp[tmp!=0]))
    