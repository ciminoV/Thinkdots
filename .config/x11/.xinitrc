#!/bin/sh

# Default cursor
xsetroot -cursor_name left_ptr

# Speedy keys
xset r rate 210 40

# Load .Xresources
xrdb -merge ~/.Xresources

# Dunst fix
systemctl --user import-environment DISPLAY

# Start WM
exec xmonad
