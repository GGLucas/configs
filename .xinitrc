#!/bin/bash
export PATH="$HOME/bin:$PATH"

# Merge X settings
xrdb -merge $HOME/.Xresources &

# Start unclutter
unclutter -idle 2 -root &

# Enable sound
amixer set Front 100 unmute > /dev/null &
amixer set Line mute > /dev/null &
mpc volume 74 &

# Load animenfo if playlist is empty
#([[ $(mpc playlist) ]] || mpc load animenfo) &

# Run urxvtd, to start terminals faster
urxvtd &

# Set keyboard layout
hdv_te &

# Start keynav for keyboard navigation
#keynav &

# Set keyboard repeat rate
xset r rate 180 80 &

# Add local fonts
xset fp+ /usr/share/fonts/local

# Turn off screensaver
xset s off

#Control mouse speed
xset m 1/1 1

#Boot up synergy
sudo systemctl start synergys

# Turn off touchpad
#tsy 1

# Start WM
while true;
do
    i3 &> ~/.i3.log
done;
