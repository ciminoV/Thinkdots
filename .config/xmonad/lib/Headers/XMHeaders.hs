module Headers.XMHeaders where

import XMonad

-- Colors
colorBack = "#2E3440"
colorFore = "#D8DEE9"

black   = "#3B4252"
red0    = "#BF616A"
green0  = "#A3BE8C"
yellow0 = "#EBCB8B"
blue0   = "#81A1C1"
violet0 = "#B48EAD"
azure0  = "#88C0D0"
gray0   = "#E5E9F0"
gray1   = "#4C566A"
red1    = "#BF616A"
green1  = "#A3BE8C"
yellow1 = "#EBCB8B"
blue1   = "#81A1C1"
violet1 = "#B48EAD"
azure1  = "#8FBCBB"
white   = "#ECEFF4"

-- Variables 
myWorkspaces :: [String]
myWorkspaces  = [" dev ", " www ", " doc ", " fm ", " mlab ", " var ", ""]

myFont :: String
myFont = "xft:SauceCodePro Nerd Font Mono:regular:size=9:antialias=true:hinting=true"

myTerminal :: String
myTerminal    = "st"

myBrowser :: String
myBrowser     = "firefox"

myEditor :: String
myEditor      = myTerminal ++ " -e nvim "

myFileManager :: String
myFileManager = myTerminal ++ " -t vifm -e ~/.config/vifm/scripts/vifmrun"

myBorderWidth :: Dimension
myBorderWidth = 1           -- Sets border width for windows

myNormColor :: String 
myNormColor   = colorBack   -- Border color of normal windows

myFocusColor :: String 
myFocusColor  = azure0      -- Border color of focused windows
