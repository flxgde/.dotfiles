-- Personal keybinding overrides on top of CachyOS's config/binds.lua.
-- Unbind a default before rebinding its key.
local mainMod = "SUPER"
local noctCall = "noctalia msg "

-- Same physical-keycode trick as CachyOS (layout-independent number row).
local function digitCode(d)
  return "code:" .. (d == 0 and 19 or (9 + d))
end

-- Unbind CachyOS defaults that clash with vim-style nav / workspace keys.
-- (Super+W stays CachyOS's default: opens the browser. Super+Q still closes.)
hl.unbind(mainMod .. " + J")  -- togglesplit
hl.unbind(mainMod .. " + L")  -- lock
for i = 1, 3 do
  hl.unbind(mainMod .. " + " .. digitCode(i))            -- focus monitor
  hl.unbind(mainMod .. " + SHIFT + " .. digitCode(i))    -- move window to monitor
end

-- Drop CachyOS's per-monitor relative-workspace binds (NUM_WPM, "m~N"
-- addressing) too: they conflict with the absolute 10-slot pinned
-- workspace model this repo uses (see monitors.lua).
for i = 1, NUM_WPM do
  hl.unbind(mainMod .. " + ALT + " .. digitCode(i))               -- focus relative workspace
  hl.unbind(mainMod .. " + CONTROL + " .. digitCode(i))           -- focus relative workspace
  hl.unbind(mainMod .. " + SHIFT + CONTROL + " .. digitCode(i))   -- move to relative workspace
  hl.unbind(mainMod .. " + SHIFT + ALT + " .. digitCode(i))       -- move to relative workspace (no follow)
end

-- Vim-style window focus.
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))

-- Re-home the actions displaced by vim nav.
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd(noctCall .. "session lock"))

-- Workspaces: Super+1-9,0 switch, Super+Shift+1-9,0 move window.
for i = 1, 10 do
  local key = i % 10
  hl.bind(mainMod .. " + " .. digitCode(key), hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. digitCode(key), hl.dsp.window.move({ workspace = i }))
end
