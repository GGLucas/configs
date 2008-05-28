#!/bin/bash

# Merge X settings
xrdb -merge $HOME/.Xresources

# Keytouch launch
#bash /etc/X11/Xsession.d/92_keytouchd_launch

# Xmodmap keys
xmodmap $HOME/.Xmodmap

# Turn on numlock
#numlockx

# Launch DBUS
if test -z "$DBUS_SESSION_BUS_ADDRESS" ; then
 dbus-launch --sh-syntax -with-session
fi

# Start WM
#exec awesome && exit
awesome &
#wmii &

# Launch autostart script
exec bash $HOME/.autostart
