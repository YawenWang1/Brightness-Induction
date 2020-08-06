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

strPathOut = '/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/BI/test/ERA'
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

# -----------------------------------------------------------------------------
# =============================================================================
# This section is to plot event-related averages in all the runs separately
# =============================================================================
# *** Create average

# Get all the up conditions
# The odd indices are the down conditions, even indices are the up conditions
# Loop through runs:
ocROI  = ['v3']
#ocROI = ['v1', 'v2']
# stiROI = ['center']
#stiROI = ['center', 'background', 'edge']
#stiROI = ['center', 'background','edge']
stiROI = ['center', 'background']

stiCond = ['up', 'down']
# Three ROIs in the occipital lobe
lstEnd = []
lstEnd_gb_norm, lstEnd_lb_norm, lstEnd_glb_norm = [], [], []
lstBse = []
counter = 0
for index_02 in range(0, len(ocROI)):
    # Three areas about stimulus (center, edge, background)
    for index_03 in range(0, len(stiROI)):
        # Two conditions [up and down]
        for index_04 in range(0, len(stiCond)):
            if index_04 == 0:
                # if the conditon is up then use lstEV_up
                varCEV = lstEV_up[index_04]
            else:
                # if the conditon is down then use lstEV_down
                varCEV = lstEV_down[index_04]

            varTmpNumBlck = len(varCEV[:, 0])
            # 18 condtions
            vartmpCond = []
            # Six functional runs
            vartmpFun = []

            vartmpFun_gb_norm = np.zeros([varNumIn_02,varSegDur])
            vartmpFun_lb_norm = np.zeros([varNumIn_02,varSegDur])
            vartmpFun_glb_norm = np.zeros([varNumIn_02,varSegDur])

            vartmpCond_norm = []

            counter+= 1
            runid = -1
            for index_05 in [1,2,3,5,6]:
                runid += 1
                print (runid)
                # current condition to be worked on
                varCCond = 'fun_0' + str((index_05)) + '_' +  ocROI[index_02] \
                    + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
                    + '_meants_tc.txt'

                # find the index in the orginal text file lists
                varCindex = AllTxtFiles.index(varCCond)
                # varCindex = TmpTextFiles.index(varCCond)
                # Reshaping the array goes from columns first and then rows
                # get the interpolated matrix by the index
                varCCond_tc = lstTxt_ti[varCindex]

                # Global baseline
                varRestTme = np.asarray(
                                        [varCCond_tc[varVolmovsec:48], \
                                        varCCond_tc[-varVolmovsec-16:-varVolmovsec]]
                                        )
                varRestTme_01 = np.mean(varRestTme[0])
                varRestTme_02 = np.mean(varRestTme[1])
                varRestTme_03 = np.divide((varRestTme_01 + varRestTme_02),2)

                plt.figure(counter)
                plt.plot(varRestTme[0])
                plt.plot(varRestTme[1])
                plt.hlines(varRestTme_03,0,16)
                plt.plot(varCCond_tc[0:-2])
                plt.legend(['Begining of the Run','End of the Run', \
                            'Mean'])
                plt.title('fun_0' + str((index_05)) + '_' +  ocROI[index_02] \
                    + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
                    + '_global baseline')
                plt.savefig('fun_0' + str((index_05)) + '_' +  ocROI[index_02] \
                    + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
                    + '_global baseline.svg')
                plt.savefig('fun_0' + str((index_05)) + '_' +  ocROI[index_02] \
                    + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
                    + '_global baseline.png')


#                varRestTme_02 = np.transpose(np.mean(varRestTme_01, axis=1))
                varStr = (varCEV[:,0] - varTmepre).astype(int)
                varStp = np.ceil(varStr + varDur).astype(int)

                counter += 1
                plt.figure(counter)
                plt.plot(varCCond_tc[0:-2],c='y')
                xaxis_str = TR_TI_tc[varStr]
                xaxis_stp = TR_TI_tc[varStp]
                plt.scatter(varStr ,varCCond_tc[varStr],c='g',marker='<')
                plt.scatter(varStp ,varCCond_tc[varStp],c='r',marker='>')
                plt.hlines(varRestTme_03,0,len(TR_TI_tc)-2,linestyles='dashed')
                plt.legend(['Interpolated_data','Start','End','Global Baseline'])
                plt.title('fun_0' + str((index_05)) + '_' +  ocROI[index_02] \
                    + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
                    + '_Event')
                plt.savefig('fun_0' + str((index_05)) + '_' +  ocROI[index_02] \
                    + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
                    + '_Event.svg')
                plt.savefig('fun_0' + str((index_05)) + '_' +  ocROI[index_02] \
                    + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
                    + '_Event.png')

                varSeg = np.zeros([varTmpNumBlck,varSegDur])

                # local baseline for each stimuli
                varBse = np.zeros([varTmpNumBlck,BaseDur])

                for index_06 in range(0, varTmpNumBlck):

                    varSeg[index_06,:] = np.transpose(
                            varCCond_tc[
                                        varStr[index_06] -int(varTmepre): \
                                        varStr[index_06] -int(varTmepre) + varSegDur]
                            )

                    # *** Normalisation

                    if lgcNorm:


                        varBse[index_06,:] = np.transpose(
                                varCCond_tc[
                                            varStr[index_06] - BaseDur:varStr[index_06]]
                                )
                if lgcNorm:

                    # Global baseline
                    varSeg_perc = np.transpose((np.divide(varSeg,varRestTme_03) - 1) * 100)
                    counter += 1
                    xaxis_sec = np.arange(-5,45)
                    plt.figure(counter)
                    plt.plot(xaxis_sec,varSeg_perc)
                    plt.hlines(0,0,14,linestyles="dashed")
                    plt.ylim([-2,3])

                    plt.ylabel('% BOLD change Global Baseline')
                    plt.xlabel('Time / Seconds')
                    plt.legend(['Block1','Block2','Block3','Block4','Block5','Block6'])
                    plt.title('fun_0' + str((index_05)) + '_' +  ocROI[index_02] \
                    + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
                    + '_% BOLD_change_Per_Block_GB')
                    plt.savefig('fun_0' + str((index_05)) + '_' +  ocROI[index_02] \
                    + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
                    + '_% BOLD_change_Per_Block_GB.svg')
                    plt.savefig('fun_0' + str((index_05)) + '_' +  ocROI[index_02] \
                    + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
                    + '_% BOLD_change_Per_Block_GB.png')


                    varSeg_perc_mean = np.mean(varSeg_perc,axis=1)
                    counter += 1
                    plt.figure(counter)
                    plt.plot(xaxis_sec,varSeg_perc_mean)
                    plt.hlines(0,0,14,linestyles="dashed")
                    plt.ylabel('% BOLD change Global Baseline')
                    plt.xlabel('Time / Seconds')
                    plt.ylim([-2,3])

                    plt.legend(['ERA','Stimulus'],loc=1)
                    plt.title('fun_0' + str((index_05)) + '_' +  ocROI[index_02] \
                    + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
                    + '_% BOLD_change_GB')
                    plt.savefig('fun_0' + str((index_05)) + '_' +  ocROI[index_02] \
                    + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
                    + '_% BOLD_change_GB.svg')
                    plt.savefig('fun_0' + str((index_05)) + '_' +  ocROI[index_02] \
                    + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
                    + '_% BOLD_change_GB.png')


                    # Mean for each voxel over time (i.e. over the pre-stimulus
                    varBseMne = np.mean(varBse,axis=1)
                    varSeg_perc_bse = (np.divide(np.transpose(varSeg),varBseMne) -1 ) * 100
                    counter += 1
                    plt.figure(counter)
                    plt.plot(xaxis_sec,varSeg_perc_bse)
                    plt.hlines(0,0,14,linestyles="dashed")
                    plt.ylim([-2,3])

                    plt.ylabel('% BOLD change local Baseline')
                    plt.xlabel('Time / Seconds')

                    plt.legend(['Block1','Block2','Block3','Block4','Block5','Block6'],loc=1)
                    plt.title('fun_0' + str((index_05)) + '_' +  ocROI[index_02] \
                    + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
                    + '_% BOLD_change_Per_Block_LB')
                    plt.savefig('fun_0' + str((index_05)) + '_' +  ocROI[index_02] \
                    + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
                    + '_% BOLD_change_Per_Block_LB.svg')



                    varSeg_perc_bse_mean = np.mean(varSeg_perc_bse,axis=1)
                    counter += 1
                    plt.figure(counter)
                    plt.plot(xaxis_sec,varSeg_perc_bse_mean)
                    plt.hlines(0,0,14,linestyles="dashed")
                    plt.ylabel('% BOLD change local Baseline')
                    plt.xlabel('Time / Seconds')
                    plt.ylim([-2,3])

                    plt.legend(['ERA','Stimulus'],loc=1)

                    plt.title('fun_0' + str((index_05)) + '_' +  ocROI[index_02] \
                    + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
                    + '_% BOLD_change_LB')
                    plt.savefig('fun_0' + str((index_05)) + '_' +  ocROI[index_02] \
                    + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
                    + '_% BOLD_change_LB.svg')
                    plt.savefig('fun_0' + str((index_05)) + '_' +  ocROI[index_02] \
                    + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
                    + '_% BOLD_change_LB.png')

                    # Consider global baseline and local baseline

                    varRestBse = (varBseMne + varRestTme_03)/2
                    varSeg_perc_restbse = (np.divide(np.transpose(varSeg),varRestBse) -1) * 100
                    counter += 1
                    plt.figure(counter)
                    plt.plot(xaxis_sec,varSeg_perc_restbse)
                    plt.hlines(0,0,14,linestyles="dashed")
                    plt.ylim([-2,3])

                    plt.ylabel('% BOLD change local and global Baseline')
                    plt.xlabel('Time / Seconds')
                    plt.legend(['Block1','Block2','Block3','Block4','Block5','Block6'],loc=1)
                    plt.title('fun_0' + str((index_05)) + '_' +  ocROI[index_02] \
                    + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
                    + '_% BOLD_change_Per_Block_GLB')
                    plt.savefig('fun_0' + str((index_05)) + '_' +  ocROI[index_02] \
                    + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
                    + '_% BOLD_change_Per_Block_GLB.svg')
                    plt.savefig('fun_0' + str((index_05)) + '_' +  ocROI[index_02] \
                    + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
                    + '_% BOLD_change_Per_Block_GLB.png')


                    varSeg_perc_restbse_mean = np.mean(varSeg_perc_restbse,axis=1)
                    counter += 1
                    plt.figure(counter)
                    plt.plot(xaxis_sec,varSeg_perc_restbse_mean)
                    plt.hlines(0,0,14,linestyles="dashed")
                    plt.ylabel('% BOLD change local and global Baseline')
                    plt.xlabel('Time / Seconds')
                    plt.ylim([-2,3])
                    plt.legend(['ERA','Stimulus'],loc=1)
                    plt.title('fun_0' + str((index_05)) + '_' +  ocROI[index_02] \
                    + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
                    + '_% BOLD_change_GLB')
                    plt.savefig('fun_0' + str((index_05)) + '_' +  ocROI[index_02] \
                    + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
                    + '_% BOLD_change_GLB.svg')
                    plt.savefig('fun_0' + str((index_05)) + '_' +  ocROI[index_02] \
                    + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
                    + '_% BOLD_change_GLB.png')

                # Average among runs
                if lgcNorm:

                    vartmpFun_gb_norm[runid,:] = varSeg_perc_mean

                    vartmpFun_lb_norm[runid,:] = varSeg_perc_bse_mean


                    vartmpFun_glb_norm[runid,:] = varSeg_perc_restbse_mean

                    # Save the segments for each run
                    vartmpFun.append(varSeg)

            counter += 1
            plt.figure(counter)
            plt.plot(xaxis_sec,np.transpose(vartmpFun_lb_norm))
            plt.hlines(0,0,14,linestyles="dashed")
            plt.legend(['Run1','Run2','Run3','Run4','Run5','Run6'],loc=1)
            plt.xlabel('Time / Seconds')
            plt.ylabel('% BOLD change local Baseline')
            plt.ylim([-2,3])

            plt.title(ocROI[index_02] \
            + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
            + '_each_run_LB')
            plt.savefig(ocROI[index_02] \
            + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
            + '_each_run_LB.svg')
            plt.savefig(ocROI[index_02] \
            + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
            + '_each_run_LB.png')


            counter += 1
            plt.figure(counter)
            plt.plot(xaxis_sec,np.transpose(vartmpFun_gb_norm))
            plt.hlines(0,0,14,linestyles="dashed")
            plt.legend(['Run1','Run2','Run3','Run4','Run5','Run6'],loc=1)
            plt.xlabel('Time / Seconds')
            plt.ylabel('% BOLD change global Baseline')
            plt.ylim([-2,3])

            plt.title(ocROI[index_02] \
            + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
            + '_each_run_GB')
            plt.savefig(ocROI[index_02] \
            + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
            + '_each_run_GB.svg')
            plt.savefig(ocROI[index_02] \
            + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
            + '_each_run_GB.png')


            counter += 1
            plt.figure(counter)
            plt.plot(xaxis_sec,np.transpose(vartmpFun_glb_norm))
            plt.hlines(0,0,14,linestyles="dashed")
            plt.ylim([-2,3])
            plt.legend(['Run1','Run2','Run3','Run4','Run5','Run6'],loc=1)
            plt.xlabel('Time / Seconds')
            plt.ylabel('% BOLD change global and local Baseline')
            plt.title(ocROI[index_02] \
            + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
            + '_each_run_GLB')
            plt.savefig(ocROI[index_02] \
            + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
            + '_each_run_GLB.svg')
            plt.savefig(ocROI[index_02] \
            + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
            + '_each_run_GLB.png')



            varAmgRunMne_gb = np.mean(vartmpFun_gb_norm,axis=0)
            varAmgRunMne_lb = np.mean(vartmpFun_lb_norm,axis=0)
            varAmgRunMne_glb = np.mean(vartmpFun_glb_norm,axis=0)

            counter += 1
            plt.figure(counter)
            plt.plot(xaxis_sec,varAmgRunMne_gb)
            plt.plot(xaxis_sec,varAmgRunMne_lb)
            plt.plot(xaxis_sec,varAmgRunMne_glb)
            plt.hlines(0,0,14,linestyles="dashed")
            plt.xlabel('Time / Seconds')
            plt.ylabel('% BOLD change')
            plt.ylim([-2,3])
            plt.legend(['global baseline','local baseline','Both','stimulus'],loc=1)
            plt.title(ocROI[index_02] \
                + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
                + '_all_runs')
            plt.savefig(ocROI[index_02] \
                + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
                + '_all_runs.svg')
            plt.savefig(ocROI[index_02] \
                + '_' + stiROI[index_03] + '_' + stiCond[index_04] \
                + '_all_runs.png')



            lstEnd.append(vartmpCond)
            lstEnd_gb_norm.append(varAmgRunMne_gb)
            lstEnd_lb_norm.append(varAmgRunMne_lb)
            lstEnd_glb_norm.append(varAmgRunMne_glb)
            plt.close('all')

     
     
     
  
# =============================================================================
# This section is to plot background roi for all the conditions
lst_bkgrd=np.zeros([6,len(lstTxt_ti[0])])
counter = -1
for runid in range(0,len(AllTxtFiles),2):
#     print (runid)
    lst_bkgrd[counter,:] =  lstTxt_ti[runid]
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
    
    plt.scatter(TR_TI_tc[varStr_GW] ,arytmp[varStr_GW,0],c='g',marker='*')
    plt.scatter(TR_TI_tc[varStp_GW] ,arytmp[varStp_GW,0],c='c',marker='*')

    plt.scatter(xaxis_str_up ,arytmp[varStr,0],c='g',marker='<')
    plt.scatter(xaxis_stp_up ,arytmp[varStp,0],c='c',marker='>')
    
    plt.scatter(TR_TI_tc[varStr_WG] ,arytmp[varStr_WG,0],c='g',marker='*')
    plt.scatter(TR_TI_tc[varStp_WG] ,arytmp[varStp_WG,0],c='c',marker='*')

    plt.scatter(TR_TI_tc[varStr_GB] ,arytmp[varStr_GB,0],c='red',marker='*')
    plt.scatter(TR_TI_tc[varStp_GB] ,arytmp[varStp_GB,0],c='k',marker='*')


    plt.scatter(xaxis_str_down ,arytmp[varStr_down,0],c='red',marker='<')
    plt.scatter(xaxis_stp_down ,arytmp[varStp_down,0],c='k',marker='>')
    
    plt.scatter(TR_TI_tc[varStr_BG] ,arytmp[varStr_BG,0],c='red',marker='*')
    plt.scatter(TR_TI_tc[varStp_BG] ,arytmp[varStp_BG,0],c='k',marker='*')
    plt.legend(['Data','Str_G2W','Stp_G2W','Str_up','Stp_up','Str_W2G','Stp_W2G','Str_G2B','Stp_G2B','Str_down','Stp_down','Str_B2G','Stp_B2G'],loc=0)
    
    plt.title('Fun_0' + str(counter+1) + '_stimulus_events_In_bkgrd' )
    plt.savefig('Fun_0' + str(counter+1) + '_stimulus_events_In_bkgrd' + '.png')


lst_bkgrd_mne = np.mean(lst_bkgrd,axis=1)
# =============================================================================

# =============================================================================
lst_ctr=np.zeros([6,len(lstTxt_ti[0])])
counter = -1
for runid in range(1,len(AllTxtFiles),2):
#     print (runid)
    lst_ctr[counter,:] =  lstTxt_ti[runid]
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
    
    plt.scatter(TR_TI_tc[varStr_GW] ,arytmp[varStr_GW,0],c='g',marker='*')
    plt.scatter(TR_TI_tc[varStp_GW] ,arytmp[varStp_GW,0],c='c',marker='*')

    plt.scatter(xaxis_str_up ,arytmp[varStr,0],c='g',marker='<')
    plt.scatter(xaxis_stp_up ,arytmp[varStp,0],c='c',marker='>')
    
    plt.scatter(TR_TI_tc[varStr_WG] ,arytmp[varStr_WG,0],c='g',marker='*')
    plt.scatter(TR_TI_tc[varStp_WG] ,arytmp[varStp_WG,0],c='c',marker='*')

    plt.scatter(TR_TI_tc[varStr_GB] ,arytmp[varStr_GB,0],c='red',marker='*')
    plt.scatter(TR_TI_tc[varStp_GB] ,arytmp[varStp_GB,0],c='k',marker='*')


    plt.scatter(xaxis_str_down ,arytmp[varStr_down,0],c='red',marker='<')
    plt.scatter(xaxis_stp_down ,arytmp[varStp_down,0],c='k',marker='>')
    
    plt.scatter(TR_TI_tc[varStr_BG] ,arytmp[varStr_BG,0],c='red',marker='*')
    plt.scatter(TR_TI_tc[varStp_BG] ,arytmp[varStp_BG,0],c='k',marker='*')
    plt.legend(['Data','Str_G2W','Stp_G2W','Str_up','Stp_up','Str_W2G','Stp_W2G','Str_G2B','Stp_G2B','Str_down','Stp_down','Str_B2G','Stp_B2G'],loc=0)
    
    plt.title('Fun_0' + str(counter+1) + '_stimulus_events_In_center' )
    plt.savefig('Fun_0' + str(counter+1) + '_stimulus_events_In_center' + '.png')

lst_ctr_mne = np.mean(lst_ctr,axis=1)

# =============================================================================

    

for conid in range(0 , len(aryNme)):
    if conid in [0, 1]:
        tmpTitle = aryNme[0].split('_')[0] + '_' +  aryNme[0].split('_')[1]
        
    elif conid in [2,3]:
        tmpTitle = aryNme[2].split('_')[0] + aryNme[2].split('_')[1]

    elif conid in [4,5]:
        tmpTitle = aryNme[4].split('_')[0] + aryNme[4].split('_')[1]
    
    elif conid in [6,7]:
        tmpTitle = aryNme[6].split('_')[0] + aryNme[6].split('_')[1]
    
    elif conid in [8,9]:
        tmpTitle = aryNme[8].split('_')[0] + aryNme[8].split('_')[1]
    
    elif conid in [10,11]:
        tmpTitle = aryNme[10].split('_')[0] + aryNme[10].split('_')[1]
    
    elif conid in [12,13]:
        tmpTitle = aryNme[12].split('_')[0] + aryNme[12].split('_')[1]
    
    elif conid in [14,15]:
        tmpTitle = aryNme[14].split('_')[0] + aryNme[14].split('_')[1]
    
    else:
        tmpTitle = aryNme[16].split('_')[0] + aryNme[16].split('_')[1]

                                
    tmpMtrx = lstEnd_norm[conid][0]
    if conid % 2 == 0:
         plt.figure(conid)

         tmplstcond = ['up' for i in range(tmpMtrx.size)]
         tmpTimepoint = [k for i in range(tmpMtrx.shape[0]) for j in range(tmpMtrx.shape[1]) for k in range(varSegDur)]
         tmparray = tmpMtrx.reshape(-1)
    

    else:
        
        for i in range(tmpMtrx.shape[0]):
            for j in range(tmpMtrx.shape[1]):
                for k in range(varSegDur):
                    tmpTimepoint.append(k)
                    tmplstcond.append('down')
        aryvalue = np.append(tmparray,tmpMtrx.reshape(-1))           
         
        timepoint=np.asarray(tmpTimepoint)
        lstcond=np.asarray(tmplstcond)    
        vardict={"TimePoint":timepoint,"BOLD signal change %":aryvalue,"cond":lstcond}

        vardata = pd.DataFrame(vardict)
        ax=sns.lineplot(x="TimePoint",y="BOLD signal change %",hue="cond",style="cond",data=vardata)
        ax.set_title(tmpTitle)
        plt.hlines(0,0,varSegDur,'b','dashed')
        plt.hlines(-1.5,varTmepre,varTmepre+(5*varTR),'k','solid')
        plt.savefig(tmpTitle+'_neg_only_first_fix.svg')

     

#
# =============================================================================
##-------------------------------------------------------------------------------
