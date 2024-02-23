#!/bin/sh

XFWM_COMP_STATUS=$(xfconf-query -c xfwm4 -p /general/use_compositing)

if $XFWM_COMP_STATUS; then
    xfconf-query -c xfwm4 -p /general/use_compositing -s false
else
    xfconf-query -c xfwm4 -p /general/use_compositing -s true
fi

killall plank
exec plank
