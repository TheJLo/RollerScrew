
#!/usr/bin/env python3

from rsgl_parts import *

# ---- Chamfers ----
CHAMFER_NONE    = 0
CHAMFER_POS_Z   = 1
CHAMFER_BOTH    = 2
CHAMFER_NEG_Z   = 3

class RSGL_Thread(RSGL_Part):
    
    def __init__(self, lead = 1, angle = 30, taper = 0, size = -1, rect_thread = False, rectangle = 0):
        self._lead          = lead      # Lead of the screw (mm / rev)
        self._angle         = angle     # Angle of the thread triangle
        self._taper         = taper
        self._thread_size   = size
        self._rect_thread   = rect_thread
        self._rectangle     = rectangle

    def _calc_maj_dia(self, ref_dia):
        if self._rect_thread:
            print('Please be easy')
            return ref_dia # NOT ACTUALLY THE CALC
        else:
            print('Fuck you Math')
            return ref_dia # NOT ACTUALLY THE CALC
        
    # cham_lead is in pitch units
    def generate_geometry(self, ref_dia = -1, length = -1, starts = 1, internal = False, groove = False, chamfer = CHAMFER_NONE, cham_lead = 1.0):
        print('Generating')
        
        if ref_dia <= 0:
            ref_dia = self._lead * 10
            
        if length <= 0:
            length = self._lead * 2
        
        g = threads.metric_thread(
            diameter=self._calc_maj_dia(ref_dia), 
            pitch=self._lead / starts, 
            length=length, 
            internal=internal, 
            n_starts=starts,
            thread_size=self._thread_size, 
            groove=groove, 
            square=self._rect_thread, 
            rectangle=self._rectangle,
            angle=self._angle, 
            taper=self._taper, 
            leadin=chamfer, 
            leadfac=cham_lead, 
            test=False)
        
        return g
