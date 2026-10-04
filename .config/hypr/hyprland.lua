-- Personal Hyprland config on top of the CachyOS Hyprland edition.
-- CachyOS ships its modules in ~/.config/hypr/config/ (not managed here);
-- this file loads them, overrides the variables they read, then applies the
-- personal modules from this repo (monitors, input, bindings, windows).
-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

require("config.animations")
require("config.colors")
require("config.decorations")
require("config.variables")

-- Override CachyOS defaults (read by config.binds etc., so set before loading them).
TERMINAL = "ghostty"
BROWSER  = "brave"
MONITOR1 = "DP-1"
MONITOR2 = "DP-2"
PRIMARY_MONITOR = MONITOR1

-- Per-machine terminal choice, written by provisioning/terminal.yml
-- (-e terminal=kitty|ghostty). Optional: falls back to ghostty above.
pcall(require, "terminal")

require("config.autostart") -- starts the noctalia shell
require("config.environment")
require("config.inputs")
require("config.binds")
require("config.misc")
require("config.windowrules") -- CachyOS gaming/PiP rules

-- Personal overrides, loaded after the CachyOS defaults.
require("monitors") -- also defines workspace -> monitor pinning
require("input")
require("bindings")
require("windows")
