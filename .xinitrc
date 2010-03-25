#!/bin/bash

# Start SCIM
#scim -d &

# Merge X settings
xrdb -merge $HOME/.Xresources &

# Start unclutter
unclutter -idle 2 -root &

# Make forward & back mouse buttons work
imwheel -k -b "67" > /dev/null &

# Enable Glyph Cache
nvidia-settings -a InitialPixmapPlacement=2 -a GlyphCache=1 > /dev/null &

# Enable sound
amixer set Front 100 unmute > /dev/null &
amixer set Line mute > /dev/null &
mpc volume 74 &

# Load animenfo if playlist is empty
([[ $(mpc playlist) ]] || mpc load animenfo) &

# Run urxvtd, to start terminals faster
urxvtd &

# Set keyboard layout
hdv &

# WMName for Java
wmname LG3D &

# Set keyboard repeat rate
xset r rate 250 30 &

# Monitor-specific commands
for display in ":0.0" ":0.1" ":0.2" ":0.3" ":0.4" ":0.5";
do
    # Set background color to gray
    DISPLAY=$display xsetroot -gray &

    # Start a term
    (sleep 1 ; DISPLAY=$display urxvtc) &
done;

# Start WM
while true;
do
    awesome &> ~/.awesome.log
    #sleep 25
done;
