#!/bin/bash

# Merge X settings
xrdb -merge $HOME/.Xresources

# SCIM
#export XMODIFIERS=@im=SCIM
#export GTK_IM_MODULE="scim"
#export QT_IM_MODULE="scim"
#scim -d

# Desktop BG
BG=~/pictures/bg.png

for display in ":0.0" ":0.1" ":0.2" ":0.3";
do
    DISPLAY=$display feh --bg-scale $BG &
done;

# Start unclutter
unclutter -idle 2 -root &

# Make forward & back mouse buttons work
imwheel -k -b "67" > /dev/null &

# Enable Glyph Cache
nvidia-settings -a InitialPixmapPlacement=2 -a GlyphCache=1 > /dev/null &

# Enable sound
amixer set Front 100 unmute > /dev/null &
mpc volume 74

# Run urxvtd, to start terminals faster
urxvtd &

# Xmodmap keys
xmodmap $HOME/.Xmodmap

# WMName for Java
wmname compiz

# Start WM
while true;
do
    stumpwm
    #awesome -c ~/.config/awesome/rc_31.lua
    #ratpoison
done;
