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
import nibabel as nb
import math
import glob
import matplotlib.pyplot as plt
from scipy.interpolate import CubicSpline
from scipy.interpolate import LSQUnivariateSpline, UnivariateSpline
from scipy.interpolate import interp1d
from scipy.interpolate import Rbf, InterpolatedUnivariateSpline
import seaborn as sns; sns.set()
import pandas as pd

#sns.set_style("white")

# *** Check time
#varTme_01 = time.clock()


# Volume TR of input nii files:
varTR = 2.604

# Number of Volumes of input nii files:
varNumVol = 258

# Number ofRuns
varNumRun = 5

# Number of volumes that will be included in the average segment before the
# onset of the condition block. NOTE: We get the start time and the duration
# of each block from the design matrices (EV files). In order for the averaging
# to work (and in order for it to be sensible in a conceptual sense), all
# blocks that are included in the average need to have the same duration.
varVolsPre = 2.0
varTmepre = varVolsPre * varTR
# Number of volumes that will be included in the average segment after the
# end of the condition block:
varVolsPst = 12.0
varTmepst  = varVolsPst * varTR

# The rest time in seconds before and after the real experiment
varRestStr = 52.1

# Duration of the stimulus block
varDur = 11.0
# Duration of the segments in each event-related plot
varSegDur = np.ceil(varTmepre + varDur + varTmepst ).astype(int)
# Number of volumes removes at the beginning and the end
varVolmov = 5
# how long would it be removed in seconds
varVolmovsec = np.ceil(varVolmov * varTR).astype(int)

# If normalisation is performed, which time points to use as baseline, relative
# to the stimulus condition onset. (I.e., if you specify -3 and 0, the three
# volumes preceeding the onset of the stimulus are used - the interval is
# non-inclusive at the end.)
tplBase = (-2, 0)
BaseDur = int(len(np.arange(tplBase[0], tplBase[1]))*varTR)

# This corresponds to the 220 volumes in the functional data
TR_tc = np.arange(0,varNumVol)

# This is interpolated x axis
TR_TI_tc = np.linspace(0,varNumVol,int(np.round(varTR*varNumVol)))

# Load environmental variables defining the input data path:
data_path = '/media/h/P04/Data/BIDS/sub-02/ses-002/func/'

# Change to the directory and Get all the text filenames
meantsPth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/BI/test/fslmeants'
os.chdir(meantsPth)
AllTxtFiles=glob.glob('*.txt')




# Empty list that will be filled with the list of csv data:
# varNumIn_01 = len(TmpTextFiles)
varNumIn_01 = len(AllTxtFiles)

lstTxt      = [None] * varNumIn_01


# Directory containing design matrices (EV files):
strdm = 'DM_01/'
strPathEV = data_path + strdm

# List of design matrices (EV files), in the same order as input 4D nii files
# (location within parent directory):
# lstIn_02 = '20191217_BI_7T_fMRI_Run_01_Lum_Up.txt'
lstIn_02 = ['20200717_BI_7T_fMRI_Run_01_Lum_Up.txt',
            '20200717_BI_7T_fMRI_Run_02_Lum_Up.txt',
            '20200717_BI_7T_fMRI_Run_03_Lum_Up.txt',
            '20200717_BI_7T_fMRI_Run_04_Lum_Up.txt',
            '20200717_BI_7T_fMRI_Run_05_Lum_Up.txt',
            '20200717_BI_7T_fMRI_Run_06_Lum_Up.txt']

lstIn_03 = ['20200717_BI_7T_fMRI_Run_01_Lum_Down.txt',
            '20200717_BI_7T_fMRI_Run_02_Lum_Down.txt',
            '20200717_BI_7T_fMRI_Run_03_Lum_Down.txt',
            '20200717_BI_7T_fMRI_Run_04_Lum_Down.txt',
            '20200717_BI_7T_fMRI_Run_05_Lum_Down.txt',
            '20200717_BI_7T_fMRI_Run_06_Lum_Down.txt']

lstIn_04 = ['20200717_BI_7T_fMRI_Run_01_GW.txt',
            '20200717_BI_7T_fMRI_Run_02_GW.txt',
            '20200717_BI_7T_fMRI_Run_03_GW.txt',
            '20200717_BI_7T_fMRI_Run_04_GW.txt',
            '20200717_BI_7T_fMRI_Run_05_GW.txt',
            '20200717_BI_7T_fMRI_Run_06_GW.txt']

lstIn_05 = ['20200717_BI_7T_fMRI_Run_01_WG.txt',
            '20200717_BI_7T_fMRI_Run_02_WG.txt',
            '20200717_BI_7T_fMRI_Run_03_WG.txt',
            '20200717_BI_7T_fMRI_Run_04_WG.txt',
            '20200717_BI_7T_fMRI_Run_05_WG.txt',
            '20200717_BI_7T_fMRI_Run_06_WG.txt']

lstIn_06 = ['20200717_BI_7T_fMRI_Run_01_GB.txt',
            '20200717_BI_7T_fMRI_Run_02_GB.txt',
            '20200717_BI_7T_fMRI_Run_03_GB.txt',
            '20200717_BI_7T_fMRI_Run_04_GB.txt',
            '20200717_BI_7T_fMRI_Run_05_GB.txt',
            '20200717_BI_7T_fMRI_Run_06_GB.txt']

lstIn_07 = ['20200717_BI_7T_fMRI_Run_01_BG.txt',
            '20200717_BI_7T_fMRI_Run_02_BG.txt',
            '20200717_BI_7T_fMRI_Run_03_BG.txt',
            '20200717_BI_7T_fMRI_Run_04_BG.txt',
            '20200717_BI_7T_fMRI_Run_05_BG.txt',
            '20200717_BI_7T_fMRI_Run_06_BG.txt']

strPathOut = '/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/BI/test/ERA_01'
os.chdir(strPathOut)
#if ~os.path.isdir(strPathOut):
#    os.mkdir(strPathOut)

# Normalise time segments? If True, segments are normalised trial-by-trial;
# i.e. each time-course segment is divided by its own pre-stimulus baseline
# before averaging across trials.
#lgcNorm = False # True
lgcNorm = True

# Whether or not to also produces individual event-related segments for each
# trial:
lgcSegs = True # False
if lgcSegs:
    # Basename for segments:
    strSegs = 'NA'

# -----------------------------------------------------------------------------
# *** Preparations

print('-Create average time courses')

# Number of input design matrices:
varNumIn_02 = len(lstIn_02)

# Number of input design matrices:
varNumIn_03 = len(lstIn_03)

# Number of input design matrices:
varNumIn_04 = len(lstIn_04)

# Number of input design matrices:
varNumIn_05 = len(lstIn_05)


# Number of input design matrices:
varNumIn_06 = len(lstIn_06)

# Number of input design matrices:
varNumIn_07 = len(lstIn_07)


# Empty list that will be filled with the list of csv data:
lstEV_up = [None] * varNumIn_02

lstEV_down = [None] * varNumIn_03

lstEV_gw = [None] * varNumIn_04

lstEV_wg = [None] * varNumIn_05


lstEV_gb = [None] * varNumIn_06

lstEV_bg = [None] * varNumIn_07


lstTxt  =  [None] * varNumIn_01

lstTxt_mean = [None] * varNumIn_01

lstTxt_norm= [None] * varNumIn_01
lstTxt_normne = [None] * varNumIn_01

# Load meants txt files
for index_01 in range(0, varNumIn_01):


    print('---Loading: ' + AllTxtFiles[index_01])

    # Read text file:
    aryTmp = np.loadtxt(
                        (meantsPth + '/' + AllTxtFiles[index_01]),
                        skiprows=3
                        )

    # Append current csv object to list:
    lstTxt[index_01] = np.copy(aryTmp)
    tmp_mne = np.mean(aryTmp,axis=0)
    tmp_std = np.std(aryTmp,axis=0)
    tmp_norm = np.divide(np.subtract(aryTmp,tmp_mne),tmp_std)
    lstTxt_mean[index_01] = np.mean(aryTmp,axis = 1)
    lstTxt_norm[index_01] = tmp_norm
    lstTxt_normne[index_01] = np.mean(tmp_norm,axis = 1)

# Load design matrices (EV files):
for index_01 in range(0, varNumIn_02):


    print('---Loading: ' + lstIn_02[index_01])

    # Read text file:
    aryTmp = np.loadtxt(
                        (strPathEV + lstIn_02[index_01]),
                        skiprows=0
                        )
    # Append current csv object to list:
    lstEV_up[index_01] = np.copy(aryTmp)


# Load design matrices (EV files):
for index_01 in range(0, varNumIn_03):


    print('---Loading: ' + lstIn_03[index_01])

    # Read text file:
    aryTmp = np.loadtxt(
                        (strPathEV + lstIn_03[index_01]),
                        skiprows=0
                        )
    # Append current csv object to list:
    lstEV_down[index_01] = np.copy(aryTmp)


# Load design matrices (EV files):
for index_01 in range(0, varNumIn_04):


    print('---Loading: ' + lstIn_04[index_01])

    # Read text file:
    aryTmp = np.loadtxt(
                        (strPathEV + lstIn_04[index_01]),
                        skiprows=0
                        )
    # Append current csv object to list:
    lstEV_gw[index_01] = np.copy(aryTmp)


# Load design matrices (EV files):
for index_01 in range(0, varNumIn_05):


    print('---Loading: ' + lstIn_05[index_01])

    # Read text file:
    aryTmp = np.loadtxt(
                        (strPathEV + lstIn_05[index_01]),
                        skiprows=0
                        )
    # Append current csv object to list:
    lstEV_wg[index_01] = np.copy(aryTmp)
    
    
# Load design matrices (EV files):
for index_01 in range(0, varNumIn_06):


    print('---Loading: ' + lstIn_06[index_01])

    # Read text file:
    aryTmp = np.loadtxt(
                        (strPathEV + lstIn_06[index_01]),
                        skiprows=0
                        )
    # Append current csv object to list:
    lstEV_gb[index_01] = np.copy(aryTmp)


# Load design matrices (EV files):
for index_01 in range(0, varNumIn_07):


    print('---Loading: ' + lstIn_07[index_01])

    # Read text file:
    aryTmp = np.loadtxt(
                        (strPathEV + lstIn_07[index_01]),
                        skiprows=0
                        )
    # Append current csv object to list:
    lstEV_bg[index_01] = np.copy(aryTmp)

# Temporal interpolation
lstTxt_ti = []
for txtid in range(0, len(AllTxtFiles)):
# for txtid in range(0,len(TmpTextFiles)):
    arytmp = np.zeros([len(TR_TI_tc),1])
    plt.figure(txtid)
    # The reason why I chose the current parameters is that it didn't give
    # extreme values at the boundary.
    # tx = UnivariateSpline(TR_tc,lstTxt[0][:,i])
    # tx =  CubicSpline(TR_tc,lstTxt[0][:,i])
    # tx = InterpolatedUnivariateSpline(TR_tc,lstTxt[0][:,i])
    # plt.plot(TR_TI_tc,tx(TR_TI_tc))
    # plt.plot(TR_tc,lstTxt[txtid][:,i],'ro')

    tx = interp1d(TR_tc,lstTxt_normne[txtid],
                  kind="cubic",
                  axis=-1,
                  copy=True,
                  bounds_error=False,
                  fill_value="extrapolate",
                  assume_sorted=False)

    arytmp[:,0] = tx(TR_TI_tc)
    # Save the array
    plt.plot(TR_TI_tc[0:-2],tx(TR_TI_tc)[0:-2])
    plt.plot(TR_tc,lstTxt_normne[txtid],'ro')
    plt.title(" ".join(AllTxtFiles[txtid].split('_')[0:-2]))
    plt.savefig("_".join(AllTxtFiles[txtid].split('_')[0:-2]) + '.svg')
    plt.savefig("_".join(AllTxtFiles[txtid].split('_')[0:-2]) + '.png')
    lstTxt_ti.append(arytmp)

plt.close('all')
#
# ----------------------------------------------------------------------------
  
# =============================================================================
# This section is to plot background roi for all the conditions
counter = -1
for runid in range(0,len(AllTxtFiles),2):
#     print (runid)
    counter +=1
    plt.figure(counter,figsize=(10, 10))         
    curr_roi =  lstTxt_ti[runid]
    
    varStr = lstEV_up[counter][:,0].astype(int)
#    varStr =(arytmpCond[:,0]*4).astype(int)
    varStp = (varStr + varDur).astype(int)
    
    varStr_down = lstEV_down[counter][:,0].astype(int)

#    varStr_dwon = (arytmpCond_down[:,0] * 4).astype(int)
    varStp_down = (varStr_down + varDur).astype(int)
    
    
    varStr_GW = lstEV_gw[counter][:,0].astype(int)
    varStp_GW = (varStr_GW + 1).astype(int)


    varStr_WG = lstEV_wg[counter][:,0].astype(int)
    varStp_WG = (varStr_WG + 1).astype(int)
    
    varStr_BG = lstEV_bg[counter][:,0].astype(int)
    varStp_BG = (varStr_BG + 1).astype(int)
    
    varStr_GB = lstEV_gb[counter][:,0].astype(int)
    varStp_GB = (varStr_GB + 1).astype(int)
   
    
    xaxis_str_up = TR_TI_tc[varStr]
    xaxis_stp_up = TR_TI_tc[varStp]
    
    xaxis_str_down = TR_TI_tc[varStr_down]
    xaxis_stp_down = TR_TI_tc[varStp_down]
    
    plt.plot(TR_TI_tc,curr_roi,c='y')


#    plt.plot(TR_tc,lstTxt_normne[txtid],c='y')
    plt.ylim([-1.8,2.2])
    
    plt.scatter(TR_TI_tc[varStr_GW] ,curr_roi[varStr_GW,0],c='g',marker='*')
    plt.scatter(TR_TI_tc[varStp_GW] ,curr_roi[varStp_GW,0],c='c',marker='*')

    plt.scatter(xaxis_str_up ,curr_roi[varStr,0],c='g',marker='<')
    plt.scatter(xaxis_stp_up ,curr_roi[varStp,0],c='c',marker='>')
    
    plt.scatter(TR_TI_tc[varStr_WG] ,curr_roi[varStr_WG,0],c='g',marker='*')
    plt.scatter(TR_TI_tc[varStp_WG] ,curr_roi[varStp_WG,0],c='c',marker='*')

    plt.scatter(TR_TI_tc[varStr_GB] ,curr_roi[varStr_GB,0],c='red',marker='*')
    plt.scatter(TR_TI_tc[varStp_GB] ,curr_roi[varStp_GB,0],c='k',marker='*')


    plt.scatter(xaxis_str_down ,curr_roi[varStr_down,0],c='red',marker='<')
    plt.scatter(xaxis_stp_down ,curr_roi[varStp_down,0],c='k',marker='>')
    
    plt.scatter(TR_TI_tc[varStr_BG] ,curr_roi[varStr_BG,0],c='red',marker='*')
    plt.scatter(TR_TI_tc[varStp_BG] ,curr_roi[varStp_BG,0],c='k',marker='*')
    plt.legend(['Data','Str_G2W','Stp_G2W','Str_up','Stp_up','Str_W2G','Stp_W2G','Str_G2B','Stp_G2B','Str_down','Stp_down','Str_B2G','Stp_B2G'],loc=1)
    
    plt.title('Fun_0' + str(counter+1) + '_stimulus_events_In_bkgrd' )
    plt.savefig('Fun_0' + str(counter+1) + '_stimulus_events_In_bkgrd' + '.png')


lst_bkgrd_mne = np.mean(lst_bkgrd,axis=1)

plt.close('all')
# =============================================================================

# =============================================================================

counter = -1
for runid in range(1,len(AllTxtFiles),2):
#     print (runid)
    counter +=1
    plt.figure(counter,figsize=(10, 10))         
    curr_roi =  lstTxt_ti[runid]
    
    varStr = lstEV_up[counter][:,0].astype(int)
#    varStr =(arytmpCond[:,0]*4).astype(int)
    varStp = (varStr + varDur).astype(int)
    
    varStr_down = lstEV_down[counter][:,0].astype(int)

#    varStr_dwon = (arytmpCond_down[:,0] * 4).astype(int)
    varStp_down = (varStr_down + varDur).astype(int)
    
    
    varStr_GW = lstEV_gw[counter][:,0].astype(int)
    varStp_GW = (varStr_GW + 1).astype(int)


    varStr_WG = lstEV_wg[counter][:,0].astype(int)
    varStp_WG = (varStr_WG + 1).astype(int)
    
    varStr_BG = lstEV_bg[counter][:,0].astype(int)
    varStp_BG = (varStr_BG + 1).astype(int)
    
    varStr_GB = lstEV_gb[counter][:,0].astype(int)
    varStp_GB = (varStr_GB + 1).astype(int)
   
    
    xaxis_str_up = TR_TI_tc[varStr]
    xaxis_stp_up = TR_TI_tc[varStp]
    
    xaxis_str_down = TR_TI_tc[varStr_down]
    xaxis_stp_down = TR_TI_tc[varStp_down]

    plt.plot(TR_TI_tc,curr_roi,c='y')


#    plt.plot(TR_tc,lstTxt_normne[txtid],c='y')
    plt.ylim([-1.8,2.2])
    
    plt.scatter(TR_TI_tc[varStr_GW] ,curr_roi[varStr_GW,0],c='g',marker='*')
    plt.scatter(TR_TI_tc[varStp_GW] ,curr_roi[varStp_GW,0],c='c',marker='*')

    plt.scatter(xaxis_str_up ,curr_roi[varStr,0],c='g',marker='<')
    plt.scatter(xaxis_stp_up ,arytmp[varStp,0],c='c',marker='>')
    
    plt.scatter(TR_TI_tc[varStr_WG] ,curr_roi[varStr_WG,0],c='g',marker='*')
    plt.scatter(TR_TI_tc[varStp_WG] ,curr_roi[varStp_WG,0],c='c',marker='*')

    plt.scatter(TR_TI_tc[varStr_GB] ,curr_roi[varStr_GB,0],c='red',marker='*')
    plt.scatter(TR_TI_tc[varStp_GB] ,curr_roi[varStp_GB,0],c='k',marker='*')


    plt.scatter(xaxis_str_down ,curr_roi[varStr_down,0],c='red',marker='<')
    plt.scatter(xaxis_stp_down ,curr_roi[varStp_down,0],c='k',marker='>')
    
    plt.scatter(TR_TI_tc[varStr_BG] ,curr_roi[varStr_BG,0],c='red',marker='*')
    plt.scatter(TR_TI_tc[varStp_BG] ,curr_roi[varStp_BG,0],c='k',marker='*')
    plt.legend(['Data','Str_G2W','Stp_G2W','Str_up','Stp_up','Str_W2G','Stp_W2G','Str_G2B','Stp_G2B','Str_down','Stp_down','Str_B2G','Stp_B2G'],loc=1)
    
    plt.title('Fun_0' + str(counter+1) + '_stimulus_events_In_center' )
    plt.savefig('Fun_0' + str(counter+1) + '_stimulus_events_In_center' + '.png')


plt.close('all')
# =============================================================================
# =============================================================================
# This section is for create event-related average

# =============================================================================
#    
#
#for conid in range(0 , len(aryNme)):
#    if conid in [0, 1]:
#        tmpTitle = aryNme[0].split('_')[0] + '_' +  aryNme[0].split('_')[1]
#        
#    elif conid in [2,3]:
#        tmpTitle = aryNme[2].split('_')[0] + aryNme[2].split('_')[1]
#
#    elif conid in [4,5]:
#        tmpTitle = aryNme[4].split('_')[0] + aryNme[4].split('_')[1]
#    
#    elif conid in [6,7]:
#        tmpTitle = aryNme[6].split('_')[0] + aryNme[6].split('_')[1]
#    
#    elif conid in [8,9]:
#        tmpTitle = aryNme[8].split('_')[0] + aryNme[8].split('_')[1]
#    
#    elif conid in [10,11]:
#        tmpTitle = aryNme[10].split('_')[0] + aryNme[10].split('_')[1]
#    
#    elif conid in [12,13]:
#        tmpTitle = aryNme[12].split('_')[0] + aryNme[12].split('_')[1]
#    
#    elif conid in [14,15]:
#        tmpTitle = aryNme[14].split('_')[0] + aryNme[14].split('_')[1]
#    
#    else:
#        tmpTitle = aryNme[16].split('_')[0] + aryNme[16].split('_')[1]
#
#                                
#    tmpMtrx = lstEnd_norm[conid][0]
#    if conid % 2 == 0:
#         plt.figure(conid)
#
#         tmplstcond = ['up' for i in range(tmpMtrx.size)]
#         tmpTimepoint = [k for i in range(tmpMtrx.shape[0]) for j in range(tmpMtrx.shape[1]) for k in range(varSegDur)]
#         tmparray = tmpMtrx.reshape(-1)
#    
#
#    else:
#        
#        for i in range(tmpMtrx.shape[0]):
#            for j in range(tmpMtrx.shape[1]):
#                for k in range(varSegDur):
#                    tmpTimepoint.append(k)
#                    tmplstcond.append('down')
#        aryvalue = np.append(tmparray,tmpMtrx.reshape(-1))           
#         
#        timepoint=np.asarray(tmpTimepoint)
#        lstcond=np.asarray(tmplstcond)    
#        vardict={"TimePoint":timepoint,"BOLD signal change %":aryvalue,"cond":lstcond}
#
#        vardata = pd.DataFrame(vardict)
#        ax=sns.lineplot(x="TimePoint",y="BOLD signal change %",hue="cond",style="cond",data=vardata)
#        ax.set_title(tmpTitle)
#        plt.hlines(0,0,varSegDur,'b','dashed')
#        plt.hlines(-1.5,varTmepre,varTmepre+(5*varTR),'k','solid')
#        plt.savefig(tmpTitle+'_neg_only_first_fix.svg')

     

#
# =============================================================================
##-------------------------------------------------------------------------------
