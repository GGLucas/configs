#!/usr/bin/env python
# Python script to run for filling the awesome statusbar, by GGLucas (lucas@glacicle.com)
import time, copy, dbus, dbus.service

# Main settings
_MAIN_INTERVAL = 1 # Seconds to sleep between loop iterations
_STATUSBAR = 'mystatusbar' # Default statusbar to use
_TIMERS = {"main": 1, "frequent": 10, "occasional": 120} # Timers to set

# Get dbus session bus
_SESSION_BUS = dbus.SessionBus()  

def widget_tell(widget, text, statusbar = None):
    if statusbar == None:
        # Use default if not set
        statusbar = _STATUSBAR
        
        obj = _SESSION_BUS.get_object("org.awesome", '/org/awesome/screen/0/statusbar/'+statusbar+'/widget/'+widget+'/property/text')
        obj.widget_tell(text, dbus_interface='org.awesome.statusbar.widget.set')
                              
widget_tell('tx_cpu', 'TESTBLABLA')

class Timers:
    def mainTimer(self):
        pass

    def frequentTimer(self):
        pass

    def occasionalTimer(self):
        pass

if __name__ == "__main__":
    timercounter = copy.copy(_TIMERS) #Make a copy of all timers set
    timers = Timers()
    
#    # Main loop
#    while True:
#        # Sleep the specified interval
#        time.sleep(_MAIN_INTERVAL); 
#        
#        # Loop through all timers, increment them and update if neccesary
#        for timer in timercounter:
#            timercounter[timer] += 1
#            
#            # Check if we should update
#            if timercounter[timer] >= _TIMERS[timer] :
#                timercounter[timer] = 0
#                
#                # Run timer's function
#                if hasattr(timers, timer+"Timer"):
#                    getattr(timers, timer+"Timer")()
