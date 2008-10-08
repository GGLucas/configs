#!/bin/bash

# Merge X settings
xrdb -merge $HOME/.Xresources

# Keytouch launch
#bash /etc/X11/Xsession.d/92_keytouchd_launch

# Turn on numlock
#numlockx

# SCIM
#export XMODIFIERS=@im=SCIM
#export GTK_IM_MODULE="scim"
#export QT_IM_MODULE="scim"
#scim -d

# Desktop BG
nitrogen --restore

# Start WM
#exec awesome && exit
if [ -n $AWE_CONF ]
then
    awesome -c $AWE_CONF &
else
    awesome &
fi

# Launch autostart script
exec bash $HOME/.autostart
