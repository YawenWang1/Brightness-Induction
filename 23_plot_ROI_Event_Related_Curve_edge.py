#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Feb 14 14:37:06 2020

This script is to plot the event-related curve for each ROI

@author: yawen
"""

import os
import copy
import time
import numpy as np
import nibabel as nb
import glob
import pandas as pd
import matplotlib.pyplot as plt

import seaborn as sns; sns.set()
# Define directory of the ROI files
TxtPthIn='/media/h/P04/Data/S04/Ses01/03_GLM/05_func_reg_averages/'
# Get all the filenames 
os.chdir(TxtPthIn)
v1_TxtFiles=glob.glob('v1_edge' + '*_meants.txt')
sns.set_style("white") 
# calculate for v1
namelabel_v1=[]
timepoint_v1=[]
v1_temp=[]
for textid in range(len(v1_TxtFiles)):
    aryTmp = np.loadtxt(
                        v1_TxtFiles[textid],
                        skiprows=3
                        )

    for j in range(aryTmp.shape[1]):
        for i in np.arange(-4,16):
            timepoint_v1.append(i)

    # get the simple version of current file name
    interp =  v1_TxtFiles[textid].split('_')[2]
    for i in range(aryTmp.size):
        namelabel_v1.append(interp)

    T_aryTmp = np.transpose(aryTmp)
    temp = np.reshape(T_aryTmp,[aryTmp.size,1])
    # get the data in all the ROI into one column
    v1_temp.append(temp)
v1 = np.asarray([j for sub in v1_temp for j in sub])
timepoint_v1=np.asarray(timepoint_v1)
cond_v1=np.asarray(namelabel_v1)    
dict_v1={"TimePoint":timepoint_v1,"v1_BOLD singal change %":v1[:,0],"cond":cond_v1}


data_v1 = pd.DataFrame(dict_v1)
plt.figure(1)
ax1=sns.lineplot(x="TimePoint",y="v1_BOLD singal change %",hue="cond",style="cond",data=data_v1)
#--------------------------------------------------------------------------
# calculate for v2
v2_TxtFiles=glob.glob('v2_edge_' + '*_meants.txt')
timepoint_v2=[]

namelabel_v2=[]
v2_temp=[]

for textid in range(len(v2_TxtFiles)):
    aryTmp = np.loadtxt(
                        v2_TxtFiles[textid],
                        skiprows=3
                        )
    for j in range(aryTmp.shape[1]):
        for i in np.arange(-4,16):
            timepoint_v2.append(i)

    interp =  v2_TxtFiles[textid].split('_')[2]
    for i in range(aryTmp.size):
        namelabel_v2.append(interp)

    T_aryTmp = np.transpose(aryTmp)
    temp = np.reshape(T_aryTmp,[aryTmp.size,1])
    v2_temp.append(temp)

v2 = np.asarray([j for sub in v2_temp for j in sub])
timepoint_v2=np.asarray(timepoint_v2)
cond_v2=np.asarray(namelabel_v2)    
dict_v2={"TimePoint":timepoint_v2,"v2_BOLD singal change %":v2[:,0],"cond":cond_v2}


data_v2 = pd.DataFrame(dict_v2)
plt.figure(2)
ax2=sns.lineplot(x="TimePoint",y="v2_BOLD singal change %",hue="cond",style="cond",data=data_v2)


#--------------------------------------------------------------------------
# calculate for v3
v3_TxtFiles=glob.glob('v3_edge_' + '*_meants.txt')

timepoint_v3=[]
v3_temp=[]
namelabel_v3=[]
for textid in range(len(v3_TxtFiles)):
    aryTmp = np.loadtxt(
                        v3_TxtFiles[textid],
                        skiprows=3
                        )
    for j in range(aryTmp.shape[1]):
        for i in np.arange(-4,16):
            timepoint_v3.append(i)

    
    interp =  v2_TxtFiles[textid].split('_')[2]
    for i in range(aryTmp.size):
        namelabel_v3.append(interp)

    T_aryTmp = np.transpose(aryTmp)
    temp = np.reshape(T_aryTmp,[aryTmp.size,1])
    v3_temp.append(temp)

v3 = np.asarray([j for sub in v3_temp for j in sub])
timepoint_v3=np.asarray(timepoint_v3)
cond_v3=np.asarray(namelabel_v3)    
dict_v3={"TimePoint":timepoint_v3,"v3_BOLD singal change %":v3[:,0],"cond":cond_v3}


data_v3 = pd.DataFrame(dict_v3)
plt.figure(3)
ax3=sns.lineplot(x="TimePoint",y="v3_BOLD singal change %",hue="cond",style="cond",data=data_v3)
    


    