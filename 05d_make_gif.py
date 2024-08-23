#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Dec 16 23:04:09 2020

for creating gif animation to check motions from subjects

@author: yawen
"""
import glob

import imageio

Pth = '/media/g/P04/Data/BIDS/'
subjID = 'sub-12'
sessions = ['ses-001', 'ses-002']
# sessions = ['ses-001']

PthRest = '/func/GLM/'
#PthRest = '/func/GLM/BI/'
arytask = ['pRF', 'BI']
Views=['axial','coronal','sagital']
#for sesid in range(0,len(sessions)):

for sesid in range(0,len(sessions)):
     for vwid in Views:
          images = []
          filenames = sorted(glob.glob((Pth + subjID + '/' + sessions[sesid]
                                       + PthRest + arytask[sesid] + '/' + subjID + '_'
                                        + sessions[sesid] + '_' + vwid + '_*.png')))




          for filename in filenames:
              images.append(imageio.imread(filename))
          imageio.mimsave((Pth + subjID + '/' + sessions[sesid]
                                       + PthRest + arytask[sesid] + '/' + subjID + '_'
                                       + sessions[sesid] + '_' + vwid + '.gif'), images,fps=5)
