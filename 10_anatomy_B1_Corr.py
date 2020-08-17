#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jul 25 11:42:53 2020

@author: yawen
"""

from pymp2rage import MP2RAGE
import nibabel as nib

def fncLoadNii(strPathIn):
    """Load nii files."""
    print(('---------Loading: ' + strPathIn))
    # Load nii file (this doesn't load the data into memory yet):
    niiTmp = nib.load(strPathIn)
    # Load data into array:
    aryTmp = niiTmp.get_data()
    # Get headers:
    hdrTmp = niiTmp.header
    # Get 'affine':
    niiAff = niiTmp.affine
    # Output nii data as numpy array and header:
    return aryTmp, hdrTmp, niiAff

PrtPth = '/media/h/P04/Data/BIDS/sub-02/ses-002/anat/sub-02_ses-002_acq-MP2RAGE_run-1_mod-UNI_T1w.nii.gz'

nii = fncLoadNii(PrtPth)

mp2rage  = MP2RAGE(MPRAGE_tr=)

