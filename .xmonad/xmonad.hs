------------------------------------------------------------------------
-- IMPORTS
------------------------------------------------------------------------

-- Base
import XMonad
import System.IO (hClose, hPutStr)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

-- Actions
import XMonad.Actions.CopyWindow (kill1)

-- Data
import Data.Char (toUpper)

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
import XMonad.Layout.Magnifier
import XMonad.Layout.ThreeColumns

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

myManageHook :: ManageHook
myManageHook = composeAll
    [ className =? "Gimp" --> doFloat
    , isDialog            --> doFloat
    ]

------------------------------------------------------------------------
-- LAYOUT
------------------------------------------------------------------------

myLayout = tiled ||| Mirror tiled ||| Full ||| threeCol
  where
    threeCol = magnifiercz' 1.3 $ ThreeColMid nmaster delta ratio
    tiled    = Tall nmaster delta ratio
    nmaster  = 1      -- Default number of windows in the master pane
    ratio    = 1/2    -- Default proportion of screen occupied by master pane
    delta    = 3/100  -- Percent of screen to increment by when resizing panes

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
    -- Basics
    subKeys "Xmonad Essentials"
    [ ("M-r", addName "Recompile XMonad"         $ spawn "xmonad --recompile")
    , ("M-S-r", addName "Restart XMonad"         $ spawn "xmonad --restart")
    , ("M-S-q", addName "Quit XMonad"            $ io exitSuccess)
    , ("M-q", addName "Kill focused window"      $ kill1)
    , ("M-w", addName "Run browser"              $ spawn myBrowser)
    , ("M-<Return>", addName "Run prompt"        $ spawn "st")]

    -- Workspaces
    ^++^ subKeys "Switch to workspace"
    [ ("M-1", addName "Switch to workspace 1"    $ (windows $ W.greedyView $ myWorkspaces !! 0))
    , ("M-2", addName "Switch to workspace 2"    $ (windows $ W.greedyView $ myWorkspaces !! 1))
    , ("M-3", addName "Switch to workspace 3"    $ (windows $ W.greedyView $ myWorkspaces !! 2))
    , ("M-4", addName "Switch to workspace 4"    $ (windows $ W.greedyView $ myWorkspaces !! 3))
    , ("M-5", addName "Switch to workspace 5"    $ (windows $ W.greedyView $ myWorkspaces !! 4))
    , ("M-6", addName "Switch to workspace 6"    $ (windows $ W.greedyView $ myWorkspaces !! 5))
    , ("M-7", addName "Switch to workspace 7"    $ (windows $ W.greedyView $ myWorkspaces !! 6))
    , ("M-8", addName "Switch to workspace 8"    $ (windows $ W.greedyView $ myWorkspaces !! 7))
    , ("M-9", addName "Switch to workspace 9"    $ (windows $ W.greedyView $ myWorkspaces !! 8))]
