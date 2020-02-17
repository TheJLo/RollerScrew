#!/usr/bin/env python3

from rsgl_parts import *

class RSGL_Thread(RSGL_Part):
    
    def __init__(self, lead = 10, angle = 30, taper = 0, size = -1, rect_thread = False, rectangle = 1):
        self._lead          = lead      # Lead of the screw (mm / rev)
        self._angle         = angle     # Angle of the thread triangle
        self._taper         = taper
        self._thread_size   = size
        self._rect_thread   = rect_thread
        self._rectangle     = rectangle

    def _calc_maj_dia(self, ref_dia):
        if self._rect_thread:
            print('Please be easy')
        else:
            print('Fuck you Math')
