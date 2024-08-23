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
import matplotlib.transforms as mtransforms
sns.set_style("white")

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
data_path = '/media/g/P04/Data/BIDS/sub-12/ses-002/func/'
sub_path = '/media/g/P04/Data/BIDS/sub-12/ses-002/'

# Change to the directory and Get all the text filenames
meantsPth='/media/g/P04/Data/BIDS/sub-12/ses-002/func/GLM/BI/fslmeants_lroi_nf/rh/'
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
lstIn_02 = ['BI_fun_01_MoCo_Dist_Corr_Coreg_3EV.feat',
            'BI_fun_02_MoCo_Dist_Corr_Coreg_3EV.feat',
            'BI_fun_03_MoCo_Dist_Corr_Coreg_3EV.feat',
            'BI_fun_04_MoCo_Dist_Corr_Coreg_3EV.feat',
            'BI_fun_05_MoCo_Dist_Corr_Coreg_3EV.feat',
            'BI_fun_06_MoCo_Dist_Corr_Coreg_3EV.feat']



strPathOut = '/media/g/P04/Data/BIDS/sub-12/ses-002/func/GLM/BI/ERA_lroi_nf_rh'

if not os.path.exists(strPathOut):
    os.makedirs(strPathOut)
os.chdir(strPathOut)

# Normalise time segments? If True, segments are normalised trial-by-trial;
# i.e. each time-course segment is divided by its own pre-stimulus baseline
# before averaging across trials.
#lgcNorm = False # True
lgcNorm = True

# Whether or not to also produces individual event-related segments for each
# trial:
# lgcSegs = True # False
# if lgcSegs:
#     # Basename for segments:
#     strSegs = 'NA'

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
     currplt = np.zeros([varNumVol,9])
     currplt[:,:]= lstDM[runid]
     counter+=1
     plt.figure(counter,figsize=(14,8))
     plt.plot(currplt)
     plt.legend(['Lum_incre','Lum_decre','Tar','TX','TY','TZ','RX','RY','RZ'],loc=1)
     plt.title('fun_' + str(runid+1) + '_3EV_MOT')
     plt.savefig('fun_' + str(runid+1) + '_3EV_MOT'+'.svg')
     plt.savefig('fun_' + str(runid+1) + '_3EV_MOT'+'.png')
     counter+=1
     plt.figure(counter,figsize=(14,8))
     plt.plot(currplt[:,0:2])
     plt.legend(['Lum_incre','Lum_decre','Tar'],loc=1)
     plt.title('fun_' + str(runid+1) + '_3EV')
     plt.savefig('fun_' + str(runid+1) + '_3EV'+'.svg')
     plt.savefig('fun_' + str(runid+1) + '_3EV'+'.png')


plt.close('all')

# =============================================================================
# This section is for plot event-related average
lstIn_04 = ['20201104_BI_7T_fMRI_Run_01_Lum_Up.txt',
            '20201104_BI_7T_fMRI_Run_02_Lum_Up.txt',
            '20201104_BI_7T_fMRI_Run_03_Lum_Up.txt',
            '20201104_BI_7T_fMRI_Run_04_Lum_Up.txt',
            '20201104_BI_7T_fMRI_Run_05_Lum_Up.txt',
            '20201104_BI_7T_fMRI_Run_06_Lum_Up.txt']

lstIn_06 = ['20201104_BI_7T_fMRI_Run_01_Lum_Down.txt',
            '20201104_BI_7T_fMRI_Run_02_Lum_Down.txt',
            '20201104_BI_7T_fMRI_Run_03_Lum_Down.txt',
            '20201104_BI_7T_fMRI_Run_04_Lum_Down.txt',
            '20201104_BI_7T_fMRI_Run_05_Lum_Down.txt',
            '20201104_BI_7T_fMRI_Run_06_Lum_Down.txt']

# Number of input design matrices:
varNumIn_04 = len(lstIn_04)


# Number of input design matrices:
varNumIn_06 = len(lstIn_06)

lstEV_lum_up = [None] * varNumIn_04
lstEV_lum_down = [None] * varNumIn_06
dmPth='/media/g/P04/Data/BIDS/sub-12/ses-002/func/DM_3Predts/'
# Load design matrices (EV files):
for index_01 in range(0, varNumIn_04):


    print('---Loading: ' + lstIn_04[index_01])

    # Read text file:
    aryTmp = np.loadtxt(
                        (dmPth +  lstIn_04[index_01]),
                        skiprows=0
                        )
    # Append current csv object to list:
    lstEV_lum_up[index_01] = np.copy(aryTmp)

# Load design matrices (EV files):
for index_01 in range(0, varNumIn_06):


    print('---Loading: ' + lstIn_06[index_01])
    # Read text file:
    aryTmp = np.loadtxt(
                        (dmPth  + lstIn_06[index_01]),
                        skiprows=0
                        )
    # Append current csv objectBaseDur to list:
    lstEV_lum_down[index_01] = np.copy(aryTmp)


stiROI = ['background','center','edge']
ocROI  = ['V1','V2','V3']
counter = 0
ind = np.arange(-2,18,2)
aryBold =  []
xaxis = np.arange(-2,17)

for index_00 in range(0, len(ocROI)):


    for index_01 in range(0, len(stiROI)):

         if not (index_00==2 & index_01==2):


              varBOLD_perc_up = []
              varBOLD_perc_up_mne = np.zeros([BaseDur,6])

              varBOLD_perc_down = []
              varBOLD_perc_down_mne = np.zeros([BaseDur,6])

              # For each run

              for index_02 in range(0, varNumIn_02):


                   varCCond = 'rh_fun_0' + str((index_02+1)) + '_' +  \
                             ocROI[index_00] + '_'+ stiROI[index_01]  + \
                             '_meants_tc.txt'


                   # find the index in the orginal text file lists
                   varCindex = AllTxtFiles.index(varCCond)
                   varCCond_tc = lstTxt[varCindex]
                   numVoxels = varCCond_tc.shape[1]


                   currDM_up = lstEV_lum_up
                   currDM_down = lstEV_lum_down

                   varCEV_up = currDM_up[index_02]
                   varCEV_down = currDM_down[index_02]

                   varTmpNumBlck = len(varCEV_up[:,0])

                   varStr_up = np.around(np.add(np.divide(varCEV_up[:,0],varTR),tplBase[0])).astype(int)
                   varStp_up = np.ceil(varStr_up + np.absolute(tplBase[0]) + varDur + varVolsPst).astype(int)

                   varStr_down = np.around(np.add(np.divide(varCEV_down[:,0],varTR),tplBase[0])).astype(int)
                   varStp_down = np.ceil(varStr_down + np.absolute(tplBase[0]) + varDur + varVolsPst).astype(int)


                   # Generate epock
                   varrhe_up = np.zeros([varTmpNumBlck,numVoxels])

                   varrhe_down = np.zeros([varTmpNumBlck,numVoxels])
                   #-------------------------------------------------------------------
                   # Normalize the whole time course for each voxel in each ROI
                   var_up = np.zeros([BaseDur,numVoxels*varTmpNumBlck])
                   var_up_perc = np.zeros([BaseDur,numVoxels*varTmpNumBlck])
                   var_down = np.zeros([BaseDur,numVoxels*varTmpNumBlck])
                   var_down_perc = np.zeros([BaseDur,numVoxels*varTmpNumBlck])
                   #--------------------------------------------------------------------
                   # Get event related average


                   for index_03 in range(0,varTmpNumBlck):
                        # Get every epoch
                        var_up[:,index_03*numVoxels:(index_03+1)*numVoxels] = varCCond_tc[varStr_up[index_03]:varStp_up[index_03],:]
                        var_down[:,index_03*numVoxels:(index_03+1)*numVoxels] = varCCond_tc[varStr_down[index_03]:varStp_down[index_03],:]


         #               # Calculate baseline before every epoch
                        varrhe_up[index_03,:] = np.mean(varCCond_tc[varStr_up[index_03]:varStr_up[index_03]+3,:],axis=0)
                        varrhe_down[index_03,:] = np.mean(varCCond_tc[varStr_down[index_03]:varStr_down[index_03]+3 ,:],axis=0)

                        var_up_perc[:,index_03*numVoxels:(index_03+1)*numVoxels]  = (np.divide(var_up[:,index_03*numVoxels:(index_03+1)*numVoxels],varrhe_up[index_03,:] ) -1 ) *100
                        var_down_perc[:,index_03*numVoxels:(index_03+1)*numVoxels]  = (np.divide(var_down[:,index_03*numVoxels:(index_03+1)*numVoxels],varrhe_down[index_03,:]) -1 ) *100



                   numNans_up =  np.unique(np.argwhere(np.isnan(var_up_perc))[:,1])
                   if len(numNans_up) != 0:
                        var_up_perc = np.delete(var_up_perc,numNans_up,1)
                   var_up_perc_norm_mne = np.mean(var_up_perc,axis=1)

                   numNans_down =  np.unique(np.argwhere(np.isnan(var_down_perc))[:,1])
                   if len(numNans_down) != 0:
                        var_down_perc = np.delete(var_down_perc,numNans_down,1)
                   var_down_perc_norm_mne = np.mean(var_down_perc,axis=1)





                   varBOLD_perc_up.append(var_up_perc)
                   varBOLD_perc_down.append(var_down_perc)

                   #------------------------------------------------------------------------------------------------

                   counter +=1
                   fig, ax = plt.subplots()
                   ax.plot(xaxis,np.mean(var_up_perc,axis=1))
                   trans = mtransforms.blended_transform_factory(ax.transData, ax.transAxes)
                   plt.fill_between([0,5],-2,2,facecolor='grey', alpha=0.5, transform=trans)
                   plt.hlines(0,0,5,linestyles="dashed")
                   plt.xticks(ind)
                   yerr = stats.sem(var_up_perc,axis=1)
                   plt.errorbar(xaxis,np.mean(var_up_perc,axis=1), yerr=yerr, label='both limits (default)')

                   plt.xlabel('Time/volume, TR = 2.604')
                   plt.ylabel('% BOLD Signal Change')
                   plt.title( 'rh_sub-12_lroi_nf_fun_0' + str((index_02+1)) + '_' +  \
                             ocROI[index_00] +'_'+  stiROI[index_01] + \
                              '_up_BOLD_Signal_Change')
                   plt.savefig( 'rh_sub-12_lroi_nf_fun_0' + str((index_02+1)) + '_' +  \
                             ocROI[index_00] + '_'+ stiROI[index_01] + \
                             '_up_BOLD_Signal_Change.svg')
                   plt.savefig( 'rh_sub-12_lroi_nf_fun_0' + str((index_02+1)) + '_' +  \
                             ocROI[index_00] + '_'+ stiROI[index_01]  + \
                             '_up_BOLD_Signal_Change.png')


                   #-----------------------------------------------------------------
                   # plot luminance decrease condition
                   counter +=1
                   fig, ax = plt.subplots()
                   ax.plot(xaxis,np.mean(var_up_perc,axis=1))
                   trans = mtransforms.blended_transform_factory(ax.transData, ax.transAxes)
                   yerr = stats.sem(var_down_perc,axis=1)
                   plt.errorbar(xaxis,np.mean(var_down_perc,axis=1), yerr=yerr, label='both limits (default)')
                   plt.fill_between([0,5],-2,2,facecolor='grey', alpha=0.5, transform=trans)

                   plt.hlines(0,0,5,linestyles="dashed")
                   plt.xticks(ind)
                   plt.xlabel('Time/volume, TR = 2.604')
                   plt.ylabel('% BOLD Signal Change')
                   plt.title( 'rh_sub-12_lroi_nf_fun_0' + str((index_02+1)) + '_' +  \
                             ocROI[index_00] +'_'+  stiROI[index_01]  + \
                             '_down_BOLD_Signal_Change')
                   plt.savefig( 'rh_sub-12_lroi_nf_fun_0' + str((index_02+1)) + '_' +  \
                             ocROI[index_00] +'_'+  stiROI[index_01] + \
                             '_down_BOLD_Signal_Change.svg')
                   plt.savefig( 'rh_sub-12_lroi_nf_fun_0' + str((index_02+1)) + '_' +  \
                             ocROI[index_00] + '_'+ stiROI[index_01]  + \
                             '_down_BOLD_Signal_Change.png')




                   varBOLD_perc_up_mne[:,index_02]  =    var_up_perc_norm_mne
                   varBOLD_perc_down_mne[:,index_02]  =   var_down_perc_norm_mne

                   plt.close('all')


         counter +=1
         fig, ax = plt.subplots()
         ax.plot(xaxis,varBOLD_perc_up_mne)
         trans = mtransforms.blended_transform_factory(ax.transData, ax.transAxes)

         plt.fill_between([0,5],-2,2,facecolor='grey', alpha=0.5, transform=trans)

         plt.hlines(0,0,5,linestyles="dashed")
         plt.xticks(ind)
         plt.xlabel('Time/volume, TR = 2.604')
         plt.ylabel('% BOLD Signal Change')
         plt.legend(['Run1','Run2','Run3','Run4','Run5','Run6','Stimulus Block'],loc=1)
         plt.title( 'rh_sub-12_lroi_nf_' + ocROI[index_00] + '_'+ stiROI[index_01]  + '_up_BOLD_Signal_Change_Each_Run')
         plt.savefig( 'rh_sub-12_lroi_nf_' +ocROI[index_00] +'_'+  stiROI[index_01] + '_up_BOLD_Signal_Change_Each_Run.svg')
         plt.savefig( 'rh_sub-12_lroi_nf_' +ocROI[index_00] + '_'+ stiROI[index_01]  + '_up_BOLD_Signal_Change_Each_Run.png')


         counter +=1
         fig, ax = plt.subplots()
         ax.plot(xaxis,varBOLD_perc_down_mne)
         trans = mtransforms.blended_transform_factory(ax.transData, ax.transAxes)

         plt.fill_between([0,5],-2,2,facecolor='grey', alpha=0.5, transform=trans)

         plt.hlines(0,0,5,linestyles="dashed")
         plt.xticks(ind)
         plt.xlabel('Time/volume, TR = 2.604')
         plt.ylabel('% BOLD Signal Change')
         plt.legend(['Run1','Run2','Run3','Run4','Run5','Run6','Stimulus Block'],loc=1)
         plt.title( 'rh_sub-12_lroi_nf_' + ocROI[index_00] + '_'+ stiROI[index_01]  + '_down_BOLD_Signal_Change_Each_Run')
         plt.savefig( 'rh_sub-12_lroi_nf_' + ocROI[index_00] + '_'+ stiROI[index_01] + '_down_BOLD_Signal_Change_Each_Run.svg')
         plt.savefig( 'rh_sub-12_lroi_nf_' +ocROI[index_00] + '_'+ stiROI[index_01]  + '_down_BOLD_Signal_Change_Each_Run.png')




         counter +=1
         fig, ax = plt.subplots()
         ax.plot(xaxis,np.mean(varBOLD_perc_up_mne,axis=1))
         trans = mtransforms.blended_transform_factory(ax.transData, ax.transAxes)

         plt.fill_between([0,5],-2,2,facecolor='grey', alpha=0.5, transform=trans)

         plt.hlines(0,0,5,linestyles="dashed")
         plt.xticks(ind)
         yerr = stats.sem(varBOLD_perc_up_mne,axis=1)
         plt.errorbar(xaxis,np.mean(varBOLD_perc_up_mne,axis=1), yerr=yerr, label='both limits (default)')

         plt.xlabel('Time/volume, TR = 2.604')
         plt.ylabel('% BOLD Signal Change')
         plt.legend(['Average of all runs','Stimulus Block'],loc=1)

         plt.title( 'rh_sub-12_lroi_nf_' + ocROI[index_00] + '_'+ stiROI[index_01]  + '_up_BOLD_Signal_Change')
         plt.savefig( 'rh_sub-12_lroi_nf_' + ocROI[index_00] + '_'+ stiROI[index_01] + '_up_BOLD_Signal_Change.svg')
         plt.savefig('rh_sub-12_lroi_nf_' + ocROI[index_00] + '_'+ stiROI[index_01]  + '_up_BOLD_Signal_Change.png')

         counter +=1
         fig, ax = plt.subplots()
         ax.plot(xaxis,np.mean(varBOLD_perc_down_mne,axis=1))
         trans = mtransforms.blended_transform_factory(ax.transData, ax.transAxes)
         plt.fill_between([0,5],-2,2,facecolor='grey', alpha=0.5, transform=trans)
         plt.hlines(0,0,5,linestyles="dashed")
         plt.xticks(ind)
         plt.xlabel('Time/volume, TR = 2.604')
         plt.ylabel('% BOLD Signal Change')
         plt.legend(['Average of all runs','Stimulus Block'],loc=1)
         yerr = stats.sem(varBOLD_perc_down_mne,axis=1)
         plt.errorbar(xaxis,np.mean(varBOLD_perc_down_mne,axis=1), yerr=yerr, label='both limits (default)')

         plt.title('rh_sub-12_lroi_nf_' +  ocROI[index_00] + '_'+ stiROI[index_01]  + '_down_BOLD_Signal_Change')
         plt.savefig('rh_sub-12_lroi_nf_' + ocROI[index_00] +'_'+  stiROI[index_01] + '_down_BOLD_Signal_Change.svg')
         plt.savefig('rh_sub-12_lroi_nf_' + ocROI[index_00] +'_'+  stiROI[index_01]  + '_down_BOLD_Signal_Change.png')

         plt.close('all')



         aryBold.append(varBOLD_perc_up)
         aryBold.append(varBOLD_perc_up_mne)
         aryBold.append(varBOLD_perc_down)
         aryBold.append(varBOLD_perc_down_mne)




plt.close('all')

iterations=0


for index_00 in range(0, len(ocROI)):


    for index_01 in range(0, len(stiROI)):



          if not (index_00==2 & index_01==2):

              iterations += 1

              varCCond = 'rh_fun_01' + '_' +  \
              ocROI[index_00] + '_'+ stiROI[index_01]  + \
              '_meants_tc.txt'

              # find the index in the orginal text file lists
              varCindex = AllTxtFiles.index(varCCond)
              varCCond_tc = lstTxt[varCindex]
              numVoxels = varCCond_tc.shape[1]
              counter +=1
              plt.figure(counter)
              plt.hlines(0,0,5,linestyles="dashed",colors='k')
              yerr2 = stats.sem(aryBold[(iterations-1)*4 + 3],axis=1)

              yerr1 = stats.sem(aryBold[(iterations-1)*4 + 1],axis=1)
              plt.errorbar(xaxis,np.mean(aryBold[(iterations-1)*4 + 3],axis=1), yerr=yerr2, label='both limits (default)')

              plt.errorbar(xaxis,np.mean(aryBold[(iterations-1)*4 + 1],axis=1), yerr=yerr1, label='both limits (default)')
              plt.legend(['Stimulus Event','Lum_Decre','Lum_Incre'],loc=1)
              plt.ylim([-2,4.8])
              plt.xticks(ind)
              # if index_01 < 2:
              #       plt.ylim([-2.5,2.5])
              # else:
              #       plt.ylim([-2,4.8])
              plt.xlabel('Time/volume, TR = 2.604s')
              plt.ylabel('% BOLD Signal Change')
              plt.title('rh_sub-12_lori_nf_' +ocROI[index_00] +'_'+  stiROI[index_01] + \
                          '['+str(numVoxels) +' voxels]')
              plt.savefig(sub_path+'Intermediate_steps/'+ 'rh_sub-12_lroi_nf_' + ocROI[index_00] +'_'+  stiROI[index_01] + \
                          '['+str(numVoxels) +' voxels]_BOLD_Signal_Change.svg')
              plt.savefig(sub_path+'Intermediate_steps/'+ 'rh_sub-12_lroi_nf_' + ocROI[index_00] +'_'+  stiROI[index_01] + \
                          '['+str(numVoxels) +' voxels]_BOLD_Signal_Change.png')
              plt.savefig(sub_path+'Intermediate_steps/'+ 'rh_sub-12_lroi_nf_' + ocROI[index_00] +'_'+  stiROI[index_01] + \
                          '['+str(numVoxels) +' voxels]_BOLD_Signal_Change.pdf')

      #
plt.close('all')

iterations=0
fig, axs = plt.subplots(3, 3, sharex=False,sharey=True)
fig.set_figheight(16)
fig.set_figwidth(24)
#plt.xticks(ind)
for ax in axs[2,0:2].flat:
    ax.set(xlabel='Time/volume, TR = 2.604s', ylabel='% BOLD Signal Change')
for ax in axs[:,0].flat:
    ax.set(ylabel='% BOLD Signal Change')

for index_00 in range(0, len(ocROI)):


    for index_01 in range(0, len(stiROI)):



          if not (index_00==2 & index_01==2):
              iterations += 1
              trans = mtransforms.blended_transform_factory(axs[index_00,index_01].transData, axs[index_00,index_01].transAxes)

              varCCond = 'rh_fun_01' + '_' +  \
              ocROI[index_00] + '_'+ stiROI[index_01]  + \
              '_meants_tc.txt'

              # find the index in the orginal text file lists
              varCindex = AllTxtFiles.index(varCCond)
              varCCond_tc = lstTxt[varCindex]
              numVoxels = varCCond_tc.shape[1]
              axs[index_00,index_01].fill_between([0,5],-2,2,facecolor='grey', alpha=0.5, transform=trans)
              axs[index_00,index_01].hlines(0,0,5,linestyles="dashed",colors='k')
              yerr2 = stats.sem(aryBold[(iterations-1)*4 + 3],axis=1)
              yerr1 = stats.sem(aryBold[(iterations-1)*4 + 1],axis=1)
              axs[index_00,index_01].errorbar(xaxis,np.mean(aryBold[(iterations-1)*4 + 3],axis=1), yerr=yerr2, label='both limits (default)')
              axs[index_00,index_01].errorbar(xaxis,np.mean(aryBold[(iterations-1)*4 + 1],axis=1), yerr=yerr1, label='both limits (default)')
              axs[index_00,index_01].set_ylim([-2,4.8])
              axs[index_00,index_01].set_xticks(ind)


#              if index_01 < 2:
#                   axs[index_00,index_01].set_ylim([-2.5,2.5])
#              else:
#                   axs[index_00,index_01].set_ylim([-2,4.8])
              axs[index_00,index_01].set_title('rh_sub-12_lroi_nf_' + ocROI[index_00] +'_'+  stiROI[index_01] + \
                          '['+str(numVoxels) +' voxels]')

fig.legend(['Stimulus block','Zero %BOLD Change','Lum_Decre','Lum_Incre'], loc=5)
fig.suptitle('rh_lroi_nfsub-12_ROI_Event_Related_Average',x=0.5,y=0.94,fontsize=18)
plt.savefig(sub_path+'Intermediate_steps/'+'rh_sub-12_lroi_nf_ROI_Event_Related_Average.svg')
plt.savefig(sub_path+'Intermediate_steps/'+'rh_sub-12_lroi_nf_ROI_Event_Related_Average.pdf')
plt.savefig(sub_path+'Intermediate_steps/'+'rh_sub-12_lroi_nf_ROI_Event_Related_Average.png')

      #
# plt.close('all')

np.save('sub-12_lroi_nf_rh.npy', aryBold)
