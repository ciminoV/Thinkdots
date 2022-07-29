#!/bin/sh

# Keyboard layout
setxkbmap it &

# Default cursor
xsetroot -curson_name left_ptr

# Speedy keys
xset r rate 210 40

# Load .Xresources
xrdb -merge ~/.Xresources

# MATLAB fix
export _JAVA_AWT_WM_NONREPARENTING=1

# Start WM
exec xmonad
