#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Feb 21 16:32:20 2020

This script is to perform temporal interpolation for the functional data
because each stimulus condition is locked to TR
@author: yawen
"""
import os
import copy
import time
import numpy as np
import glob
import pandas as pd 


# *** Check time
#varTme_01 = time.clock()

# Load environmental variables defining the input data path:
data_path = '/media/g/P04/Data/BIDS/sub-12/ses-002/func/'
sub_path = '/media/g/P04/Data/BIDS/sub-12/ses-002/'

# Change to the directory and Get all the text filenames
meantsPth='/media/g/P04/Data/BIDS/sub-12/ses-002/func/GLM/BI/fslmeants_sig/'






# -----------------------------------------------------------------------------
# *** Preparations

for i in ['lh', 'rh', 'Twosides']:
     
     
     currPth=meantsPth + i + '/'
     os.chdir(currPth)
     AllTxtFiles=glob.glob('*.txt')


     varNumIn_01 = len(AllTxtFiles)
     
     lstTxt_cond  =  [] 
     
     lstTxt_vroi = [] 
     
     lstTxt_run  = [] 
     
     lstTxt_sroi = [] 
     
     lstTxt_sig_mean = [] 
     
     lstTxt_num_vxl = []
     
     lstTxt_roi = []
     
     lstTxt_hemi = []
     # Load meants txt files
     for index_01 in range(0, varNumIn_01):
     
     
         print('---Loading: ' + AllTxtFiles[index_01])
     
         # Read text file:
         aryTmp = np.loadtxt(
                             (currPth + '/' + AllTxtFiles[index_01]),
                             skiprows=3
                             )
     
         # Append current csv object to list:
         # Save the mean % signal change
         lstTxt_sig_mean.append(np.mean(aryTmp))
         # Save Luminance condition
         if 'PE1' in AllTxtFiles[index_01] :
              cond = 'Lum Incre'
         else:
              cond = 'Lum Decre'
              
         lstTxt_hemi.append(i)    
         lstTxt_cond.append(cond)

              
          # Save visual cortex
         lstTxt_vroi.append(AllTxtFiles[index_01].split('_')[4])
          # Save run number
         lstTxt_run.append('fun' + AllTxtFiles[index_01].split('_')[2])
          # Save stimulus roi
         lstTxt_sroi.append(AllTxtFiles[index_01].split('_')[5])
          # Save the number of voxels in the current roi  
         lstTxt_num_vxl.append(aryTmp.size)
          
         lstTxt_roi.append(AllTxtFiles[index_01].split('_')[4] + ' ' + AllTxtFiles[index_01].split('_')[5])

              
              
         
         
     dict_curr = {"% BOLD Signal Change": lstTxt_sig_mean,
                  "Condition":lstTxt_cond,
                  "Visual Area": lstTxt_vroi,
                  "Stimuli Area": lstTxt_sroi,
                  "Number of Voxels": lstTxt_num_vxl,
                  "ROI":lstTxt_roi,
                  "Hemisphere":lstTxt_hemi}    
     
     curr_df = pd.DataFrame(dict_curr)
     
     
     curr_df.to_csv(currPth + 'Sig_chg_pe.csv')



