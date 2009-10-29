#!/bin/bash

# Merge X settings
xrdb -merge $HOME/.Xresources &

# SCIM
#export XMODIFIERS=@im=SCIM
#export GTK_IM_MODULE="scim"
#export QT_IM_MODULE="scim"
#scim -d

# Start unclutter
unclutter -idle 2 -root &

# Make forward & back mouse buttons work
imwheel -k -b "67" > /dev/null &

# Enable Glyph Cache
nvidia-settings -a InitialPixmapPlacement=2 -a GlyphCache=1 > /dev/null &

# Enable sound
amixer set Front 100 unmute > /dev/null &
mpc volume 74 &

# Run urxvtd, to start terminals faster
urxvtd &

# Set keyboard layout and xmodmap
(setxkbmap -model evdev -layout hdv && xmodmap $HOME/.Xmodmap) &

# WMName for Java
wmname compiz &

# Notify for rftg online
#rftg-notify &

# Set keyboard repeat rate
xset r rate 250 30 &

for display in ":0.0" ":0.1" ":0.2" ":0.3" ":0.4" ":0.5";
do
    [[ $(xrandr -q | head -n 1 | sed 's/^.*current \([0-9]*\) x.*$/\1/') \
        -eq "2048" ]] \
    && BG=~/pictures/end_2048.png \
    || BG=~/pictures/end_1680.png

    # Start feh for each display
    DISPLAY=$display feh --bg-scale $BG &

    # Start keynav for each display
    #(sleep 5; DISPLAY=$display keynav) &
done;

# Start WM
while true;
do
    #stumpwm
    awesome
    #ratpoison
    #sleep 100
done;
