-- |
--  xmonad.hs - xmonad configuration file
--  Copyright (C) 2014 Jesse Huard <jhuard@ualberta.ca>
--
--  This program is free software: you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation, either version 3 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program.  If not, see <http://www.gnu.org/licenses/>.


import Graphics.X11.ExtraTypes.XF86
import System.IO
import System.Posix.Env (getEnv)
import Data.Maybe (maybe)

import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Config.Desktop
import XMonad.Config.Gnome
import qualified XMonad.StackSet as W

myManageHook = composeAll
               [ isFullscreen --> (doF W.focusDown <+> doFullFloat)]

main = do
    xmproc <- spawnPipe "/usr/bin/xmobar /home/jesse/.xmobarrc"
    xmonad $ defaultConfig
        { manageHook = manageDocks <+> myManageHook <+> manageHook defaultConfig
        , layoutHook = avoidStruts  $  layoutHook defaultConfig
        , logHook    = dynamicLogWithPP xmobarPP
                           { ppOutput = hPutStrLn xmproc
                           , ppTitle  = xmobarColor "green" "" . shorten 100
                           }
        , modMask    = mod4Mask -- Rebind Mod to Windows Key
        , terminal   = "gnome-terminal"
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
        , ((0, xF86XK_AudioRaiseVolume)  , spawn "pactl set-sink-volume 1 +5%")
        , ((0, xF86XK_AudioLowerVolume)  , spawn "pactl set-sink-volume 1 -- -5%")
        , ((0, xF86XK_AudioMute)         , spawn "pactl set-sink-mute 1 toggle")
        ]

