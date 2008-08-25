#!/bin/bash

# Merge X settings
xrdb -merge $HOME/.Xresources

# Keytouch launch
#bash /etc/X11/Xsession.d/92_keytouchd_launch

# Xmodmap keys
xmodmap $HOME/.Xmodmap

# Turn on numlock
#numlockx

# SCIM
#export XMODIFIERS=@im=SCIM
#export GTK_IM_MODULE="scim"
#export QT_IM_MODULE="scim"
#scim -d

# Start WM
#exec awesome && exit
awesome &
#wmii &

# Launch autostart script
exec bash $HOME/.autostart
