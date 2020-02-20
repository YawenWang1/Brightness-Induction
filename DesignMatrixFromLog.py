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
# Mistake in writing logs files
# During condition 4, after presenting while inducers, the lumiance should be 
# go back, but I wrote down it sweep up.
# Define Directory of Log file
# Directory in Linux
#LogPth = "/media/h/P04/Data/S04/Ses01/05_7T_psy/20191217/BI/"
# Directory in Windows
LogPth = "H:\\P04\\Data\\S04\\Ses01\\05_7T_psy\\20191217\\BI\\20191217\\"

os.chdir(LogPth)

# Get all the log filenames
Logfiles = glob.glob(LogPth +'*.log')

# Type of Condtions

ConditonsName = ['Lum_Up','Lum_Down','Target']
StiEnd = 'STIMULUS end'
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
    
    tmpidx = logfile.find('_2019')
    currtxt = logfile[0:-21]
   
        
    # Look through csv file to fill in the currCsv
    for lstTmp in currlogfile:
        for strtmp in lstTmp:
            currCsv.append(strtmp[:])
            
    # Close file
    fileCsvLog.close()
    
    # Find the onset, duration for condition
    for currevent in EvenType:
        eventlst = dict()
        eventcounter = -1
       
        if currevent !=  'TARGET':
            if currevent == 'condition 3.0':
                midname = 'Lum_Down'
            elif currevent == 'condition 4.0':
                midname = 'Lum_Up'


            currtxtname = currtxt + '_' + midname + '.txt'
            
            for currline in range(0,len(currCsv)):
                # Find the current event in current csv list
                if currevent in currCsv[currline]:
                    # count the number of the current event
                    eventcounter += 1
                    # Write down current block
                    currblock = currCsv[currline].split()[6][0]
                    # Get the notation of end of current stimulus conditon
                    endtxt = "STIMULUS end of event " + currblock
                    # Write down the onset of the current event
                    onset_currevent = currCsv[currline].split()[0]
                    # Write down the event type
                    type_currevent = currCsv[currline].split()[8][0]
                    
                if eventcounter >= 0:
                    if endtxt in currCsv[currline]:
                        dur_currevent = str(float(currCsv[currline+2].split()[0]) \
                                        - float (onset_currevent))
                        # fill in the dictionary variable
                        eventlst[eventcounter]=[onset_currevent, \
                                                dur_currevent, \
                                                type_currevent]
                        
                        endtxt = 'invalid'
        
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
                    dur_currevent  = '1'

                    # fill in the dictionary variable
                    eventlst[eventcounter]=[onset_currevent, \
                                                dur_currevent, \
                                                type_currevent]

            
            

        # Write the current conditon to txt file            
        fileid = open(currtxtname, 'w')
        for k, v in eventlst.items():
            fileid.write(v[0] + ' ' + v[1] + ' ' + v[2] + '\n')
        fileid.close()
        
       
            
    

            
            
            
