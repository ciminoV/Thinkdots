#!/bin/sh

# Keyboard layout
setxkbmap it &

# Default cursor
xsetroot -curson_name left_ptr

# MATLAB fix
export _JAVA_AWT_WM_NONREPARENTING=1

# Start WM
exec xmonad
