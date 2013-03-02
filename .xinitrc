#!/bin/bash
export PATH="$HOME/bin:$PATH"

# Spawn mail syncer in the background
#syncMail &>/dev/null &

# Spawn rssdler in the background
#rssdler -o &>/var/log/rssdler &

# Xrandr layout
#sh .screenlayout/setup.sh

# Merge X settings
xrdb -merge $HOME/.Xresources &

# Start unclutter
unclutter -idle 2 -root &

# Make forward & back mouse buttons work
#imwheel -k -b "67" > /dev/null &

# Enable Glyph Cache
#nvidia-settings -a InitialPixmapPlacement=2 -a GlyphCache=1 > /dev/null &

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
#sudo /etc/rc.d/synergys start

# Monitor-specific commands
#for display in ":0.0" ":0.1" ":0.2" ":0.3" ":0.4" ":0.5";
#do
    ## Set background color to gray
    #DISPLAY=$display xsetroot -solid black &

    ## Set mouse speed
    #DISPLAY=$display xset m 1.5 1

    ## Start a term
    #(sleep 1 ; DISPLAY=$display urxvtc) &
#done;

# Turn off touchpad
#tsy 1

# Start compositing
#xcompmgr -r0 &

# Start WM
while true;
do
    #awesome &> ~/.awesome.log
    #pekwm &> ~/.pekwm.log
    i3 &> ~/.i3.log
    #goomwwm &> ~/.goomwwm.log
    #sleep 25
done;
