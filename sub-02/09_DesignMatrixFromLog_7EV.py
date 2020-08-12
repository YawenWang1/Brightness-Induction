#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jul 11 16:51:11 2019

@author: yawen
"""

# This script is to generate design matrix used in FSL-FEAT
# import modules
import os
import csv
import glob
from pathlib import Path
# Directory in Linux
LogPth = "/media/h/P04/Data/BIDS/sub-02/ses-002/psyc/BI/"
OptPth = "/media/h/P04/Data/BIDS/sub-02/ses-002/func/DM_01/"

# Make new folder for GLM design matrix
Path(OptPth).mkdir(parents=True,exist_ok=True)
# Switch to the folder containing log files
os.chdir(LogPth)
# Get all the log filenames
Logfiles = glob.glob(LogPth +'*.log')

ppheight='1'

# Type of Condtions
filecounter = 0
# Iterate all the log files in the current directory
for logfile in Logfiles:

    # Types of Events
    EvenType = [
            'TARGET',
            'condition 3.0',
            'condition 4.0']

    fileCsvLog = open(logfile,'r')
    currlogfile = csv.reader(fileCsvLog,
                             delimiter='\n',
                             skipinitialspace=True)
    currCsv = []

    tmpidx = logfile.find('_2020')
    currtxt = logfile[0:-21].split('/')[-1]


    # Look through csv file to fill in the currCsv
    for lstTmp in currlogfile:
        for strtmp in lstTmp:
            currCsv.append(strtmp[:])

    # Close file
    fileCsvLog.close()

    # Find the onset, duration for condition
    for currevent in EvenType:
        eventlst, eventlst_pst, eventlst_pre = dict(),dict(),dict()
        eventcounter = -1

        if currevent !=  'TARGET':
            if currevent == 'condition 3.0':
                midname = 'Lum_Down'
                midname_pre = 'GB'
                midname_pst = 'BG'
            elif currevent == 'condition 4.0':
                midname = 'Lum_Up'
                midname_pre = 'GW'
                midname_pst = 'WG'

            currtxtname = currtxt + '_' + midname + '.txt'
            dur_currevent = '11.0'
            
            currtxtname_pre = currtxt + '_' + midname_pre + '.txt'
            currtxtname_pst = currtxt + '_' + midname_pst + '.txt'

            for currline in range(0,len(currCsv)):
                # Find the current event in current csv list
                if currevent in currCsv[currline]:
                    # count the number of the current event
                    eventcounter += 1
                    # Write down current block
                    currblock = currCsv[currline].split()[6][0:-1]
                    # Get the notation of end of current stimulus conditon
                    endtxt = "STIMULUS end of block " + currblock
                    # Write down the onset of the current event
                    onset_currevent_pre = currCsv[currline].split()[0]
                    # Write down the onset of the current event
                    onset_currevent = float(onset_currevent_pre) + 1
                    # Write down the onset of the current event
                    onset_currevent_pst = float(onset_currevent_pre) + 12
                    
                    # Write down the event type
                    type_currevent = currCsv[currline].split()[8][0:-1]

                    # fill in the dictionary variable
                    eventlst[eventcounter]=[str(onset_currevent), \
                                                dur_currevent, \
                                                ppheight]
                    eventlst_pre[eventcounter]=[onset_currevent_pre, \
                                                '1.0', \
                                                ppheight]
                    eventlst_pst[eventcounter]=[str(onset_currevent_pst), \
                                                '1.0', \
                                                ppheight]



        else:
            currtxtname = currtxt + '_' + currevent + \
                     '.txt'
            for currline in range(0,len(currCsv)):
                # Find the current event in current csv list
                if currevent in currCsv[currline]:
                    # count the number of the current event
                    eventcounter += 1
                    # Write down the onset of the current event
                    onset_currevent = currCsv[currline].split()[0]
                    # Write down the event type
                    type_currevent = '2'
                    dur_currevent  = '0.8'

                    # fill in the dictionary variable
                    eventlst[eventcounter]=[onset_currevent, \
                                                dur_currevent, \
                                                ppheight]





        # Write the current conditon to txt file
        fileid = open(OptPth+currtxtname, 'w')
        for k, v in eventlst.items():
            fileid.write(v[0] + ' ' + v[1] + ' ' + v[2] + '\n')
        fileid.close()
        if currevent !=  'TARGET':
             # Write the current conditon to txt file
             fileid = open(OptPth+currtxtname_pre, 'w')
             for k, v in eventlst_pre.items():
                 fileid.write(v[0] + ' ' + v[1] + ' ' + v[2] + '\n')
             fileid.close()
             # Write the current conditon to txt file
             fileid = open(OptPth+currtxtname_pst, 'w')
             for k, v in eventlst_pst.items():
                 fileid.write(v[0] + ' ' + v[1] + ' ' + v[2] + '\n')
             fileid.close()
