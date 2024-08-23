#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Nov 25 20:39:28 2020
This script is to plot motion parameters
@author: yawen
"""
# =============================================================================
import nipype.interfaces.fsl as fsl
import itertools
import time
import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
from scipy import stats
# =============================================================================
# ***  Check time
varTme01 = time.time()

# =============================================================================
# Define parameters

ParentPth  = '/media/g/P04/Data/BIDS/'
subject_id = 'sub-12'
arySessions= ['ses-001','ses-002']
aryTasks   = ['pRF', 'BI']
aryRuns    = [3, 6]
aryVolumes = [1227, 1258]
lstMotion  = []
lstMotion_Nme  = []
lstTR      = []
# =============================================================================
# =============================================================================
# Iterate all the runs through sessions on current subject
for sesid in range(len(arySessions)):
     # Current session:
     currpth = ParentPth + subject_id + '/' + arySessions[sesid] +'/func/'

     lstSesMot = []
     lstSesMot_Nme = []
     lstTR_ses     = []

     for runid in range(aryRuns[sesid]):
          # Mats folder for Current run:
          currRun = ( currpth + subject_id  + '_' + arySessions[sesid]
               + '_task-' + aryTasks[sesid] + '_acq-EP3D_dir-RL_run-' +
               str(runid+1) + '_echo-1_bold_mats/' )

          lstRunMot = []
          lstTR_run = []
          lstRunMot_Nme = []


          for volid in range (1000, aryVolumes[sesid]):

               # Current mats
               currMats = currRun + '3d_vol_' + str(volid) + '_FSL.mat'

               tmp = fsl.AvScale(all_param=True,mat_file=currMats)

               tmpReadout = tmp.run()

               # Get the rotations (in rads) and translations (in mm) per volume

               aryTmpMot = list(itertools.chain.from_iterable(
                                [tmpReadout.outputs.translations,
                                 tmpReadout.outputs.rot_angles]))




               # Save the roation and translations
               lstRunMot.append(aryTmpMot)
               lstTR_run.append([volid+1-1000+runid*(aryVolumes[sesid]-1000) for i in range(6)])
               lstRunMot_Nme.append(['TX','TY','TZ','RX','RY','RZ'])
               
               
          with open((currpth + subject_id+'_'+arySessions[sesid] +'_run'+
                     str(runid+1) +'_fsl_mot.txt'),'w') as txt_file:
               for lne in lstRunMot:
                    txt_file.write(" ".join(str(x) for x in lne) + "\n")
                    
          # zscore the motion parameters          
          aryRunMot = stats.zscore(np.array(lstRunMot),axis=0)          
          with open((currpth + subject_id+'_'+arySessions[sesid] +'_run'+
                     str(runid+1) +'_fsl_mot_zscore.txt'),'w') as txt_file:
               for lne in aryRunMot:
                    txt_file.write(" ".join(str(x) for x in lne) + "\n")




          lstSesMot.append(lstRunMot)
          lstTR_ses.append(lstTR_run)
          lstSesMot_Nme.append(lstRunMot_Nme)


     lstMotion.append(lstSesMot)
     lstMotion_Nme.append(lstSesMot_Nme)
     lstTR.append(lstTR_ses)

varTme02 = time.time()
varTme03 = varTme02 - varTme01
print('-Elapsed time: ' + str(varTme03) + ' s')
print('-Done.')

# =============================================================================
# Plot motion

for sesid in range(len(arySessions)):

     volumes = aryVolumes[sesid]-1000
     aryCurr = np.array(lstMotion[sesid])
     aryCurr_Ses =  aryCurr.reshape((aryCurr.size,-1))
     aryCurr_TR = np.array(lstTR[sesid])
     aryCurr_TR_Ses = aryCurr_TR.reshape((aryCurr_TR.size,-1))
     aryCurr_Nme = np.array(lstMotion_Nme[sesid])
     aryCurr_Nme_Ses = aryCurr_Nme.reshape((aryCurr_Nme.size,-1))
     aryIdx = np.arange(1,len(aryCurr_Nme_Ses)+1)

     Rot_idx = np.where(aryCurr_Nme_Ses==['RX','RY','RZ'])
     Rot_TR, Rot_MNme,Rot_Mot = aryCurr_TR_Ses[Rot_idx[0]], aryCurr_Nme_Ses[Rot_idx[0]], aryCurr_Ses[Rot_idx[0]]
     dict_ses_rot = {
          'Time/TR': Rot_TR[:,0],
          'Rotation_Direction': Rot_MNme[:,0],
          'Rotation/Degrees': np.rad2deg(Rot_Mot[:,0]),
          'idx':Rot_idx[0]}
     pd_ses_rot = pd.DataFrame(data=dict_ses_rot)

     fig, (ax1, ax2) = plt.subplots(2,1, figsize = [20,16], sharex = True)


     ax1 = sns.lineplot(x='Time/TR',y='Rotation/Degrees',data=pd_ses_rot,hue='Rotation_Direction',ax=ax1)
     vsep1 = [(runid+1)* volumes for runid in range(aryRuns[sesid])]
     ax1.legend(loc=2)
     ax1.vlines(vsep1,np.rad2deg(Rot_Mot[:,0]).min(),np.rad2deg(Rot_Mot[:,0]).max(),'k','dashdot')
     ax1.set_title(subject_id+'_'+ arySessions[sesid]+'_' +'Rotation Summary')
#     output=ParentPth+ subject_id +'/'+'ses-002'+'/Intermediate_steps/'
#     plt.savefig(output + subject_id+'_'+ arySessions[sesid]+'_' +'Rotation Summary.png')
#     plt.savefig(output + subject_id+'_'+ arySessions[sesid]+'_' +'Rotation Summary.pdf')

     Tra_TR, Tra_MNme,Tra_Mot = aryCurr_TR_Ses[~Rot_idx[0]], aryCurr_Nme_Ses[~Rot_idx[0]], aryCurr_Ses[~Rot_idx[0]]

     Tra_idx = np.where(aryCurr_Nme_Ses==['TX','TY','TZ'])
     dict_ses_tra = {
          'Time/TR': Tra_TR[:,0],
          'Translation_Direction': Tra_MNme[:,0],
          'Translation/mm': Tra_Mot[:,0],
          'idx':Tra_idx[0]}
     pd_ses_tra = pd.DataFrame(data=dict_ses_tra)

     ax2 = sns.lineplot(x='Time/TR',y='Translation/mm',data=pd_ses_tra,hue='Translation_Direction',ax=ax2)
     vsep2 = [(runid+1)* volumes for runid in range(aryRuns[sesid])]
     ax2.legend(loc=2)
     ax2.vlines(vsep2,Tra_Mot[:,0].min(),Tra_Mot[:,0].max(),'k','dashdot')
     ax2.set_title(subject_id+'_'+ arySessions[sesid]+'_' +'Translation Summary')
     output=ParentPth+ subject_id +'/'+'ses-002'+'/Intermediate_steps/'
#     plt.savefig(output + subject_id+'_'+ arySessions[sesid]+'_' +'Translation Summary.png')
#     plt.savefig(output + subject_id+'_'+ arySessions[sesid]+'_' +'Translation Summary.pdf')
     plt.suptitle(subject_id+'_'+ arySessions[sesid]+'_' +'Motion Summary', size=16)
     plt.savefig(output + subject_id+'_'+ arySessions[sesid]+'_' +'Motion Summary.png')
     plt.savefig(output + subject_id+'_'+ arySessions[sesid]+'_' +'Motion Summary.pdf')
     plt.close('all')

# =============================================================================
