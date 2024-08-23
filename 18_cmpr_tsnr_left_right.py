#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
This scripts is for comparing and present tSNRs on left with right hemisphere
Created on Thu Nov 19 22:27:32 2020

@author: yawen
"""
import os
import glob
import numpy as np
import seaborn as sns
# the module to re-organize the data
import pandas as pd
import matplotlib.pyplot as plt
import nibabel as nib
from matplotlib import rcParams
# Define directory for all the txt files
niiPth='/media/g/P04/Data/BIDS/sub-12/ses-002/func/tSNR/ROI/'
output='/media/g/P04/Data/BIDS/sub-12/ses-002/Intermediate_steps/'
os.chdir(niiPth)
Sid=['lh','rh']
numRuns = 6
subID = 'sub-12'
tsnr_inx = ['befr_glm', 'filtered', 'res']
vareas = ['V1', 'V2', 'V3']
# Load all txt files
lstTsr_type,lstAry,lstSNRs,lstRId,lstROIs,lstRL,lstRunId=[],[],[],[],[],[], []
for tsnrid in tsnr_inx:

     for vid in vareas:
          for runid in range(1,numRuns+1):
               
               for sid in range(0,len(Sid)):
                    # Filename of current nii
                    currfile = (subID + '_' + Sid[sid] + '_' + vid + '_BI_fun_0'
                    + str(runid) + '_tsnr_' + tsnrid + '.nii.gz' )
                    # Load current nii file
                    currNii = nib.load(currfile).dataobj[:]
                    # Calculate mean of tsnr in the current ROI
                    lstSNRs.append(np.mean(currNii[np.nonzero(currNii)])) 
                    lstRL.append(Sid[sid])
                    lstROIs.append(vid)
                    lstRId.append(subID)
                    lstRunId.append('Run '+str(runid))
                    lstTsr_type.append(tsnrid)
                                
                    # lstAry.append(currNii)
     
# Build the dictionary
dict_roi = {'Hemisphere':lstRL,
          'Run_number':lstRunId,
          'ROI':lstROIs,
          'tSNR':lstSNRs,
          'tSNR Type': lstTsr_type,
          'Subject':lstRId} 
# Convert to panda dataframe
tSNR_roi = pd.DataFrame(data=dict_roi)
tSNR_roi_partial= tSNR_roi.loc[tSNR_roi['tSNR Type'] != 'res'] 
tSNR_roi_res= tSNR_roi.loc[tSNR_roi['tSNR Type'] == 'res'] 
tSNR_roi_filt= tSNR_roi.loc[tSNR_roi['tSNR Type'] == 'filtered'] 
tSNR_roi_befr= tSNR_roi.loc[tSNR_roi['tSNR Type'] == 'befr_glm'] 


tSNR_roi.to_csv()
# =============================================================================
# Plot the tsnr 
rcParams['font.family'] = 'sans-serif'
rcParams['font.sans-serif'] = ['Arial']
# figPth='/media/g/P01/Review/Figures/'
rc={'font.size': 9.0,
 'axes.labelsize': 12.0,
 'axes.titlesize': 11.0,
 'xtick.labelsize': 11.0,
 'ytick.labelsize': 11.0,
 'legend.fontsize': 9.0,
 'axes.linewidth': 1.25,
 'grid.linewidth': 1.0,
 'lines.linewidth': 2.0,
 'lines.markersize': 5.0,
 'patch.linewidth': 1.0,
 'xtick.major.width': 2,
 'ytick.major.width': 2,
 'xtick.minor.width': 1.0,
 'ytick.minor.width': 1.0,
 'xtick.major.size': 2.0,
 'ytick.major.size': 2.0,
 'xtick.minor.size': 1.0,
 'ytick.minor.size': 1.0,
 'legend.title_fontsize': 10.0}

# Plot the tSNRs
fig = plt.figure(dpi=300)
plt.rcParams.update(**rc)
ax = sns.barplot(x='Run_number',y='tSNR',data=tSNR_roi_befr,hue='Hemisphere',ci = 'sd', palette=['lightsteelblue','lightcoral'])
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)
ax.set_ylim([0,25])
ax.set_yticks([0,5,10,15,20])

plt.savefig(output + subID +'_left_right_tSNR_ROIs_comparison_befr.png')
plt.savefig(output + subID +'_left_right_tSNR_ROIs_comparison_befr.svg')


# Plot the tSNRs
fig = plt.figure(dpi=300)
plt.rcParams.update(**rc)
ax = sns.barplot(x='Run_number',y='tSNR',data=tSNR_roi_filt,hue='Hemisphere',ci = 'sd', palette=['lightsteelblue','lightcoral'])
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)
ax.set_ylim([0,25])
ax.set_yticks([0,5,10,15,20])
# ax.set_yticklabels(people)

plt.savefig(output + subID +'_left_right_tSNR_ROIs_comparison_filter.png')
plt.savefig(output + subID +'_left_right_tSNR_ROIs_comparison_filter.svg')


# Plot the tSNRs
fig = plt.figure(dpi=300)
plt.rcParams.update(**rc)
ax = sns.barplot(x='Run_number',y='tSNR',data=tSNR_roi_res,hue='Hemisphere',ci = 'sd', palette=['lightsteelblue','lightcoral'])
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)

plt.savefig(output + subID +'_left_right_tSNR_ROIs_comparison_res.png')
plt.savefig(output + subID +'_left_right_tSNR_ROIs_comparison_res.svg')

# Plot the tSNRs
fig = plt.figure(dpi=300)
plt.rcParams.update(**rc)
ax = sns.barplot(x='ROI',y='tSNR',data=tSNR_roi_befr,hue='Hemisphere',ci = 'sd', palette=['lightsteelblue','lightcoral'])
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)
ax.set_ylim([0,25])
ax.set_yticks([0,5,10,15,20])

plt.savefig(output + subID +'_left_right_tSNR_ROIs_comparison_befr_varea.png')
plt.savefig(output + subID +'_left_right_tSNR_ROIs_comparison_befr_varea.svg')


# Plot the tSNRs
fig = plt.figure(dpi=300)
plt.rcParams.update(**rc)
ax = sns.barplot(x='ROI',y='tSNR',data=tSNR_roi_filt,hue='Hemisphere',ci = 'sd', palette=['lightsteelblue','lightcoral'])
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)
ax.set_ylim([0,25])
ax.set_yticks([0,5,10,15,20])
# ax.set_yticklabels(people)

plt.savefig(output + subID +'_left_right_tSNR_ROIs_comparison_filter_varea.png')
plt.savefig(output + subID +'_left_right_tSNR_ROIs_comparison_filter_varea.svg')


# Plot the tSNRs
fig = plt.figure(dpi=300)
plt.rcParams.update(**rc)
ax = sns.barplot(x='ROI',y='tSNR',data=tSNR_roi_res,hue='Hemisphere',ci = 'sd', palette=['lightsteelblue','lightcoral'])
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)

plt.savefig(output + subID +'_left_right_tSNR_ROIs_comparison_res_varea.png')
plt.savefig(output + subID +'_left_right_tSNR_ROIs_comparison_res_varea.svg')

tSNR_roi.to_csv(output + subID + '_left_right_tSNR_ROIs_comparison.csv')

# =============================================================================


plt.close('all')
