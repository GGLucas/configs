#!/bin/bash

# Merge X settings
xrdb -merge $HOME/.Xresources

# SCIM
#export XMODIFIERS=@im=SCIM
#export GTK_IM_MODULE="scim"
#export QT_IM_MODULE="scim"
#scim -d

# Desktop BG
nitrogen --restore

# Start WM
awesome -c ~/.config/awesome/rc_31.lua &

# Launch autostart script
exec bash $HOME/.autostart
