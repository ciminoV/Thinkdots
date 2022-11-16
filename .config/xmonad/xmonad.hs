------------------------------------------------------------------------
-- IMPORTS
------------------------------------------------------------------------

-- Base
import System.IO (hClose, hPutStr)
import System.Exit (exitSuccess)
import XMonad hiding ( (|||) )
import qualified XMonad.StackSet as W

-- Data
import qualified Data.Map as M
import Data.Char (toUpper, isSpace)
import Data.Maybe (isJust, fromMaybe)

-- Actions
import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.CycleWS
import XMonad.Actions.WithAll (sinkAll, killAll)
import XMonad.Actions.Submap
import XMonad.Actions.Commands (defaultCommands)

-- Hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicProperty
import XMonad.Hooks.ScreenCorners

-- Util
import XMonad.Util.EZConfig
import XMonad.Util.NamedActions
import XMonad.Util.Loggers
import XMonad.Util.ClickableWorkspaces
import XMonad.Util.Ungrab
import XMonad.Util.Run (spawnPipe, runProcessWithInput)
import XMonad.Util.NamedScratchpad

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

-- Prompt
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.XMonad
import XMonad.Prompt.Window
import XMonad.Prompt.ConfirmPrompt
import XMonad.Prompt.FuzzyMatch
import XMonad.Prompt.Input
import XMonad.Prompt.Pass

-- Text
import Text.Printf

-- Headers
import Headers.XMHeaders

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
    { modMask            = mod4Mask
    , layoutHook         = myLayout
    , manageHook         = myManageHook
    , handleEventHook    = mySpotifyHook <+> screenCornerEventHook
    , startupHook        = myStartupHook
    , workspaces         = myWorkspaces
    , terminal           = myTerminal
    , borderWidth        = myBorderWidth
    , normalBorderColor  = myNormColor
    , focusedBorderColor = myFocusColor
    }

------------------------------------------------------------------------
-- XMOBAR
------------------------------------------------------------------------

-- XMonad configuration of xmobar
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
    lTitle = shortenL 60 (logTitle .| logConst " ")

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
    , title =? "htop"                              --> doFloat                       -- Open htop floating
    , title =? "myCal"                             --> doCenterFloat                 -- Open calendar floating center
    , title =? "pulsemixer"                        --> doCenterFloat                 -- Open pulsemixer floating center
    , title =? "nmtui"                             --> doCenterFloat                 -- Open nmtui floating center
    , title =? "XMonad keybindings"                --> doCenterFloat                 -- Open xmonad keybindings floating center
    , isDialog                                     --> doFloat
    ]<+> namedScratchpadManageHook myScratchPads

-- Spotify Hook
mySpotifyHook = composeAll [ dynamicPropertyChange "WM_NAME" (className =? "Spotify" --> doCenterFloat) ]

-- Startup Hoook
myStartupHook :: X ()
myStartupHook = do
    addScreenCorner SCLowerLeft sysCtlPrompt    -- Add event to lowerleft screen corner
--    addScreenCorner SCLowerRight emptyWS        -- Add event to lowerright screen corner
--  where
--    emptyWS = (windows $ W.greedyView $ last $ myWorkspaces)

------------------------------------------------------------------------
-- SCRATCHPADS
------------------------------------------------------------------------

myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                , NS "spotify" spawnSpotify findSpotify manageSpotify
                , NS "note" spawnNote findNote manageNote ]
  where
    -- Terminal scratchpad
    spawnTerm  = myTerminal ++ " -t st-scratchpad"
    findTerm   = title =? "st-scratchpad"
    manageTerm = customFloating $ W.RationalRect (0.1)(0.1)(0.8)(0.8)

    -- Spotify scratchpad
    spawnSpotify  = "spotify"
    findSpotify   = className =? "Spotify"
    manageSpotify = customFloating $ W.RationalRect (0.1)(0.1)(0.8)(0.8)

    -- Custom note scratchpad
    spawnNote  = myTerminal ++ " -t myNote -e nvim ~/documents/note-$(date '+%Y-%m-%d').md"
    findNote   = title =? "myNote"
    manageNote = customFloating $ W.RationalRect (0.1)(0.1)(0.8)(0.8)

------------------------------------------------------------------------
-- LAYOUT
------------------------------------------------------------------------

-- Modified layouts which support screen corner events
myLayout = screenCornerLayoutHook $ tiled ||| Mirror tiled ||| full ||| threeCol
  where
    threeCol = renamed [Replace "ThreeCol"]
        $ magnifiercz' 1.3 
        $ limitWindows 5
        $ smartBorders
        $ spacingRaw False (Border 0 4 4 4) True (Border 4 4 4 4) True
        $ ThreeColMid 1 (3/100) (1/2)
    tiled    = renamed [Replace "Tall"]
        $ limitWindows 5
        $ smartBorders
        $ spacingRaw False (Border 0 4 4 4) True (Border 4 4 4 4) True
        $ ResizableTall 1 (3/100) (1/2) []
    full     = renamed [Replace "Full"]  
       $ noBorders Full

------------------------------------------------------------------------
-- XPROMPTS
------------------------------------------------------------------------

-- Power prompt
sysCtlPrompt :: X ()
sysCtlPrompt = xmonadPromptCT "See you soon" commands myXPConfig
  where
    commands = [ ("1: Sleep"       , spawn "systemctl suspend -i")
               , ("2: Shutdown"    , spawn "systemctl poweroff -i")
               , ("3: Reboot"      , spawn "systemctl reboot -i")]

-- Calculator prompt
calcPrompt :: XPConfig -> String -> X ()
calcPrompt c ans =
    inputPrompt c (trim ans) ?+ \input ->
        liftIO(runProcessWithInput "qalc" [input] "") >>= calcPrompt c
    where
        trim  = f . f
            where f = reverse . dropWhile isSpace

-- Scrot prompt
scrotPrompt :: String -> X ()
scrotPrompt home = do
    str <- inputPrompt myXPConfig "Rectangular/Window snip"
    case str of
        Just s  -> spawn $ printf "sleep 0.3 && scrot --select '%s' -e 'mv $f ~/pictures' && notify-send 'Saving %s in' 'Pictures...'" s s
        Nothing -> pure ()

-- XPrompt configuration
myXPConfig :: XPConfig
myXPConfig = myPromptTheme
      { promptKeymap        = defaultXPKeymap
      , historySize         = 256
      , historyFilter       = id
      , defaultText         = []
      , autoComplete        = Nothing       -- set Just 100000 for .1 sec
      , showCompletionOnTab = False
      , searchPredicate     = fuzzyMatch
      , sorter              = fuzzySort
      , defaultPrompter     = id
      , alwaysHighlight     = True
      , maxComplRows        = Just 5        -- set to Nothing for whole screen
      }

-- XPrompts theme
myPromptTheme = def
    { font                  = myFont
    , bgColor               = colorBack
    , fgColor               = colorFore
    , fgHLight              = black
    , bgHLight              = azure0
    , borderColor           = azure0
    , promptBorderWidth     = 0
    , height                = 24
    , position              = Top
    }

-- ConfirmPrompts theme
hotPromptTheme = myPromptTheme
    { bgColor               = violet0
    , fgColor               = white
    , position              = Top
    }

------------------------------------------------------------------------
-- KEYBINDINGS
------------------------------------------------------------------------

-- Subtitle format
subtitle' ::  String -> ((KeyMask, KeySym), NamedAction)
subtitle' x = ((0,0), NamedAction $ map toUpper $ sep ++ "\n-- " ++ x ++ " --\n" ++ sep)
  where
    sep = replicate (6 + length x) '-'

-- Pipe the Named Actions output to yad
showKeybindings :: [((KeyMask, KeySym), NamedAction)] -> NamedAction
showKeybindings x = addName "Show Keybindings" $ io $ do
  h <- spawnPipe $ "yad --text-info --fontname=\"Hack\" --fore=" ++ colorFore ++ " --back=" ++ colorBack ++ " --no-buttons --center --geometry=1200x1000 --title \"XMonad keybindings\""
  hPutStr h (unlines $ showKmSimple x) -- showKmSimple doesn't add ">>" to subtitles
  hClose h
  return ()

-- My keybindings
myKeys :: XConfig l0 -> [((KeyMask, KeySym), NamedAction)]
myKeys c =
    let subKeys str ks = subtitle' str : mkNamedKeymap c ks in
    -- XMonad
    subKeys "Xmonad Essentials"
    [ ("M-r",       addName "Recompile XMonad"       $ spawn "xmonad --recompile")
    , ("M-S-r",     addName "Restart XMonad"         $ spawn "xmonad --restart")
    , ("M-S-q",     addName "Quit XMonad"            $ confirmPrompt hotPromptTheme "Quit XMonad" $ (io exitSuccess))
    , ("M-q",       addName "Kill focused window"    $ kill1)
    , ("M-S-a",     addName "Kill all windows"       $ confirmPrompt hotPromptTheme "kill all" $ killAll)
    , ("M-S-l",     addName "Lock screen"            $ spawn "slock")]

    -- Main programs
    ^++^ subKeys "Run programs"
    [ ("M-<Return>",    addName "Run terminal"               $ spawn myTerminal)
    , ("M-S-<Return>",  addName "Run terminal scratchpad"    $ namedScratchpadAction myScratchPads "terminal")
    , ("M-w",           addName "Run browser"                $ spawn myBrowser)
    , ("M-e",           addName "Run nvim"                   $ spawn (myTerminal ++ " -e nvim ~"))
    , ("M-S-e",         addName "Run nvim note"              $ namedScratchpadAction myScratchPads "note")
    , ("M-<Backspace>", addName "Run Vifm"                   $ spawn myFileManager)]

    -- Prompts
    ^++^ subKeys "XPrompts and dmenu"
    [ ("M-p",        addName "Run shell prompt"            $ shellPrompt myXPConfig)
    , ("M-S-g",      addName "Bring selected window"       $ windowPrompt myXPConfig Bring allWindows)
    , ("M-g",        addName "Switch to selected window"   $ windowPrompt myXPConfig Goto allWindows)
    , ("M-c",        addName "Run qalc prompt"             $ calcPrompt myXPConfig "qalc")
    , ("M-<Esc>",    addName "Run power prompt"            $ sysCtlPrompt)
    , ("M-S-p",      addName "Run passmenu"                $ passPrompt myXPConfig)
    , ("M-d m",      addName "Run dmenu mount prompt"      $ spawn "dmount")
    , ("M-d u",      addName "Run dmenu unmount prompt"    $ spawn "dumount")
    , ("M-S-n",      addName "Run dmenu unibooks prompt"   $ spawn "unibooks")
    , ("M-n",        addName "Run dmenu uninotes prompt"   $ spawn "uninotes")]

    -- Layouts settings
    ^++^ subKeys "Change layouts"
    [ ("M-<Tab>",   addName "Switch Layout"          $ sendMessage NextLayout )
    , ("<F1>",      addName "Toggle float window"    $ withFocused toggleFloat)
    , ("M-f",       addName "Toggle full layout"     $ sendMessage $ JumpToLayout "Full")
    , ("M-t",       addName "Toggle tall layout"     $ sendMessage $ JumpToLayout "Tall")]

    -- Multimedia keys
    ^++^ subKeys "Multimedia keys"
    [ ("<XF86AudioMute>",         addName "Toggle audio mute"         $ spawn "pamixer -t && volumelevel")                                          -- F1
    , ("<XF86AudioLowerVolume>",  addName "Lower volume"              $ spawn "pamixer -u -d 5 && volumelevel")                                     -- F2
    , ("<XF86AudioRaiseVolume>",  addName "Raise volume"              $ spawn "pamixer -u -i 5 && volumelevel")                                     -- F3
    , ("<XF86AudioMicMute>",      addName "Toggle mic mute"           $ spawn "pamixer --source \"alsa_input.pci-0000_00_1f.3.analog-stereo\" -t")  -- F4
    , ("<XF86MonBrightnessDown>", addName "Decrease light"            $ spawn "sudo xbacklight -dec 5 && lightlevel")                               -- F5
    , ("<XF86MonBrightnessUp>",   addName "Increase light"            $ spawn "sudo xbacklight -inc 5 && lightlevel")                               -- F6
    , ("<XF86Display>",           addName "Select display"            $ spawn "displayselect")                                                      -- F7
    , ("<XF86Favorites>",         addName "Run spotify scratchpad"    $ namedScratchpadAction myScratchPads "spotify")                              -- F12
    , ("M-<Print>",               addName "Screen selected window"    $ scrotPrompt "home")
    , ("<Print>",                 addName "Take screenshot"           $ spawn "scrot -e 'mv $f ~/pictures' && notify-send 'Saving screenshot in' 'Pictures...'")]

    -- Controls for multimedia
    ^++^ subKeys "Spotify"
    [ ("M-s s",         addName "Toggle play/pause"            $ spawn "mediatoggle spotify")
    , ("M-s n",         addName "Skip to next song"            $ spawn "playerctl --player=spotify next")
    , ("M-s b",         addName "Skip to prev song"            $ spawn "playerctl --player=spotify previous")
    , ("M-<Space>",     addName "Toggle play/pause browser"    $ spawn ("mediatoggle " ++ myBrowser))]

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
