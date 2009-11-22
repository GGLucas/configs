#!/bin/bash

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
setxkbmap -I$HOME/.xkb -model evdev -layout hdv -print | \
    xkbcomp -I$HOME/.xkb - :0 > /dev/null &

# Fix left alt
(sleep 1; xmodmap -e "remove mod4 = Alt_L") &

# WMName for Java
wmname compiz &

# Set keyboard repeat rate
xset r rate 250 30 &

# Monitor-specific commands
for display in ":0.0" ":0.1" ":0.2" ":0.3" ":0.4" ":0.5";
do
    [[ $(xrandr -q | head -n 1 | sed 's/^.*current \([0-9]*\) x.*$/\1/') \
        -eq "2048" ]] \
    && BG=~/pictures/end_2048.png \
    || BG=~/pictures/end_1680.png

    # Start feh for each display
    DISPLAY=$display feh --bg-scale $BG &

    # Start a term on every display
    (sleep 1; DISPLAY=$display urxvtc) &
done;

# Start WM
while true;
do
    awesome
    #sleep 25
done;
