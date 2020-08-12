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
from scipy import stats
#sns.set_style("white")

# *** Check time
#varTme_01 = time.clock()


# Volume TR of input nii files:
varTR = 2.604

# Number of Volumes of input nii files:
varNumVol = 258

# Number ofRuns
varNumRun = 6

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
varDur = 5
# Number of volumes removes at the beginning and the end
varVolmov = 5
# how long would it be removed in seconds
varVolmovsec = np.ceil(varVolmov * varTR).astype(int)

# If normalisation is performed, which time points to use as baseline, relative
# to the stimulus condition onset. (I.e., if you specify -3 and 0, the three
# volumes preceeding the onset of the stimulus are used - the interval is
# non-inclusive at the end.)
tplBase = (-2, 0)
BaseDur = int(np.absolute(tplBase[0]) + varDur + varVolsPst)

# This corresponds to the 220 volumes in the functional data
TR_tc = np.arange(0,varNumVol)

# This is interpolated x axis
TR_TI_tc = np.linspace(0,varNumVol,int(np.round(varTR*varNumVol)))

# Load environmental variables defining the input data path:
data_path = '/media/h/P04/Data/BIDS/sub-02/ses-002/func/'

# Change to the directory and Get all the text filenames
meantsPth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/BI/fslmeants_pt005'
os.chdir(meantsPth)
AllTxtFiles=glob.glob('*.txt')




# Empty list that will be filled with the list of csv data:
# varNumIn_01 = len(TmpTextFiles)
varNumIn_01 = len(AllTxtFiles)

lstTxt      = [None] * varNumIn_01


# Directory containing design matrices (EV files):
strdmPth = 'GLM/BI/'
strPathEV = data_path + strdmPth
strdm = 'design.mat'

# List of design matrices (EV files), in the same order as input 4D nii files
# (location within parent directory):
# lstIn_02 = '20191217_BI_7T_fMRI_Run_01_Lum_Up.txt'
lstIn_02 = ['BI_fun_01_MoCo_Dist_Corr_Coreg_7EV.feat',
            'BI_fun_02_MoCo_Dist_Corr_Coreg_7EV.feat',
            'BI_fun_03_MoCo_Dist_Corr_Coreg_7EV.feat',
            'BI_fun_04_MoCo_Dist_Corr_Coreg_7EV.feat',
            'BI_fun_05_MoCo_Dist_Corr_Coreg_7EV.feat',
            'BI_fun_06_MoCo_Dist_Corr_Coreg_7EV.feat']



strPathOut = '/media/h/P04/Data/BIDS/sub-02/ses-002/func/GLM/BI/ERA_03'
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



lstTxt  =  [None] * varNumIn_01

lstTxt_mean = [None] * varNumIn_01

lstTxt_norm= [None] * varNumIn_01

lstTxt_runs = [None] * varNumRun

lstTxt_mne_norm = [None] * varNumIn_01

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
    mne_aryTmp = np.mean(aryTmp)
    std_aryTmp = np.std(aryTmp)
    tmp_aryTmp = np.subtract(aryTmp,mne_aryTmp)
    norm_aryTmp = np.divide(tmp_aryTmp,std_aryTmp)
    lstTxt_mean[index_01] = np.mean(aryTmp,axis=1)
    lstTxt_norm[index_01] = norm_aryTmp
    lstTxt_mne_norm[index_01] = np.mean(norm_aryTmp,axis=1)
   
lstDM=[None] * varNumIn_02

# Load design matrices (EV files):
for index_01 in range(0, varNumIn_02):


    print('---Loading: ' + lstIn_02[index_01]+ '/' + strdm)

    # Read text file:
    aryTmp = np.loadtxt(
                        (strPathEV + lstIn_02[index_01] + '/' + strdm),
                        skiprows=5
                        )
    # Append current csv object to list:
    lstDM[index_01] = np.copy(aryTmp)





# =============================================================================
# Plot design matrices and whole time course  
counter = 0    
for runid in range(0,varNumIn_02):
     currplt_bkgrd = np.zeros([varNumVol,8])
     currplt_ctr = np.zeros([varNumVol,8])
     currplt_bkgrd[:,0:7], currplt_ctr[:,0:7] = lstDM[runid],lstDM[runid]
     currplt_bkgrd[:,7],currplt_ctr[:,7] =  lstTxt_mne_norm[2*runid], lstTxt_mne_norm[(2*runid)+1]
     counter+=1
     plt.figure(counter,figsize=(14,8))
     plt.plot(currplt_bkgrd)
     plt.legend(['Lum_incre','Lum_decre','Tar','G2W','W2G','G2B','B2G','Background'],loc=1)
     plt.title('fun_' + str(runid+1) + '_Background_7EV')
     plt.savefig('fun_' + str(runid+1) + '_Background_7EV'+'.svg')
     plt.savefig('fun_' + str(runid+1) + '_Background_7EV'+'.png')
     

     counter+=1
     plt.figure(counter,figsize=(14,8))

     plt.plot(currplt_ctr)
     plt.legend(['Lum_incre','Lum_decre','Tar','G2W','W2G','G2B','B2G','Center'],loc=1)
     plt.title('fun_' + str(runid+1) + '_Center_7EV')
     plt.savefig('fun_' + str(runid+1) + '_Center_7EV'+'.svg')
     plt.savefig('fun_' + str(runid+1) + '_Center_7EV'+'.png')

     currplt_01_bkgrd,  currplt_01_ctr= np.zeros([varNumVol,4]) , np.zeros([varNumVol,4])
     currplt_01_bkgrd[:,0] = lstDM[runid][:,0] + lstDM[runid][:,3]+ lstDM[runid][:,4]
     currplt_01_bkgrd[:,2] = lstDM[runid][:,2]

     currplt_01_bkgrd[:,1] = lstDM[runid][:,1] + lstDM[runid][:,5] +lstDM[runid][:,6]
     currplt_01_bkgrd[:,3] = lstTxt_mne_norm[2*runid]
     currplt_01_ctr[:,0] = lstDM[runid][:,0] + lstDM[runid][:,3]+ lstDM[runid][:,4]
     currplt_01_ctr[:,1] = lstDM[runid][:,1] + lstDM[runid][:,5] +lstDM[runid][:,6]
     currplt_01_ctr[:,3] = lstTxt_mne_norm[(2*runid)+1]
     currplt_01_ctr[:,2] = lstDM[runid][:,2]
          
     counter+=1
     plt.figure(counter,figsize=(14,8))
     plt.plot(currplt_01_bkgrd[:,0:3])
     plt.plot(lstTxt_mne_norm[2*runid],c='grey')
     plt.legend(['Lum_incre','Lum_decre','Tar','Background'],loc=1)
     plt.title('fun_' + str(runid+1) + '_Background_EV_Combined')
     plt.savefig('fun_' + str(runid+1) + '_Background_EV_Combined'+'.svg')
     plt.savefig('fun_' + str(runid+1) + '_Background_EV_Combined'+'.png')

     counter+=1
     plt.figure(counter,figsize=(14,8))

     plt.plot(currplt_01_ctr[:,0:3])
     plt.plot(lstTxt_mne_norm[(2*runid)+1],c='grey')

     plt.legend(['Lum_incre','Lum_decre','Tar','Center'],loc=1)
     plt.title('fun_' + str(runid+1) + '_Center_EV_Combined')
     plt.savefig('fun_' + str(runid+1) + '_Center_EV_Combined'+'.svg')
     plt.savefig('fun_' + str(runid+1) + '_Center_EV_Combined'+'.png')

plt.close('all')
    
# =============================================================================
# This section is for plot event-related average
lstIn_04 = ['20200717_BI_7T_fMRI_Run_01_GW.txt',
            '20200717_BI_7T_fMRI_Run_02_GW.txt',
            '20200717_BI_7T_fMRI_Run_03_GW.txt',
            '20200717_BI_7T_fMRI_Run_04_GW.txt',
            '20200717_BI_7T_fMRI_Run_05_GW.txt',
            '20200717_BI_7T_fMRI_Run_06_GW.txt']

lstIn_06 = ['20200717_BI_7T_fMRI_Run_01_GB.txt',
            '20200717_BI_7T_fMRI_Run_02_GB.txt',
            '20200717_BI_7T_fMRI_Run_03_GB.txt',
            '20200717_BI_7T_fMRI_Run_04_GB.txt',
            '20200717_BI_7T_fMRI_Run_05_GB.txt',
            '20200717_BI_7T_fMRI_Run_06_GB.txt']

# Number of input design matrices:
varNumIn_04 = len(lstIn_04)


# Number of input design matrices:
varNumIn_06 = len(lstIn_06)

lstEV_gw = [None] * varNumIn_04
lstEV_gb = [None] * varNumIn_06
dmPth='/media/h/P04/Data/BIDS/sub-02/ses-002/func/DM_01/'
# Load design matrices (EV files):
for index_01 in range(0, varNumIn_04):


    print('---Loading: ' + lstIn_04[index_01])

    # Read text file:
    aryTmp = np.loadtxt(
                        (dmPth +  lstIn_04[index_01]),
                        skiprows=0
                        )
    # Append current csv object to list:
    lstEV_gw[index_01] = np.copy(aryTmp)
    
# Load design matrices (EV files):
for index_01 in range(0, varNumIn_06):


    print('---Loading: ' + lstIn_06[index_01])

    # Read text file:
    aryTmp = np.loadtxt(
                        (dmPth  + lstIn_06[index_01]),
                        skiprows=0
                        )
    # Append current csv objectBaseDur to list:
    lstEV_gb[index_01] = np.copy(aryTmp)
    
     
stiROI = ['background','center']
counter = 0
ind = np.arange(-2,18,2)  
aryBold =  []
xaxis = np.arange(-2,17)     

for index_01 in range(0, len(stiROI)):
     
     numVoxels = lstTxt[index_01].shape[1]    
               
     varBOLD_perc_up = np.zeros([BaseDur,36])
#     varBOLD_perc_up_01 = np.zeros([BaseDur,36])
     varBOLD_perc_up_mne = np.zeros([BaseDur,6])
#     varBOLD_perc_up_01_mne = np.zeros([BaseDur,6])

     varBOLD_perc_down = np.zeros([BaseDur,36])
#     varBOLD_perc_down_01 = np.zeros([BaseDur,36])
     varBOLD_perc_down_mne = np.zeros([BaseDur,6])
#     varBOLD_perc_down_01_mne = np.zeros([BaseDur,6])
     
     

     for index_02 in range(0, varNumIn_02):
          
         
          
          varCCond = 'fun_0' + str((index_02+1)) + '_' +  \
                    stiROI[index_01]  + '_pt005_meants_tc.txt'
                    
                    
                    
          # find the index in the orginal text file lists
          varCindex = AllTxtFiles.index(varCCond)
          varCCond_tc = lstTxt[varCindex]
     

          currDM_up = lstEV_gw
          currDM_down = lstEV_gb
          
          varCEV_up = currDM_up[index_02]
          varCEV_down = currDM_down[index_02]

          varTmpNumBlck = len(varCEV_up[:,0])

          varStr_up = np.around(np.add(np.divide(varCEV_up[:,0],varTR),tplBase[0])).astype(int)
          varStp_up = np.ceil(varStr_up + np.absolute(tplBase[0]) + varDur + varVolsPst).astype(int)

          varStr_down = np.around(np.add(np.divide(varCEV_down[:,0],varTR),tplBase[0])).astype(int)
          varStp_down = np.ceil(varStr_down + np.absolute(tplBase[0]) + varDur + varVolsPst).astype(int)
          
#          varRestTme = np.mean(varCCond_tc[varVolmov:15,:],axis=0)
                         
          
          # Generate epock
          varBse_up = np.zeros([varTmpNumBlck,numVoxels])
          var_up = np.zeros([BaseDur,varTmpNumBlck])
          var_up_perc = np.zeros([BaseDur,varTmpNumBlck])


          varBse_down = np.zeros([varTmpNumBlck,numVoxels])
          var_down = np.zeros([BaseDur,varTmpNumBlck])
          varBse_down_perc = np.zeros([BaseDur,varTmpNumBlck])
#          varBse_down_perc_01 = np.zeros([BaseDur,numVoxels*varTmpNumBlck])
          #-------------------------------------------------------------------
          # Normalize the whole time course for each voxel in each ROI
          counter +=1
          for index_03 in range(0,varTmpNumBlck):
               # Get every epoch
#               varBse_up[:,index_03] = varCCond_tc_norm_mne[varStr_up[index_03]:varStp_up[index_03]]
#               varBse_down[:,index_03] = varCCond_tc_norm_mne[varStr_down[index_03]:varStp_down[index_03]]

#               # Calculate baseline before every epoch
               varBse_up[index_03,:] = np.mean(varCCond_tc[varStr_up[index_03]:varStr_up[index_03]+2,:],axis=0)
               varBse_down[index_03,:] = np.mean(varCCond_tc[varStr_down[index_03]:varStr_down[index_03]+2,:],axis=0)
               
          varbse_up = np.mean(varBse_up,axis=0)
          varbse_down = np.mean(varBse_down,axis=0)
          varbse = np.divide(np.add(varbse_up,varbse_down),2)
          varCCond_tc_norm = (np.divide(varCCond_tc,varbse) -1 ) *100
          varCCond_tc_norm_mne = np.mean(varCCond_tc_norm,axis=1)
          
          #--------------------------------------------------------------------
          # Get event related average
          var_up = np.zeros([BaseDur,varTmpNumBlck])
          var_up_perc = np.zeros([BaseDur,varTmpNumBlck])
          var_down = np.zeros([BaseDur,varTmpNumBlck])
          var_down_perc = np.zeros([BaseDur,varTmpNumBlck])

          
          for index_03 in range(0,varTmpNumBlck):
               # Get every epoch
               var_up[:,index_03] = varCCond_tc_norm_mne[varStr_up[index_03]:varStp_up[index_03]]
               var_down[:,index_03] = varCCond_tc_norm_mne[varStr_down[index_03]:varStp_down[index_03]]

#               # Calculate baseline before every epoch
               tmpBse_up = np.mean(varCCond_tc_norm_mne[varStr_up[index_03]:varStr_up[index_03]+2])
               tmpBse_down = np.mean(varCCond_tc_norm_mne[varStr_down[index_03]:varStr_down[index_03]+2])
               
#               var_up_perc[:,index_03] = np.divide(var_up[:,index_03],tmpBse_up))
#               var_down_perc[:,index_03]= np.divide(var_down[:,index_03],tmpBse_down)

               
               varBOLD_perc_up[:,index_02*varTmpNumBlck:(index_02+1)*varTmpNumBlck]  =    var_up
#               varBOLD_perc_up_01[:,index_02*varTmpNumBlck:(index_02+1)*varTmpNumBlck]  =    varBse_up_perc_01
#               
               varBOLD_perc_down[:,index_02*varTmpNumBlck:(index_02+1)*varTmpNumBlck]  =    var_down
#               varBOLD_perc_down_01[:,index_02*varTmpNumBlck:(index_02+1)*varTmpNumBlck]  =    varBse_down_perc_01
               
          #------------------------------------------------------------------------------------------------

          counter +=1
          plt.figure(counter)
          plt.plot(xaxis,var_up)
          plt.hlines(0,0,5,linestyles="dashed")
          plt.xticks(ind)
          plt.xlabel('Time/volume, TR = 2.604')
          plt.ylabel('% BOLD Signal Change')
          plt.legend(['Block1','Block2','Block3','Block4','Block5','Block6','Stimulus Dur'])
          plt.show()
          plt.title( 'fun_0' + str((index_02+1)) + '_' +  \
                    stiROI[index_01] + '_up_BOLD_Signal_Change_Each_Block')
          plt.savefig( 'fun_0' + str((index_02+1)) + '_' +  \
                    stiROI[index_01]+ '_up_BOLD_Signal_Change_Each_Block.svg')
          plt.savefig( 'fun_0' + str((index_02+1)) + '_' +  \
                    stiROI[index_01] + '_up_BOLD_Signal_Change_Each_Block.png')

#          counter +=1
#          plt.figure(counter)
#          plt.plot(xaxis,varBse_up_perc_01)
#          plt.hlines(0,0,5,linestyles="dashed")
#          plt.xticks(ind)
#          plt.xlabel('Time/volume, TR = 2.604')
#          plt.ylabel('% BOLD Signal Change')
#          plt.legend(['Block1','Block2','Block3','Block4','Block5','Block6','Stimulus Dur'])
#
#          plt.title( 'fun_0' + str((index_02+1)) + '_' +  \
#                    stiROI[index_01] + '_up_BOLD_Signal_Change_Each_Block_glb')
#          plt.savefig( 'fun_0' + str((index_02+1)) + '_' +  \
#                    stiROI[index_01]+ '_up_BOLD_Signal_Change_Each_Block_glb.svg')
#          plt.savefig( 'fun_0' + str((index_02+1)) + '_' +  \
#                    stiROI[index_01] + '_up_BOLD_Signal_Change_Each_Block_glb.png')



          counter +=1
          plt.figure(counter)
          plt.plot(xaxis,np.mean(var_up,axis=1))
#          plt.bar(2,4,width=5,aligh='center',color='grey')
          plt.hlines(0,0,5,linestyles="dashed")
          plt.xticks(ind)
          yerr = stats.sem(var_up,axis=1)
          plt.errorbar(xaxis,np.mean(var_up,axis=1), yerr=yerr, label='both limits (default)')

          plt.xlabel('Time/volume, TR = 2.604')
          plt.ylabel('% BOLD Signal Change')
          plt.title( 'fun_0' + str((index_02+1)) + '_' +  \
                    stiROI[index_01] + '_up_BOLD_Signal_Change')
          plt.savefig( 'fun_0' + str((index_02+1)) + '_' +  \
                    stiROI[index_01]+ '_up_BOLD_Signal_Change.svg')
          plt.savefig( 'fun_0' + str((index_02+1)) + '_' +  \
                    stiROI[index_01] + '_up_BOLD_Signal_Change.png')
          
          
          #-----------------------------------------------------------------
          # plot luminance decrease condition

          counter +=1
          plt.figure(counter)
          plt.plot(xaxis,var_down)
          plt.hlines(0,0,5,linestyles="dashed")
          plt.xticks(ind)
          plt.legend(['Block1','Block2','Block3','Block4','Block5','Block6','Stimulus Dur'])

          plt.xlabel('Time/volume, TR = 2.604')
          plt.ylabel('% BOLD Signal Change')
          plt.title( 'fun_0' + str((index_02+1)) + '_' +  \
                    stiROI[index_01] + '_down_BOLD_Signal_Change_Each_Block')
          plt.savefig( 'fun_0' + str((index_02+1)) + '_' +  \
                    stiROI[index_01]+ '_down_BOLD_Signal_Change_Each_Block.svg')
          plt.savefig( 'fun_0' + str((index_02+1)) + '_' +  \
                    stiROI[index_01] + '_down_BOLD_Signal_Change_Each_Block.png')

#          counter +=1
#          plt.figure(counter)
#          plt.plot(xaxis,varBse_down_perc_01)
#          plt.hlines(0,0,5,linestyles="dashed")
#          plt.xticks(ind)
#          plt.legend(['Block1','Block2','Block3','Block4','Block5','Block6','Stimulus Dur'])
#          plt.xlabel('Time/volume, TR = 2.604')
#          plt.ylabel('varBOLD_perc_up% BOLD Signal Change')
#          plt.title( 'fun_0' + str((index_02+1)) + '_' +  \
#                    stiROI[index_01] + '_down_BOLD_Signal_Change_Each_Block_glb')
#          plt.savefig( 'fun_0' + str((index_02+1)) + '_' +  \
#                    stiROI[index_01]+ '_down_BOLD_Signal_Change_Each_Block_glb.svg')
#          plt.savefig( 'fun_0' + str((index_02+1)) + '_' +  \
#                    stiROI[index_01] + '_down_BOLD_Signal_Change_Each_Block_glb.png')



          counter +=1
          plt.figure(counter)
          plt.plot(xaxis,np.mean(var_down,axis=1))
          yerr = stats.sem(var_down,axis=1)
          plt.errorbar(xaxis,np.mean(var_down,axis=1), yerr=yerr, label='both limits (default)')
          
          plt.hlines(0,0,5,linestyles="dashed")
          plt.xticks(ind)
          plt.xlabel('Time/volume, TR = 2.604')
          plt.ylabel('% BOLD Signal Change')
          plt.title( 'fun_0' + str((index_02+1)) + '_' +  \
                    stiROI[index_01] + '_down_BOLD_Signal_Change')
          plt.savefig( 'fun_0' + str((index_02+1)) + '_' +  \
                    stiROI[index_01]+ '_down_BOLD_Signal_Change.svg')
          plt.savefig( 'fun_0' + str((index_02+1)) + '_' +  \
                    stiROI[index_01] + '_down_BOLD_Signal_Change.png')

          
          
          
          varBOLD_perc_up_mne[:,index_02]  =    np.mean(var_up,axis=1)
          varBOLD_perc_down_mne[:,index_02]  =    np.mean(var_down,axis=1)
#          varBOLD_perc_up_01_mne[:,index_02]  =    np.mean(varBse_up_perc_01,axis=1)
#          varBOLD_perc_down_01_mne[:,index_02]  =    np.mean(varBse_down_perc_01,axis=1)
          
     counter +=1
     plt.figure(counter)
     plt.plot(xaxis,varBOLD_perc_up_mne)
#     plt.bar(2,4,width=5,aligh='center',color='grey')
     plt.hlines(0,0,5,linestyles="dashed")
     plt.xticks(ind)
     plt.xlabel('Time/volume, TR = 2.604')
     plt.ylabel('% BOLD Signal Change')
     plt.legend(['Run1','Run2','Run3','Run4','Run5','Run6','Stimulus Block'],loc=1)
     plt.title(  stiROI[index_01] + '_up_BOLD_Signal_Change_Each_Run')
     plt.savefig(  stiROI[index_01]+ '_up_BOLD_Signal_Change_Each_Run.svg')
     plt.savefig( stiROI[index_01] + '_up_BOLD_Signal_Change_Each_Run.png')


     counter +=1
     plt.figure(counter)
     plt.plot(xaxis,varBOLD_perc_down_mne)
#     plt.bar(2,4,width=5,aligh='center',color='grey')
     plt.hlines(0,0,5,linestyles="dashed")
     plt.xticks(ind)
     plt.xlabel('Time/volume, TR = 2.604')
     plt.ylabel('% BOLD Signal Change')
     plt.legend(['Run1','Run2','Run3','Run4','Run5','Run6','Stimulus Block'],loc=1)
     plt.title(  stiROI[index_01] + '_down_BOLD_Signal_Change_Each_Run')
     plt.savefig(  stiROI[index_01]+ '_down_BOLD_Signal_Change_Each_Run.svg')
     plt.savefig( stiROI[index_01] + '_down_BOLD_Signal_Change_Each_Run.png')
     

#     counter +=1
#     plt.figure(counter)
#     plt.plot(xaxis,varBOLD_perc_up_01_mne)
#     plt.bar(2,4,width=5,aligh='center',color='grey')
##          plt.hlines(0,0,5,linestyles="dashed")
#     plt.xticks(ind)
#     plt.xlabel('Time/volume, TR = 2.604')
#     plt.ylabel('% BOLD Signal Change')
#     plt.legend(['Run1','Run2','Run3','Run4','Run5','Run6','Stimulus Block'],loc=1)
#     plt.title(  stiROI[index_01] + '_up_BOLD_Signal_Change_Each_Run_GLB')
#     plt.savefig(  stiROI[index_01]+ '_up_BOLD_Signal_Change_Each_Run_GLB.svg')
#     plt.savefig( stiROI[index_01] + '_up_BOLD_Signal_Change_Each_Run_GLB.png')
#
#
#     counter +=1
#     plt.figure(counter)
#     plt.plot(xaxis,varBOLD_perc_down_01_mne)
#     plt.hlines(0,0,5,linestyles="dashed")
#     plt.xticks(ind)
#     plt.xlabel('Time/volume, TR = 2.604')
#     plt.ylabel('% BOLD Signal Change')
#     plt.legend(['Run1','Run2','Run3','Run4','Run5','Run6','Stimulus Block'],loc=1)
#     plt.title(  stiROI[index_01] + '_down_BOLD_Signal_Change_Each_Run')
#     plt.savefig(  stiROI[index_01]+ '_down_BOLD_Signal_Change_Each_Run_GLB.svg')
#     plt.savefig( stiROI[index_01] + '_down_BOLD_Signal_Change_Each_Run_GLB.png')


         
     counter +=1
     plt.figure(counter)
     plt.plot(xaxis,np.mean(varBOLD_perc_up,axis=1))
#     plt.bar(2,4,width=5,aligh='center',color='grey')
     plt.hlines(0,0,5,linestyles="dashed")
     plt.xticks(ind)
     yerr = stats.sem(varBOLD_perc_up,axis=1)
     plt.errorbar(xaxis,np.mean(varBOLD_perc_up,axis=1), yerr=yerr, label='both limits (default)')

     plt.xlabel('Time/volume, TR = 2.604')
     plt.ylabel('% BOLD Signal Change')
     plt.legend(['Average of all runs','Stimulus Block'],loc=1)

     plt.title(  stiROI[index_01] + '_up_BOLD_Signal_Change')
     plt.savefig(  stiROI[index_01]+ '_up_BOLD_Signal_Change.svg')
     plt.savefig( stiROI[index_01] + '_up_BOLD_Signal_Change.png')
#
#     counter +=1
#     plt.figure(counter)
#     plt.plot(xaxis,np.mean(varBOLD_perc_up_01,axis=1))
#     plt.hlines(0,0,5,linestyles="dashed")
#     yerr = stats.sem(varBOLD_perc_up_01,axis=1)
#     plt.errorbar(xaxis,np.mean(varBOLD_perc_up_01,axis=1), yerr=yerr, label='both limits (default)')
#     plt.legend(['Average of all runs','Stimulus Block'],loc=1)
#     plt.xticks(ind)
#     plt.xlabel('Time/volume, TR = 2.604')
#     plt.ylabel('% BOLD Signal Change')
#     plt.title(  stiROI[index_01] + '_up_BOLD_Signal_Change_glb')
#     plt.savefig(  stiROI[index_01]+ '_up_BOLD_Signal_Change_glb.svg')
#     plt.savefig( stiROI[index_01] + '_up_BOLD_Signal_Change_glb.png')
#     
     
     counter +=1
     plt.figure(counter)
     plt.plot(xaxis,np.mean(varBOLD_perc_down,axis=1))
#     plt.bar(2,4,width=5,aligh='center',color='grey')
     plt.hlines(0,0,5,linestyles="dashed")
     plt.xticks(ind)
     plt.xlabel('Time/volume, TR = 2.604')
     plt.ylabel('% BOLD Signal Change')
     plt.legend(['Average of all runs','Stimulus Block'],loc=1)
     yerr = stats.sem(varBOLD_perc_down,axis=1)
     plt.errorbar(xaxis,np.mean(varBOLD_perc_down,axis=1), yerr=yerr, label='both limits (default)')

     plt.title(  stiROI[index_01] + '_down_BOLD_Signal_Change')
     plt.savefig(  stiROI[index_01]+ '_down_BOLD_Signal_Change.svg')
     plt.savefig( stiROI[index_01] + '_down_BOLD_Signal_Change.png')

#     counter +=1
#     plt.figure(counter)
#     plt.plot(xaxis,np.mean(varBOLD_perc_down_01,axis=1))
#     
#     yerr = stats.sem(varBOLD_perc_down_01,axis=1)
##     plt.bar(2,4,width=5,aligh='center',color='grey')
#     plt.hlines(0,0,5,linestyles="dashed")
#     plt.legend(['Average of all runs','Stimulus Block'],loc=1)
#     plt.xticks(ind)
#     plt.xlabel('Time/volume, TR = 2.604')
#     plt.ylabel('% BOLD Signal Change')
#     plt.title(  stiROI[index_01] + '_down_BOLD_Signal_Change_glb')
#     plt.savefig(  stiROI[index_01]+ '_down_BOLD_Signal_Change_glb.svg')
#     plt.savefig( stiROI[index_01] + '_down_BOLD_Signal_Change_glb.png')
#     plt.errorbar(xaxis,np.mean(varBOLD_perc_down_01,axis=1), yerr=yerr, label='both limits (default)')
     
     aryBold.append(varBOLD_perc_up)
#     aryBold.append(varBOLD_perc_up_01)
     aryBold.append(varBOLD_perc_up_mne)
#     aryBold.append(varBOLD_perc_up_01_mne)
     aryBold.append(varBOLD_perc_down)
#     aryBold.append(varBOLD_perc_down_01)
     aryBold.append(varBOLD_perc_down_mne)
#     aryBold.append(varBOLD_perc_down_01_mne)
     



plt.close('all')
counter +=1
plt.figure(counter)
#plt.bar(2,4,width=5,aligh='center',color='grey')
plt.hlines(0,0,5,linestyles="dashed")
yerr1 = stats.sem(aryBold[4],axis=1)
yerr2 = stats.sem(aryBold[6],axis=1)
plt.errorbar(xaxis,np.mean(aryBold[4],axis=1), yerr=yerr1, label='both limits (default)')
plt.errorbar(xaxis,np.mean(aryBold[6],axis=1), yerr=yerr2, label='both limits (default)')
plt.legend(['Stimulus Event','Lum_Incre','Lum_Decre'],loc=1)
plt.xticks(ind)
plt.xlabel('Time/volume, TR = 2.604')
plt.ylabel('% BOLD Signal Change')
plt.title('Stimulus_Center[16 voxels]_BOLD_Signal_Change')
plt.savefig('Stimulus_Center[16 voxels]_BOLD_Signal_Change.svg')
plt.savefig('Stimulus_Center[16 voxels]_BOLD_Signal_Change.png')



counter +=1
plt.figure(counter)
#plt.bar(2,4,width=5,aligh='center',color='grey')
plt.hlines(0,0,5,linestyles="dashed")

yerr1 = stats.sem(aryBold[0],axis=1)
yerr2 = stats.sem(aryBold[2],axis=1)
plt.errorbar(xaxis,np.mean(aryBold[0],axis=1), yerr=yerr1, label='both limits (default)')
plt.errorbar(xaxis,np.mean(aryBold[2],axis=1), yerr=yerr2, label='both limits (default)')

plt.legend(['Stimulus Event','Lum_Incre','Lum_Decre'],loc=1)
plt.xticks(ind)
plt.xlabel('Time/volume, TR = 2.604')
plt.ylabel('% BOLD Signal Change')
plt.title('Stimulus_Background[124 voxles]_BOLD_Signal_Change')
plt.savefig('Stimulus_Background[124 voxels]_BOLD_Signal_Change.svg')
plt.savefig('Stimulus_Background[124 voxels]_BOLD_Signal_Change.png')


# =============================================================================
# Temporal interpolation
#lstTxt_ti = []
#for txtid in range(0, len(AllTxtFiles)):
## for txtid in range(0,len(TmpTextFiles)):
#    arytmp = np.zeros([len(TR_TI_tc),1])
#    plt.figure(txtid)
#    # The reason why I chose the current parameters is that it didn't give
#    # extreme values at the boundary.
#    # tx = UnivariateSpline(TR_tc,lstTxt[0][:,i])
#    # tx =  CubicSpline(TR_tc,lstTxt[0][:,i])
#    # tx = InterpolatedUnivariateSpline(TR_tc,lstTxt[0][:,i])
#    # plt.plot(TR_TI_tc,tx(TR_TI_tc))
#    # plt.plot(TR_tc,lstTxt[txtid][:,i],'ro')
#
#    tx = interp1d(TR_tc,lstTxt_normne[txtid],
#                  kind="cubic",
#                  axis=-1,
#                  copy=True,
#                  bounds_error=False,
#                  fill_value="extrapolate",
#                  assume_sorted=False)
#
#    arytmp[:,0] = tx(TR_TI_tc)
#    # Save the array
#    plt.plot(TR_TI_tc[0:-2],tx(TR_TI_tc)[0:-2])
#    plt.plot(TR_tc,lstTxt_normne[txtid],'ro')
#    plt.title(" ".join(AllTxtFiles[txtid].split('_')[0:-2]))
#    plt.savefig("_".join(AllTxtFiles[txtid].split('_')[0:-2]) + '.svg')
#    plt.savefig("_".join(AllTxtFiles[txtid].split('_')[0:-2]) + '.png')
#    lstTxt_ti.append(arytmp)
#
#plt.close('all')
#
# ----------------------------------------------------------------------------
  
# =============================================================================
# This section is to plot background roi for all the conditions
#counter = -1
#for runid in range(0,len(AllTxtFiles),2):
##     print (runid)
#    counter +=1
#    plt.figure(counter,figsize=(10, 10))         
#    curr_roi =  lstTxt_ti[runid]
#    
#    varStr = lstEV_up[counter][:,0].astype(int)
##    varStr =(arytmpCond[:,0]*4).astype(int)
#    varStp = (varStr + varDur).astype(int)
#    
#    varStr_down = lstEV_down[counter][:,0].astype(int)

##    varStr_dwon = (arytmpCond_down[:,0] * 4).astype(int)
#    varStp_down = (varStr_down + varDur).astype(int)
#    
#    
#    varStr_GW = lstEV_gw[counter][:,0].astype(int)
#    varStp_GW = (varStr_GW + 1).astype(int)
#
#
#    varStr_WG = lstEV_wg[counter][:,0].astype(int)
#    varStp_WG = (varStr_WG + 1).astype(int)
#    
#    varStr_BG = lstEV_bg[counter][:,0].astype(int)
#    varStp_BG = (varStr_BG + 1).astype(int)
#    
#    varStr_GB = lstEV_gb[counter][:,0].astype(int)
#    varStp_GB = (varStr_GB + 1).astype(int)
#   
#    
#    xaxis_str_up = TR_TI_tc[varStr]
#    xaxis_stp_up = TR_TI_tc[varStp]
#    
#    xaxis_str_down = TR_TI_tc[varStr_down]
#    xaxis_stp_down = TR_TI_tc[varStp_down]
#    
#    plt.plot(TR_TI_tc,curr_roi,c='y')
#
#
##    plt.plot(TR_tc,lstTxt_normne[txtid],c='y')
#    plt.ylim([-1.8,2.2])
#    
#    plt.scatter(TR_TI_tc[varStr_GW] ,curr_roi[varStr_GW,0],c='g',marker='*')
#    plt.scatter(TR_TI_tc[varStp_GW] ,curr_roi[varStp_GW,0],c='c',marker='*')
#
#    plt.scatter(xaxis_str_up ,curr_roi[varStr,0],c='g',marker='<')
#    plt.scatter(xaxis_stp_up ,curr_roi[varStp,0],c='c',marker='>')
#    
#    plt.scatter(TR_TI_tc[varStr_WG] ,curr_roi[varStr_WG,0],c='g',marker='*')
#    plt.scatter(TR_TI_tc[varStp_WG] ,curr_roi[varStp_WG,0],c='c',marker='*')
#
#    plt.scatter(TR_TI_tc[varStr_GB] ,curr_roi[varStr_GB,0],c='red',marker='*')
#    plt.scatter(TR_TI_tc[varStp_GB] ,curr_roi[varStp_GB,0],c='k',marker='*')
#
#
#    plt.scatter(xaxis_str_down ,curr_roi[varStr_down,0],c='red',marker='<')
#    plt.scatter(xaxis_stp_down ,curr_roi[varStp_down,0],c='k',marker='>')
#    
#    plt.scatter(TR_TI_tc[varStr_BG] ,curr_roi[varStr_BG,0],c='red',marker='*')
#    plt.scatter(TR_TI_tc[varStp_BG] ,curr_roi[varStp_BG,0],c='k',marker='*')
#    plt.legend(['Data','Str_G2W','Stp_G2W','Str_up','Stp_up','Str_W2G','Stp_W2G','Str_G2B','Stp_G2B','Str_down','Stp_down','Str_B2G','Stp_B2G'],loc=1)
#    
#    plt.title('Fun_0' + str(counter+1) + '_stimulus_events_In_bkgrd' )
#    plt.savefig('Fun_0' + str(counter+1) + '_stimulus_events_In_bkgrd' + '.png')
#
#
#lst_bkgrd_mne = np.mean(lst_bkgrd,axis=1)
#
#plt.close('all')
## =============================================================================
#
## =============================================================================
#
#counter = -1
#for runid in range(1,len(AllTxtFiles),2):
##     print (runid)
#    counter +=1
#    plt.figure(counter,figsize=(10, 10))         
#    curr_roi =  lstTxt_ti[runid]
#    
#    varStr = lstEV_up[counter][:,0].astype(int)
##    varStr =(arytmpCond[:,0]*4).astype(int)
#    varStp = (varStr + varDur).astype(int)
#    
#    varStr_down = lstEV_down[counter][:,0].astype(int)
#
##    varStr_dwon = (arytmpCond_down[:,0] * 4).astype(int)
#    varStp_down = (varStr_down + varDur).astype(int)
#    
#    
#    varStr_GW = lstEV_gw[counter][:,0].astype(int)
#    varStp_GW = (varStr_GW + 1).astype(int)
#
#
#    varStr_WG = lstEV_wg[counter][:,0].astype(int)
#    varStp_WG = (varStr_WG + 1).astype(int)
#    
#    varStr_BG = lstEV_bg[counter][:,0].astype(int)
#    varStp_BG = (varStr_BG + 1).astype(int)
#    
#    varStr_GB = lstEV_gb[counter][:,0].astype(int)
#    varStp_GB = (varStr_GB + 1).astype(int)
#   
#    
#    xaxis_str_up = TR_TI_tc[varStr]
#    xaxis_stp_up = TR_TI_tc[varStp]
#    
#    xaxis_str_down = TR_TI_tc[varStr_down]
#    xaxis_stp_down = TR_TI_tc[varStp_down]
#
#    plt.plot(TR_TI_tc,curr_roi,c='y')
#
#
##    plt.plot(TR_tc,lstTxt_normne[txtid],c='y')
#    plt.ylim([-1.8,2.2])
#    
#    plt.scatter(TR_TI_tc[varStr_GW] ,curr_roi[varStr_GW,0],c='g',marker='*')
#    plt.scatter(TR_TI_tc[varStp_GW] ,curr_roi[varStp_GW,0],c='c',marker='*')
#
#    plt.scatter(xaxis_str_up ,curr_roi[varStr,0],c='g',marker='<')
#    plt.scatter(xaxis_stp_up ,arytmp[varStp,0],c='c',marker='>')
#    
#    plt.scatter(TR_TI_tc[varStr_WG] ,curr_roi[varStr_WG,0],c='g',marker='*')
#    plt.scatter(TR_TI_tc[varStp_WG] ,curr_roi[varStp_WG,0],c='c',marker='*')
#
#    plt.scatter(TR_TI_tc[varStr_GB] ,curr_roi[varStr_GB,0],c='red',marker='*')
#    plt.scatter(TR_TI_tc[varStp_GB] ,curr_roi[varStp_GB,0],c='k',marker='*')
#
#
#    plt.scatter(xaxis_str_down ,curr_roi[varStr_down,0],c='red',marker='<')
#    plt.scatter(xaxis_stp_down ,curr_roi[varStp_down,0],c='k',marker='>')
#    
#    plt.scatter(TR_TI_tc[varStr_BG] ,curr_roi[varStr_BG,0],c='red',marker='*')
#    plt.scatter(TR_TI_tc[varStp_BG] ,curr_roi[varStp_BG,0],c='k',marker='*')
#    plt.legend(['Data','Str_G2W','Stp_G2W','Str_up','Stp_up','Str_W2G','Stp_W2G','Str_G2B','Stp_G2B','Str_down','Stp_down','Str_B2G','Stp_B2G'],loc=1)
#    
#    plt.title('Fun_0' + str(counter+1) + '_stimulus_events_In_center' )
#    plt.savefig('Fun_0' + str(counter+1) + '_stimulus_events_In_center' + '.png')
#
#
#plt.close('all')
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
