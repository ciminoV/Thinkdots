------------------------------------------------------------------------
-- IMPORTS
------------------------------------------------------------------------

-- Base
import XMonad hiding ( (|||) )
import System.IO (hClose, hPutStr)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

-- Data
import Data.Char (toUpper)
import Data.Maybe (isJust)
import qualified Data.Map as M

-- Actions
import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.CycleWS
import XMonad.Actions.WithAll (sinkAll, killAll)

-- Hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.EwmhDesktops

-- Util
import XMonad.Util.EZConfig
import XMonad.Util.NamedActions
import XMonad.Util.Loggers
import XMonad.Util.ClickableWorkspaces
import XMonad.Util.Ungrab
import XMonad.Util.Run (spawnPipe)

-- Layout
import XMonad.Layout.LayoutCombinators (JumpToLayout(..), (|||))
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows)
import XMonad.Layout.Magnifier
import XMonad.Layout.ThreeColumns
import XMonad.Layout.ResizableTile
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Layout.Renamed

-- Colors
import Colors.XMColors

------------------------------------------------------------------------
-- MAIN
------------------------------------------------------------------------

-- Main and all the combinators
main :: IO ()
main = xmonad
     . ewmhFullscreen
     . ewmh
     . withEasySB (statusBarProp "xmobar ~/.config/xmobar/xmobarrc" (clickablePP myXmobarPP)) defToggleStrutsKey
     . addDescrKeys' ((mod4Mask, xK_F1), showKeybindings) myKeys
     $ myConfig

-- Main configuration
myConfig = def
    { modMask    = mod4Mask      -- Rebind Mod to the Super key
    , layoutHook = myLayout      -- Use custom layouts
    , manageHook = myManageHook  -- Match on certain windows
    , workspaces = myWorkspaces
    , terminal   = myTerminal
    , borderWidth        = myBorderWidth
    , normalBorderColor  = myNormColor
    , focusedBorderColor = myFocusColor
    }

-- Main variables
myWorkspaces  = [" dev ", " www ", " doc ", " fm ", " mlab ", " var "]

myFont = "xft:SauceCodePro Nerd Font Mono:regular:size=9:antialias=true:hinting=true"

myTerminal    = "st"

myBrowser     = "brave"

myEditor = myTerminal ++ " -e nvim "

myFileManager = myTerminal ++ " -t vifm -e ~/.config/vifm/scripts/vifmrun"

myBorderWidth = 1           -- Sets border width for windows

myNormColor   = colorBack   -- Border color of normal windows

myFocusColor  = azure0      -- Border color of focused windows

------------------------------------------------------------------------
-- XMOBAR
------------------------------------------------------------------------

myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = myppSeparator " • "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = myppCurrent . wrap " " "" . xmobarBorder "Bottom" azure0 2
    , ppHidden          = myppHidden . wrap " " ""
    , ppHiddenNoWindows = myppHiddenNoWindows . wrap " " ""
    , ppUrgent          = myppUrgent . wrap "!" "!"
    , ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
    , ppExtras          = [lTitle]
    }
  where
    lTitle = shortenL 50 (logTitle .| logConst " ")

    myppCurrent, myppSeparator, myppUrgent, myppHidden, myppHiddenNoWindows :: String -> String
    myppCurrent         = xmobarColor azure0 ""
    myppSeparator       = xmobarColor violet0 ""
    myppUrgent          = xmobarColor red0 ""
    myppHidden          = xmobarColor green0 ""
    myppHiddenNoWindows = xmobarColor colorFore ""

------------------------------------------------------------------------
-- HOOKS
------------------------------------------------------------------------

-- Windows hook
myManageHook :: ManageHook
myManageHook = composeAll
    [ className =? "Gimp"                          --> doFloat
    , className =? "Brave-browser"                 --> doShift ( myWorkspaces !! 1 ) -- Open browser in www workspace
    , className =? "MATLAB R2021a - academic use"  --> doShift ( myWorkspaces !! 4 ) -- Open Matlab in mlab workspace
    , title =? "myCal"                             --> doCenterFloat                 -- Open calendar floating center
    , isDialog                                     --> doFloat
    ]

------------------------------------------------------------------------
-- LAYOUT
------------------------------------------------------------------------

myLayout = id 
  $ tiled ||| Mirror tiled ||| full ||| threeCol
  where
    threeCol = renamed [Replace "ThreeCol"]
        $ magnifiercz' 1.3 
        $ limitWindows 5
        $ smartBorders
        $ spacing 1
        $ ThreeColMid 1 (3/100) (1/2)
    tiled    = renamed [Replace "Tall"]
        $ limitWindows 5
        $ smartBorders
        $ spacing 4
        $ ResizableTall 1 (3/100) (1/2) []
    full     = renamed [Replace "Full"]  
       $ noBorders Full

------------------------------------------------------------------------
-- KEYBINDINGS
------------------------------------------------------------------------

-- Subtitle format
subtitle' ::  String -> ((KeyMask, KeySym), NamedAction)
subtitle' x = ((0,0), NamedAction $ map toUpper
                      $ sep ++ "\n-- " ++ x ++ " --\n" ++ sep)
  where
    sep = replicate (6 + length x) '-'

-- Pipe the Named Actions output to yad
showKeybindings :: [((KeyMask, KeySym), NamedAction)] -> NamedAction
showKeybindings x = addName "Show Keybindings" $ io $ do
  h <- spawnPipe $ "yad --text-info --fontname=\"Hack\" --fore=#46d9ff back=#282c36 --center --geometry=1200x800 --title \"XMonad keybindings\""
  hPutStr h (unlines $ showKmSimple x) -- showKmSimple doesn't add ">>" to subtitles
  hClose h
  return ()

-- My keybindings
myKeys :: XConfig l0 -> [((KeyMask, KeySym), NamedAction)]
myKeys c =
    let subKeys str ks = subtitle' str : mkNamedKeymap c ks in
    -- XMonad
    subKeys "Xmonad Essentials"
    [ ("M-r",   addName "Recompile XMonad"     $ spawn "xmonad --recompile")
    , ("M-S-r", addName "Restart XMonad"       $ spawn "xmonad --restart")
--    , ("M-S-q", addName "Quit XMonad"          $ confirmPrompt hotPromptTheme "Quit XMonad" $ (io exitSuccess))
    , ("M-S-q", addName "Quit XMonad"          $ io exitSuccess)
    , ("M-q",   addName "Kill focused window"  $ kill1)]
--    , ("M-S-a", addname "Kill all windows"     $ confirmPrompt hotPromptTheme "kill all" $ killAll)]

    -- Main programs
    ^++^ subKeys "Run programs"
    [ ("M-<Return>",    addName "Run prompt"     $ spawn "st")
    , ("M-w",           addName "Run browser"    $ spawn myBrowser)
    , ("M-<Backspace>", addName "Run Vifm"       $ spawn myFileManager)]

    -- Layouts settings
    ^++^ subKeys "Change layouts"
    [ ("M-<Tab>",   addName "Switch Layout"          $ sendMessage NextLayout )
    , ("M-<Space>", addName "Toggle float window"    $ withFocused toggleFloat)
    , ("M-f",       addName "Toggle full layout"     $ sendMessage $ JumpToLayout "Full")
    , ("M-t",       addName "Toggle tall layout"     $ sendMessage $ JumpToLayout "Tall")]

    -- Multimedia keys
    ^++^ subKeys "Multimedia keys"
    [ ("<XF86AudioMute>",         addName "Toggle audio mute"         $ spawn "pamixer -t & $HOME/.local/bin/volumelevel")
    , ("<XF86AudioLowerVolume>",  addName "Lower volume"              $ spawn "pamixer -u -d 5 & $HOME/.local/bin/volumelevel")
    , ("<XF86AudioRaiseVolume>",  addName "Raise volume"              $ spawn "pamixer -u -i 5 & $HOME/.local/bin/volumelevel")
    , ("<XF86MonBrightnessDown>", addName "Decrease light"            $ spawn "sudo xbacklight -dec 5")
    , ("<XF86MonBrightnessUp>",   addName "Increase light"            $ spawn "sudo xbacklight -inc 5")
    , ("<XF86Display>",           addName "Select display"            $ spawn "$HOME/.local/bin/displayselect")
--    , ("<XF86Tools>",           addName ""     $ spawn "")
--    , ("<XF86Favorites>",       addName ""     $ spawn "")
--    , ("M-<Print>",             addName "Screen selected window"    $ scrotPrompt "home")
    , ("<Print>",                 addName "Take screenshot"           $ spawn "scrot -e 'mv $f ~/Pictures' && notify-send 'Saving screenshot in' 'Pictures...'")]

    -- Resize windows
    ^++^ subKeys "Window resizing"
    [ ("M-h",    addName "Shrink window"               $ sendMessage Shrink)
    , ("M-l",    addName "Expand window"               $ sendMessage Expand)
    , ("M-M1-j", addName "Shrink window vertically"    $ sendMessage MirrorShrink)
    , ("M-M1-k", addName "Expand window vertically"    $ sendMessage MirrorExpand)]

    -- Increase/decrease spacing (gaps)
    ^++^ subKeys "Window spacing (gaps)"
    [ ("C-M1-j", addName "Decrease window spacing"    $ decWindowSpacing 4)
    , ("C-M1-k", addName "Increase window spacing"    $ incWindowSpacing 4)
    , ("C-M1-h", addName "Decrease screen spacing"    $ decScreenSpacing 4)
    , ("C-M1-l", addName "Increase screen spacing"    $ incScreenSpacing 4)]

    -- Navigate windows
    ^++^ subKeys "Window navigation"
    [ ("M-j",   addName "Move focus to next window"                 $ windows W.focusDown)
    , ("M-k",   addName "Move focus to prev window"                 $ windows W.focusUp)
    , ("M-m",   addName "Move focus to master window"               $ windows W.focusMaster)
    , ("M-S-j", addName "Swap focused window with next window"      $ windows W.swapDown)
    , ("M-S-k", addName "Swap focused window with prev window"      $ windows W.swapUp)
    , ("M-S-m", addName "Swap focused window with master window"    $ windows W.swapMaster)]

    -- Navigate monitors
    ^++^ subKeys "Monitors"
    [ ("M-.", addName "Switch focus to next monitor"    $ nextScreen)
    , ("M-,", addName "Switch focus to prev monitor"    $ prevScreen)]

    -- Move to next/prev workspace 
    ^++^ subKeys "Move to next/prev WS"
    [ ("M-<Right>", addName "Move to next WS"    $ moveTo Next nonEmptyNonNSP)
    , ("M-<Left>",  addName "Move to next WS"    $ moveTo Prev nonEmptyNonNSP)]

    -- Send current windows to next/prev workspace 
    ^++^ subKeys "Move window to WS and go there"
    [ ("M-S-<Right>", addName "Move window to next WS"    $ shiftTo Next nonNSP >> moveTo Next nonNSP)
    , ("M-S-<Left>",  addName "Move window to prev WS"    $ shiftTo Prev nonNSP >> moveTo Prev nonNSP)]

    -- Workspace switching
    ^++^ subKeys "Switch to workspace"
    [ ("M-1", addName "Switch to workspace 1"    $ (windows $ W.greedyView $ myWorkspaces !! 0))
    , ("M-2", addName "Switch to workspace 2"    $ (windows $ W.greedyView $ myWorkspaces !! 1))
    , ("M-3", addName "Switch to workspace 3"    $ (windows $ W.greedyView $ myWorkspaces !! 2))
    , ("M-4", addName "Switch to workspace 4"    $ (windows $ W.greedyView $ myWorkspaces !! 3))
    , ("M-5", addName "Switch to workspace 5"    $ (windows $ W.greedyView $ myWorkspaces !! 4))
    , ("M-6", addName "Switch to workspace 6"    $ (windows $ W.greedyView $ myWorkspaces !! 5))
    , ("M-7", addName "Switch to workspace 7"    $ (windows $ W.greedyView $ myWorkspaces !! 6))]

    -- Send current window to another workspace
    ^++^ subKeys "Send window to workspace"
    [ ("M-S-1", addName "Send to workspace 1"    $ (windows $ W.shift $ myWorkspaces !! 0))
    , ("M-S-2", addName "Send to workspace 2"    $ (windows $ W.shift $ myWorkspaces !! 1))
    , ("M-S-3", addName "Send to workspace 3"    $ (windows $ W.shift $ myWorkspaces !! 2))
    , ("M-S-4", addName "Send to workspace 4"    $ (windows $ W.shift $ myWorkspaces !! 3))
    , ("M-S-5", addName "Send to workspace 5"    $ (windows $ W.shift $ myWorkspaces !! 4))
    , ("M-S-6", addName "Send to workspace 6"    $ (windows $ W.shift $ myWorkspaces !! 5))
    , ("M-S-7", addName "Send to workspace 7"    $ (windows $ W.shift $ myWorkspaces !! 6))
    ]

    -- Appending function for toggling floating windows and named scratchpad
    where  
      toggleFloat w = windows (\s -> if M.member w (W.floating s)
                    then W.sink w s
                    else (W.float w (W.RationalRect (1/20) (1/20) (9/10) (9/10)) s))
      nonNSP          = WSIs (return (\ws -> W.tag ws /= "NSP"))
      nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))
