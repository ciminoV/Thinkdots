---------------------------
-- Imports
---------------------------

-- Base
import XMonad hiding ( (|||) ) -- jump to layout
import XMonad.Config.Desktop
import System.Exit
import System.IO (hPutStrLn)
import qualified XMonad.StackSet as W

-- Data
import Data.Monoid
import Data.Char (isSpace, toUpper)
import Data.Maybe (isJust, fromJust)
import Data.Tree
import qualified Data.Map as M
import qualified Data.Map.Strict as Map

-- Util
import XMonad.Util.Run (runProcessWithInput, safeSpawn, unsafeSpawn, runInTerm, spawnPipe)
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig (additionalKeysP, removeKeys)
import XMonad.Util.NamedScratchpad
import XMonad.Util.WorkspaceCompare

-- Hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks (avoidStruts, docksStartupHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers (isFullscreen, isDialog,  doFullFloat, doCenterFloat, doRectFloat) 
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.WorkspaceHistory
import XMonad.Hooks.DynamicProperty

-- Actions
import XMonad.Actions.CopyWindow (kill1, killAllOtherCopies, copyToAll)
import XMonad.Actions.WithAll (sinkAll, killAll)
import XMonad.Actions.UpdatePointer
import XMonad.Actions.Promote
import XMonad.Actions.NoBorders
import XMonad.Actions.Submap
import XMonad.Actions.CycleWS
import qualified XMonad.Actions.TreeSelect as TS

-- Layout
import XMonad.Layout.ResizableTile
import XMonad.Layout.LayoutCombinators (JumpToLayout(..), (|||)) -- jump to layout
import XMonad.Layout.Renamed (renamed, Rename(Replace))
import XMonad.Layout.NoBorders
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.WindowNavigation
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))

-- Text
import Text.Printf

-- Prompt
import XMonad.Prompt
import XMonad.Prompt.ConfirmPrompt
import XMonad.Prompt.Input
import XMonad.Prompt.FuzzyMatch
import XMonad.Prompt.Man
import XMonad.Prompt.Shell
import Control.Arrow (first)


---------------------------
-- Variables
---------------------------

myModMask = mod4Mask
myAltMask = mod1Mask
myTerminal = "st"
myBorderWidth = 1
myEditor = myTerminal ++ " -e nvim "
myBrowser = "brave"
myFont = "xft:SauceCodePro Nerd Font Mono:regular:size=9:antialias=true:hinting=true"

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

------------------------------------------------------------------------
-- Theme
------------------------------------------------------------------------

-- Terminal color palette
white    = "#ffffff"
black    = "#101010"
red0     = "#f07178"
red1     = "#ff8b92"
green0   = "#c3e88d"
green1   = "#ddffa7"
yellow0  = "#ffcb6b"
yellow1  = "#ffe585"
blue0    = "#82aaff"
blue1    = "#9cc4ff"
violet0  = "#c792ea"
violet1  = "#e1acff"
azure0   = "#89ddff"
azure1   = "#a3f7ff"
gray0    = "#d0d0d0"
gray1    = "#434758"

-- XMonad colors
basebg  = "#2e3440"
basefg  = "#bbc2cf"
basebc  = "#535974"
basebgHL  = azure0
basefgHL  = black

myNormalBorderColor  = basebg
myFocusedBorderColor = basebgHL
myppCurrent = green1
myppVisible = green1
myppHidden = yellow1
myppHiddenNoWindows = blue1
myppTitle = white
myppUrgent = red0

-- XPrompts theme
myPromptTheme = def
    { font                  = myFont
    , bgColor               = basebg
    , fgColor               = basefg
    , fgHLight              = basefgHL
    , bgHLight              = basebgHL
    , borderColor           = basebgHL
    , promptBorderWidth     = 0
    , height                = 23
    , position              = Top
    }

-- ConfirmPrompts theme
hotPromptTheme = myPromptTheme
    { bgColor               = violet0
    , fgColor               = white
    , position              = Top
    }

------------------------------------------------------------------------
-- Clickable Workspaces
------------------------------------------------------------------------

xmobarEscape :: String -> String
xmobarEscape = concatMap doubleLts
  where
        doubleLts '<' = "<<"
        doubleLts x   = [x]

myWorkspaces :: [String]
myWorkspaces = clickable . (map xmobarEscape)
               -- $ [" 0 ", " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "]
               $ [" dev ", " www ", " doc ", " fm ", " mlab ", " teams "]
  where
        clickable l = [ "<action=xdotool key super+" ++ show (n) ++ ">" ++ ws ++ "</action>" |
                      (i,ws) <- zip [1..6] l,
                      let n = i ]


------------------------------------------------------------------------
-- Treeselect
------------------------------------------------------------------------

treeselectAction :: TS.TSConfig (X ()) -> X ()
treeselectAction a = TS.treeselectAction a
  -- Power settings
   [Node (TS.TSNode "Power"    "Power options" (return())) 
      [ Node (TS.TSNode "Shutdown" "Poweroff the system" (spawn "systemctl poweroff")) []
      , Node (TS.TSNode "Reboot" "Reboot the system" (spawn "systemctl reboot")) []
--      , Node (TS.TSNode "Hibernate" "Hibernate the system" (spawn "systemctl hibernate")) []
      , Node (TS.TSNode "Suspend" "Suspend the system" (spawn "systemctl suspend && slock")) []
      ]

  -- Brightness settings
   , Node (TS.TSNode "Brightness" "Screen brightness adjustment" (return ()))
       [ Node (TS.TSNode "Bright" "100%" (spawn "sudo xbacklight -set 100")) []
       , Node (TS.TSNode "Normal" "50%" (spawn "sudo xbacklight -set 50"))  []
       , Node (TS.TSNode "Dim" "10%" (spawn "sudo xbacklight -set 10"))  []
       ]

  -- XMonad settings
   , Node (TS.TSNode "XMonad" "XMonad recompile & restart" (return ()))
       [ Node (TS.TSNode "Restart" "Restarts XMonad" (spawn "xmonad --restart")) []
       , Node (TS.TSNode "Recompile" "Recompiles XMonad" (spawn "xmonad --recompile"))  []
       ]
  -- Config files
   , Node (TS.TSNode "Config files" "Oftenly edited config files" (return ()))
       [ Node (TS.TSNode "XMonad" "xmonad.hs" (spawn (myEditor ++ "$HOME/.xmonad/xmonad.hs"))) []
       , Node (TS.TSNode "Zsh" ".zshrc" (spawn (myEditor ++ "$HOME/.zshrc")))  []
       , Node (TS.TSNode "Xinit" ".xinitrc" (spawn (myEditor ++ "$HOME/.xinitrc")))  []
       , Node (TS.TSNode "Xmobar" "xmobarrc" (spawn (myEditor ++ "$HOME/.config/xmobar/xmobarrc")))  []
       , Node (TS.TSNode "Nvim" "init.vim" (spawn (myEditor ++ "$HOME/.config/nvim/init.vim")))  []
       , Node (TS.TSNode "St" "config.h" (spawn (myEditor ++ "$HOME/.config/st/config.h")))  []
       , Node (TS.TSNode "Vifm" "vifmrc" (spawn (myEditor ++ "$HOME/.config/vifm/vifmrc")))  []
       , Node (TS.TSNode "Sxiv" "key-handler" (spawn (myEditor ++ "$HOME/.config/sxiv/exec/key-handler")))  []
       , Node (TS.TSNode "Zathura" "zathurarc" (spawn (myEditor ++ "$HOME/.config/zathura/zathurarc")))  []
       , Node (TS.TSNode "Slock" "config.def.h" (spawn (myEditor ++ "$HOME/.config/slock/config.def.h")))  []
       , Node (TS.TSNode "Dunst" "dunstrc" (spawn (myEditor ++ "$HOME/.config/dunst/dunstrc")))  []
       ]
   ]

-- TreeSelect configuration
tsDefaultConfig :: TS.TSConfig a
tsDefaultConfig = TS.TSConfig { TS.ts_hidechildren = True
                              , TS.ts_background   = 0xdd2e3440
                              , TS.ts_font         = myFont
                              , TS.ts_node         = (0xffd0d0d0, 0xff1c1f24)
                              , TS.ts_nodealt      = (0xffd0d0d0, 0xff282c34)
                              , TS.ts_highlight    = (0xffffffff, 0xffc792ea)
                              , TS.ts_extra        = 0xffd0d0d0
                              , TS.ts_node_width   = 200
                              , TS.ts_node_height  = 20
                              , TS.ts_originX      = 0
                              , TS.ts_originY      = 0
                              , TS.ts_indent       = 80
                              , TS.ts_navigate     = myTreeNavigation
                              }
-- TreeSelect keymap
myTreeNavigation = M.fromList
    [ ((0, xK_Escape),   TS.cancel)
    , ((0, xK_Return),   TS.select)
    , ((0, xK_space),    TS.select)
    , ((0, xK_Up),       TS.movePrev)
    , ((0, xK_Down),     TS.moveNext)
    , ((0, xK_Left),     TS.moveParent)
    , ((0, xK_Right),    TS.moveChild)
    , ((0, xK_k),        TS.movePrev)
    , ((0, xK_j),        TS.moveNext)
    , ((0, xK_h),        TS.moveParent)
    , ((0, xK_l),        TS.moveChild)
    ]

------------------------------------------------------------------------
-- XPrompt
------------------------------------------------------------------------

-- XPrompt configuration
myXPConfig :: XPConfig
myXPConfig = myPromptTheme
      { promptKeymap        = myXPKeymap
      , historySize         = 256
      , historyFilter       = id
      , defaultText         = []
      , autoComplete        = Nothing       -- set Just 100000 for .1 sec
      , showCompletionOnTab = False
      , searchPredicate     = fuzzyMatch
      , defaultPrompter     = id
      , alwaysHighlight     = True
      , maxComplRows        = Just 5        -- set to Nothing for whole screen
      }

-- Calculator prompt
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
        Just s  -> spawn $ printf "sleep 0.3 && scrot --select '%s' -e 'mv $f ~/Pictures' && notify-send 'Saving %s in' 'Pictures...'" s s
        Nothing -> pure ()


-- XPrompt keymap
myXPKeymap :: M.Map (KeyMask,KeySym) (XP ())
myXPKeymap = M.fromList $
     map (first $ (,) controlMask)      -- control + <key>
     [ (xK_j, killBefore)               -- kill line backwards
     , (xK_k, killAfter)                -- kill line forwards
     ]
     ++
     map (first $ (,) myAltMask)        -- alt + <key>
     [ (xK_BackSpace, killWord Prev)    -- kill the prev word
     , (xK_d, killWord Next)            -- kill the next word
     , (xK_w, moveWord Next)            -- move a word forward
     , (xK_b, moveWord Prev)            -- move a word backward
     , (xK_x, deleteString Next)        -- delete a character foward
     , (xK_h, moveCursor Prev)          -- move cursor forward
     , (xK_l, moveCursor Next)          -- move cursor backward
     , (xK_v, pasteString)              -- paste a string
     , (xK_e, endOfLine)                -- move to the end of the line
     , (xK_0, startOfLine)              -- move to the beginning of the line
     ]
     ++
     map (first $ (,) 0) -- <key>
     [ (xK_Return, setSuccess True >> setDone True)
     , (xK_KP_Enter, setSuccess True >> setDone True)
     , (xK_BackSpace, deleteString Prev)
     , (xK_Delete, deleteString Next)
     , (xK_Left, moveCursor Prev)
     , (xK_Right, moveCursor Next)
     , (xK_Down, moveHistory W.focusUp')
     , (xK_Up, moveHistory W.focusDown')
     , (xK_Escape, quit)
     ]

------------------------------------------------------------------------
-- Named Scratchpads
------------------------------------------------------------------------

myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                , NS "vifm" spawnVifm findVifm manageVifm
                , NS "spotify" spawnSpotify findSpotify manageSpotify
                ]
  where
    spawnTerm  = myTerminal ++ " -t st-scratchpad"
    findTerm   = title =? "st-scratchpad"
    manageTerm = customFloating $ W.RationalRect (0.1)(0.1)(0.8)(0.8)

    spawnVifm  = myTerminal ++ " -t vifm-scratchpad -e ~/.config/vifm/scripts/vifmrun"
    findVifm   = title =? "vifm-scratchpad"
    manageVifm = customFloating $ W.RationalRect (0.1)(0.1)(0.8)(0.8)

    spawnSpotify  = "spotify"
    findSpotify   = className =? "Spotify"
    manageSpotify = customFloating $ W.RationalRect (0.1)(0.1)(0.8)(0.8)

------------------------------------------------------------------------
-- Key bindings
------------------------------------------------------------------------

-- Hidden and non-empty workspaces less scratchpad
nextNonEmptyWS = findWorkspace getSortByIndexNoSP Next HiddenNonEmptyWS 1
        >>= \t -> (windows . W.view $ t)
prevNonEmptyWS = findWorkspace getSortByIndexNoSP Prev HiddenNonEmptyWS 1
        >>= \t -> (windows . W.view $ t)
getSortByIndexNoSP =
        fmap (.namedScratchpadFilterOutWorkspace) getSortByIndex

myKeys = 
    -- XMonad
    [
        (  "M-r", restartXmonad)                                                -- Restart xmonad
        , ("M-S-r", rebuildXmonad)                                              -- Rebuild and restart xmonad
        , ("M-S-q", confirmPrompt hotPromptTheme "Quit XMonad" $ quitXmonad)    -- Exit xmonad

    -- Kill windows
        , ("M-q", kill1)                                                        -- Kill currently focused window
        , ("M-S-a", confirmPrompt hotPromptTheme "kill all" $ killAll)          -- Kill all windows on current ws

    -- Floating windows
        , ("M-S-<Space>", withFocused toggleFloat)                              -- Toggle floating window
        , ("M-C-v", spawn (myTerminal ++ " pulsemixer"))                        -- pulsemixer (onclick volicon)
        , ("M-C-h", spawn (myTerminal ++ " htop"))                              -- htop (onclick battery)
        , ("M-C-c", spawn "$HOME/.local/bin/xm-cal")                            -- xm-cal (onclick datetime)

    -- Increase/decrease spacing
        , ("M-z", sendMessage MirrorShrink)                                     -- Decrease vertical window space
        , ("M-a", sendMessage MirrorExpand)                                     -- Increase vertical window space
        , ("M-d", decWindowSpacing 4)                                           -- Decrease window spacing
        , ("M-i", incWindowSpacing 4)                                           -- Increase window spacing
        , ("M-S-d", decScreenSpacing 4)                                         -- Decrease screen spacing
        , ("M-S-i", incScreenSpacing 4)                                         -- Increase screen spacing

    -- Windows navigation
        , ("M-m", windows W.focusMaster)                                        -- Move focus to the master window
        , ("M-j", windows W.focusDown)                                          -- Move focus to the next window
        , ("M-k", windows W.focusUp)                                            -- Move focus to the prev window
        , ("M-S-m", windows W.swapMaster)                                       -- Swap focused and master window
        , ("M-S-j", windows W.swapDown)                                         -- Swap focused window with next window
        , ("M-S-k", windows W.swapUp)                                           -- Swap focused window with prev window
        , ("S-C-a", windows copyToAll)                                          -- Copy window to all ws
        , ("S-C-z", killAllOtherCopies)                                         -- Kill copies of window on other ws

    -- Layouts
        , ("M-<Tab>", sendMessage NextLayout)                                   -- Switch to next layout
        , ("M-S-n", sendMessage $ MT.Toggle NOBORDERS)                          -- Toggles noborder
        , ("M-f", sequence_ [ sendMessage $ JumpToLayout "Full"                 -- Toggles Full Layout 
                            , sendMessage ToggleStruts ])                       
        , ("M-t", sequence_ [ sendMessage $ JumpToLayout "Tall"                 -- Toggles Tall Layout
                            , sendMessage ToggleStruts ])

    -- Workspaces
        , ("M-<Right>" , nextNonEmptyWS)                                        -- Switch to next non empty ws
        , ("M-<Left>" ,  prevNonEmptyWS)                                        -- Switch to previous non empty ws
        , ("M-S-<Right>" , shiftToNext)                                         -- Shift current window to next ws
        , ("M-S-<Left>" , shiftToPrev)                                          -- Shift current windows to prev ws 
    
    -- Screens
        , ("M-.", nextScreen)                                                   -- Switch focus to next screen
        , ("M-,", prevScreen)                                                   -- Switch focus to prev screen

    -- Function keys
        , ("<F1>", spawn "pamixer -t & $HOME/.local/bin/volumelevel")           -- Mute audio
        , ("<F2>", spawn "pamixer -u -d 5 & $HOME/.local/bin/volumelevel")      -- Decrease audio level
        , ("<F3>", spawn "pamixer -u -i 5 & $HOME/.local/bin/volumelevel")      -- Increase audio level
        , ("<F10>", spawn "$HOME/.local/bin/displayselect")                     -- Select display if any
        , ("<F11>", spawn "sudo xbacklight -dec 5")                             -- Decrease light level 
        , ("<F12>", spawn "sudo xbacklight -inc 5")                             -- Increase light level

    -- Applications and scripts
        , ("M-x", spawn "$HOME/.local/bin/datetime")                            -- Time and date notification
        , ("M-n", spawn "$HOME/.local/bin/anotes")                              -- Android notes script
        , ("M-w", spawn myBrowser)                                              -- Librewolf
        , ("M-<Return>", spawn myTerminal)                                      -- St
        , ("M-<Backspace>", spawn (myTerminal ++ " -t vifm -e ~/.config/vifm/scripts/vifmrun")) -- Vifm

    -- Lockscreen
        , ("C-M1-l", spawn "slock")                                             -- Lock screen with slock

    -- Playerctl
        , ("M-<Space>", spawn ("$HOME/.local/bin/mediatoggle " ++ myBrowser))   -- Toggle play/pause youtube
        , ("M-s s", spawn "$HOME/.local/bin/mediatoggle spotify")               -- Toggle play/pause spotify
        , ("M-s n", spawn "playerctl --player=spotify next")                    -- Skip to next song 
        , ("M-s b", spawn "playerctl --player=spotify previous")                -- Skip to previous song

    -- Prompts
        , ("M-p p", shellPrompt myXPConfig)                                     -- XMonad shell prompt
        , ("M-p m", manPrompt myXPConfig)                                       -- Manual page prompt
        , ("M-p c", calcPrompt myXPConfig "qalc")                               -- Calculator prompt 

    -- Scrot
        , ("M-<Print>", scrotPrompt "home")                                     -- Screen selected area/window
        , ("<Print>", spawn "scrot -e 'mv $f ~/Pictures' && notify-send 'Saving screenshot in' 'Pictures...'") -- Screen whole display

    -- Scratchpads
        , ("M-S-<Return>", namedScratchpadAction myScratchPads "terminal")      -- St scratchpad
        , ("M-S-<Backspace>", namedScratchpadAction myScratchPads "vifm")       -- Vifm scratchpad
        , ("M-S-s", namedScratchpadAction myScratchPads "spotify")              -- Spotify scratchpad

    -- Tree Select
        , ("M-<Esc>", treeselectAction tsDefaultConfig)
    ]
    -- Appending function for toggling floating windows
    where
            toggleFloat w = windows (\s -> if M.member w (W.floating s)
                            then W.sink w s
                            else (W.float w (W.RationalRect (1/20) (1/20) (9/10) (9/10)) s))
            nonNSP = WSIs (return (\ws -> W.tag ws /= "NSP"))                 
            nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))

------------------------------------------------------------------------
-- Layouts:
------------------------------------------------------------------------

-- Spacing between windows
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Tiled
tiled = renamed [Replace "Tall"] 
        $ windowNavigation
        $ limitWindows 12
        $ mySpacing 4
        $ ResizableTall 1 (3/100) (1/2) []

-- Mirror tiled 
mirrorTiled = renamed [Replace "mirrorTall"]
           $ windowNavigation
           $ limitWindows 12
           $ mySpacing 4
           $ Mirror
           $ ResizableTall 1 (3/100) (1/2) []

-- Full
full = renamed [Replace "Full"]  
       $ noBorders (Full)

-- Layout configuration
myLayout = id
    . avoidStruts
    . smartBorders
    . mkToggle (NOBORDERS ?? NBFULL ?? EOT)
    $ tiled ||| mirrorTiled ||| full

------------------------------------------------------------------------
-- Hooks:
------------------------------------------------------------------------

-- Windows hook
myManageHook = composeAll
    [ className =? "Firefox" <&&> resource =? "Toolkit" --> doFloat                       -- firefox pip

    -- send them to specific ws
    , className =? "LibreWolf"                          --> doShift ( myWorkspaces !! 1 ) -- Open librewolf on www ws
    , className =? "MATLAB R2021a - academic use"       --> doShift ( myWorkspaces !! 4 ) -- Open matlab on mlb ws
    , className =? "Microsoft Teams - Preview"          --> doShift ( myWorkspaces !! 5 ) -- Open teams on teams ws

    , title =? "pulsemixer"                             --> doCenterFloat                 -- Open pamixer floating
    , title =? "myCal"                                  --> doCenterFloat                 -- Open xm-cal floating
    , title =? "htop"                                   --> doCenterFloat                 -- Open htop floating

    , resource  =? "desktop_window"                     --> doIgnore
    , resource  =? "kdesktop"                           --> doIgnore 

    , isFullscreen                                      --> doFullFloat
    ]<+> namedScratchpadManageHook myScratchPads

-- Spotify Hook
mySpotifyHook = composeAll
    [ dynamicPropertyChange "WM_NAME" (className =? "Spotify" --> floating)
    ]
    where 
        floating = customFloating $ W.RationalRect (0.1)(0.1)(0.8)(0.8)

-- Startup hook
myStartupHook :: X ()
myStartupHook = do
          spawnOnce "nitrogen --restore &"
          spawnOnce "picom &"
          spawnOnce "dunst &"
          spawnOnce "nm-applet &"
          spawnOnce "redshift-gtk &"
          spawnOnce "trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --monitor 0 --transparent true --alpha 0 --tint 0x2e3440  --height 22 &"

------------------------------------------------------------------------
-- XMonad functions: 
------------------------------------------------------------------------

-- Quit XMonad
quitXmonad :: X ()
quitXmonad = io (exitWith ExitSuccess)

-- Recompile and restart XMonad
rebuildXmonad :: X ()
rebuildXmonad = do
    spawn "xmonad --recompile && xmonad --restart"

-- Restart Xmonad
restartXmonad :: X ()
restartXmonad = do
    spawn "xmonad --restart"

------------------------------------------------------------------------
-- Main:
------------------------------------------------------------------------

main :: IO ()
main = do
    xmproc0 <- spawnPipe "xmobar -x 0 $HOME/.config/xmobar/xmobarrc"
    xmproc1 <- spawnPipe "xmobar -x 1 $HOME/.config/xmobar/xmobarrc"
    xmonad $ ewmh desktopConfig 
        { manageHook = ( isFullscreen --> doFullFloat ) <+> manageDocks <+> myManageHook <+> manageHook desktopConfig,
        handleEventHook    = mySpotifyHook <+> handleEventHook desktopConfig,
        startupHook        = myStartupHook,
        layoutHook         = myLayout,
        workspaces         = myWorkspaces,
        borderWidth        = myBorderWidth,
        terminal           = myTerminal,
        modMask            = myModMask,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,
        logHook = dynamicLogWithPP xmobarPP  
                        { ppOutput = \x -> hPutStrLn xmproc0 x
                                        >> hPutStrLn xmproc1 x
                        , ppCurrent = xmobarColor myppCurrent "" . wrap "[" "]"     -- Current ws in xmobar
                        , ppVisible = xmobarColor myppVisible ""                    -- Visible but not current ws
                        , ppHidden = xmobarColor myppHidden "" . wrap "*" ""        -- Hidden ws in xmobar
                        , ppHiddenNoWindows = xmobarColor  myppHiddenNoWindows ""   -- Hidden ws (no windows)
                        , ppTitle = xmobarColor  myppTitle "" . shorten 60          -- Title of active window in xmobar
                        , ppSep =  "<fc=#666666> | </fc>"                           -- Separators in xmobar
                        , ppUrgent = xmobarColor  myppUrgent "" . wrap "!" "!"      -- Urgent workspace
                        , ppExtras  = [windowCount]                                 -- # of windows current workspace
                        , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                        }
        }`additionalKeysP` myKeys
         `removeKeys` [(mod4Mask .|. shiftMask, xK_c)]
