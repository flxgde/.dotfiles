-- Monitors (see `hyprctl monitors`). DP-1 left, DP-2 right.
hl.monitor({ output = "DP-1", mode = "2560x1440@144", position = "0x0",    scale = "1" })
hl.monitor({ output = "DP-2", mode = "3840x2160@60",  position = "2560x0", scale = "1" })

-- Workspace -> monitor pinning (1-5 on DP-1, 6-10 on DP-2).
hl.workspace_rule({ workspace = "1", monitor = "DP-1", default = true, persistent = true, default_name = "1 Browser" })
hl.workspace_rule({ workspace = "2", monitor = "DP-1", persistent = true, default_name = "2 KI" })
hl.workspace_rule({ workspace = "3", monitor = "DP-1", persistent = true, default_name = "3 Misc" })
hl.workspace_rule({ workspace = "4", monitor = "DP-1", persistent = true, default_name = "4 Misc" })
hl.workspace_rule({ workspace = "5", monitor = "DP-1", persistent = true, default_name = "5 Misc" })
hl.workspace_rule({ workspace = "6", monitor = "DP-2", default = true, persistent = true, default_name = "6 Terminal" })
hl.workspace_rule({ workspace = "7", monitor = "DP-2", persistent = true, default_name = "7 IDE" })
hl.workspace_rule({ workspace = "8", monitor = "DP-2", persistent = true, default_name = "8 Spotify" })
hl.workspace_rule({ workspace = "9", monitor = "DP-2", persistent = true, default_name = "9 Mail" })
hl.workspace_rule({ workspace = "10", monitor = "DP-2", persistent = true, default_name = "10 Misc" })
