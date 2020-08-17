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
varDur = 13.0
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
strdm_txt = 'GLM/Anat_space/fslmeants/'
os.chdir(data_path + strdm_txt)
AllTxtFiles=glob.glob('*.txt')


# Chose certain mask
#TmpTextFiles = []
#for txtid in range(len(AllTxtFiles)):
#    interp_01 = AllTxtFiles[txtid].split('_')
#
#    if ((interp_01[2] == 'v1' or interp_01[2] == 'v2') and \
#        interp_01[3] == 'center'):
#        TmpTextFiles.append(AllTxtFiles[txtid])
#


# Empty list that will be filled with the list of csv data:
# varNumIn_01 = len(TmpTextFiles)
varNumIn_01 = len(AllTxtFiles)

lstTxt      = [None] * varNumIn_01


# Directory containing design matrices (EV files):
strdm = 'DM/'
strPathEV = data_path + strdm

# List of design matrices (EV files), in the same order as input 4D nii files
# (location within parent directory):
# lstIn_02 = '20191217_BI_7T_fMRI_Run_01_Lum_Up.txt'
lstIn_02 = ['20200717_BI_7T_fMRI_Run_01_Lum_Up.txt',
            '20200717_BI_7T_fMRI_Run_02_Lum_Up.txt',
            '20200717_BI_7T_fMRI_Run_03_Lum_Up.txt',
            '20200717_BI_7T_fMRI_Run_05_Lum_Up.txt',
            '20200717_BI_7T_fMRI_Run_06_Lum_Up.txt']

lstIn_03 = ['20200717_BI_7T_fMRI_Run_01_Lum_Down.txt',
            '20200717_BI_7T_fMRI_Run_02_Lum_Down.txt',
            '20200717_BI_7T_fMRI_Run_03_Lum_Down.txt',
            '20200717_BI_7T_fMRI_Run_05_Lum_Down.txt',
            '20200717_BI_7T_fMRI_Run_06_Lum_Down.txt']


strPathOut = (data_path + 'GLM/ERA/')
os.chdir(strPathOut)
#if ~os.path.isdir(strPathOut):
#    os.mkdir(strPathOut)
os.chdir(strPathOut)

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

# Empty list that will be filled with the list of csv data:
lstEV_up = [None] * varNumIn_02

lstEV_down = [None] * varNumIn_03

lstTxt  =  [None] * varNumIn_01

lstTxt_mean = [None] * varNumIn_01
# Load meants txt files
for index_01 in range(0, varNumIn_01):


    print('---Loading: ' + AllTxtFiles[index_01])

    # Read text file:
    aryTmp = np.loadtxt(
                        (data_path + strdm_txt + AllTxtFiles[index_01]),
                        skiprows=3
                        )

    # Append current csv object to list:
    lstTxt[index_01] = np.copy(aryTmp)
    lstTxt_mean[index_01] = np.mean(aryTmp,axis = 1)



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


# Temporal interpolation
lstTxt_ti = []
for txtid in range(0, len(AllTxtFiles)):
# for txtid in range(0,len(TmpTextFiles)):
    arytmp = np.zeros([len(TR_TI_tc),1])
#    plt.figure(txtid)
    # The reason why I chose the current parameters is that it didn't give
    # extreme values at the boundary.
    # tx = UnivariateSpline(TR_tc,lstTxt[0][:,i])
    # tx =  CubicSpline(TR_tc,lstTxt[0][:,i])
    # tx = InterpolatedUnivariateSpline(TR_tc,lstTxt[0][:,i])
    # plt.plot(TR_TI_tc,tx(TR_TI_tc))
    # plt.plot(TR_tc,lstTxt[txtid][:,i],'ro')

    tx = interp1d(TR_tc,lstTxt_mean[txtid],
                  kind="cubic",
                  axis=-1,
                  copy=True,
                  bounds_error=False,
                  fill_value="extrapolate",
                  assume_sorted=False)

    arytmp[:,0] = tx(TR_TI_tc)
    # Save the array
    plt.plot(TR_TI_tc[0:-2],tx(TR_TI_tc)[0:-2])
    plt.plot(TR_tc,lstTxt_mean[txtid],'ro')
    plt.title(" ".join(AllTxtFiles[txtid].split('_')[0:-2]))
    plt.savefig("_".join(AllTxtFiles[txtid].split('_')[0:-2]) + '.svg')
    plt.savefig("_".join(AllTxtFiles[txtid].split('_')[0:-2]) + '.png')

#    plt.title(" ".join(TmpTextFiles[txtid].split('_')[0:-2]))
#    plt.savefig("_".join(TmpTextFiles[txtid].split('_')[0:-2]) + '.svg')
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
# This section is to plot the up and down condition in the same figure
# =============================================================================
# =============================================================================
aryNme = []
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
             aryNme.append(ocROI[index_02] \
                     + '_' + stiROI[index_03] + '_' + stiCond[index_04])

for conid in range(0 ,len(aryNme),2):


     tmpTitle = "_".join(aryNme[conid].split('_')[0:2])


     tmpMtrx = lstEnd_glb_norm[conid]
     tmpMtrx_01 = lstEnd_glb_norm[conid+1]
#     tmpMtrx = lstEnd_lb_norm[conid]
#     tmpMtrx_01 = lstEnd_lb_norm[conid+1]

 #    tmpMtrx_gb = lstEnd_gb_norm[conid]
 #    tmpMtrx_glb = lstEnd_glb_norm[conid]


     plt.figure(conid)
     plt.plot(xaxis_sec,tmpMtrx)
     plt.plot(xaxis_sec,tmpMtrx_01)
     plt.ylim([-.3,1.1])

     plt.hlines(0,0,14,linestyles='dashed')
     plt.xlabel('Time / Seconds')
     plt.ylabel('% BOLD change')
     plt.legend(['Lum_up','Lum_down','Stimulus'],loc=1)
     plt.title(tmpTitle)
     plt.savefig(tmpTitle+'_glb.svg')
     plt.savefig(tmpTitle+'_glb.png')

#
# =============================================================================
##-------------------------------------------------------------------------------
