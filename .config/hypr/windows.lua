-- Window -> workspace routing.
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
hl.window_rule({ match = { class = "^(brave-browser)$" },       workspace = "1" })
hl.window_rule({ match = { class = "^(chromium)$" },            workspace = "1" })
hl.window_rule({ match = { class = "^(com.mitchellh.ghostty)$" }, workspace = "6" })
hl.window_rule({ match = { class = "^(kitty)$" },               workspace = "6" })
hl.window_rule({ match = { class = "^(jetbrains-idea)$" },      workspace = "7" })
hl.window_rule({ match = { class = "^(spotify)$" },             workspace = "8" })
