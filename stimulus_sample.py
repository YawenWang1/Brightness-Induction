#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jul  2 14:00:08 2020
This script is for generating stimulus sample for presentation
@author: yawen
"""

import numpy as np
from  scipy.ndimage import uniform_filter
from PIL import Image, ImageDraw

# =============================================================================
# # *** Define parameters

# Size of Stimulus [pixels]:
tplSze = (1920, 1200)
varXmin = -8.3
varXmax = 8.3
varXstep = tplSze[0]
varYmin = -5.19
varYmax = 5.19
varYstep = tplSze[1]
# Limits of central square ROI:
tplLimCntrX = (-6, 6)
tplLimCntrY = (-2.5, 2.5)
# =============================================================================
# -----------------------------------------------------------------------------

# Mean pixel intensity of random texture background (same as in Pac-Man study)
# is, in RGB values (range 0 to 255): 37
# Conversion to psychopy pixel intensity (range -1 to 1):
# (37.0 / 255.0) * 2.0 - 1.0 = -0.7098039215686274
#                            ~ -0.71
#
# The conversion from pixel intensity to luminance is based on a luminance
# measurement performed on 13.09.2018.

# Mean pixel intensity of background [RGB intensity, 0 to 255]:
varPixBcgrd = ((1.0 + 1.0) * 0.5) * 255.0  # 37

# Standard deviation of pixel intensity before smoothing [RGB intensity, 0 to
# 255]:
# varSd = ((-0.5294117647058824 + 1.0) * 0.5) * 255.0  # 60.0
varSd = 0  # 60.0

# Mean pixel intensity of foregound square [RGB intensity, 0 to 255]:
varPixSqr = ((0.0 + 1.0) * 0.5) * 255.0  # 127.5

#
# Size of visual space:
# x (width): 2 * 8.3 deg/v.a.
# y (height): 2 * 5.19 deg/v.a.
#
# Position of square in terms of array indices:
varSqrPosX1 = int(np.around(
                            (0.5 * float(tplSze[0]))
                            - (float(tplSze[0]) * 0.5 * (6 / 8.3))
                            ))
varSqrPosX2 = int(np.around(
                            (0.5 * float(tplSze[0]))
                            + (float(tplSze[0]) * 0.5 * (6 / 8.3))
                            ))
varSqrPosY1 = int(np.around(
                            (0.5 * float(tplSze[1]))
                            - (float(tplSze[1]) * 0.5 * (2.5 / 5.19))
                            ))
varSqrPosY2 = int(np.around(
                            (0.5 * float(tplSze[1]))
                            + (float(tplSze[1]) * 0.5 * (2.5 / 5.19))
                            ))


# Create a surface with the same size of the screen from the scanner 
[arySpaceXcrt, arySpaceYcrt] = np.meshgrid(
    np.linspace(varXmin, varXmax, int(varXstep)),
    np.linspace(varYmin, varYmax, int(varYstep)))


# Mask for central square:
aryLgcCntr = np.logical_and(
                            np.logical_and(
                                           np.greater(arySpaceXcrt,
                                                      tplLimCntrX[0]),
                                           np.less(arySpaceXcrt,
                                                   tplLimCntrX[1])
                                           ),
                            np.logical_and(
                                           np.greater(arySpaceYcrt,
                                                      tplLimCntrY[0]),
                                           np.less(arySpaceYcrt,
                                                   tplLimCntrY[1])
                                           )
                            ).astype(np.float64)

aryLgcBkc = np.logical_or(
                            np.logical_or(
                                           np.greater(arySpaceXcrt,
                                                      tplLimCntrX[1]),
                                           np.less(arySpaceXcrt,
                                                   tplLimCntrX[0])
                                           ),
                            np.logical_or(
                                           np.greater(arySpaceYcrt,
                                                      tplLimCntrY[1]),
                                           np.less(arySpaceYcrt,
                                                   tplLimCntrY[0])
                                           )
                            ).astype(np.float64)

aryValCntr = (aryLgcCntr * varPixSqr).astype(np.uint8)

aryValBkc = (aryLgcBkc * varPixBcgrd).astype(np.uint8)

aryValBkc[np.nonzero(aryLgcCntr)] = varPixSqr
aryValBkc = aryValBkc.astype(np.uint8)

aryValgrey = aryValBkc
aryValgrey[:] = varPixSqr

# Output path (mean intensity, standard deviation, filter sie, and suffix left
# open):
strPthOut_down = '/media/h/P04/stimulus_lum_down.png'
strPthOut_up = '/media/h/P04/stimulus_lum_up.png'
strPthOut_grey = '/media/h/P04/stimulus_base.png'

# -----------------------------------------------------------------------------
# *** Save texture

# Create image lum down condition
objImg_Down = Image.fromarray(aryValCntr, mode='L')

# Save image to disk 
objImg.save(strPthOut_down)

# Create image - Luminance up condition
objImg_Up = Image.fromarray(aryValBkc, mode='L')

# Save image to disk - square on texture:
objImg.save(strPthOut_up)

objImg_Base = Image.fromarray(aryValgrey, mode='L')

# Save image to disk - square on texture:
objImg.save(strPthOut_grey)

# -----------------------------------------------------------------------------
# =============================================================================
# Make gif
ObjGif_up = []
ObjGif_up.append(objImg_Base)
for i in range(0,10):
     ObjGif_up.append(objImg_Up)
     
ObjGif_up.append(objImg_Base)

ObjGif_up[0].save('/media/h/P04/stimulus_lum_up.gif',format='GIF',append_images=ObjGif_up[1:],save_all=True,duration=500,loop=0)
#-----------------------------------------------------------------------------
ObjGif_down = []
ObjGif_down.append(objImg_Base)
for i in range(0,10):
     ObjGif_down.append(objImg_Down)
     
ObjGif_down.append(objImg_Base)

ObjGif_down[0].save('/media/h/P04/stimulus_lum_down.gif',format='GIF',append_images=ObjGif_down[1:],save_all=True,duration=500,loop=0)

# =============================================================================
