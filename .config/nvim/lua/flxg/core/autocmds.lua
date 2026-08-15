local checktime_group = vim.api.nvim_create_augroup("flxg_checktime", { clear = true })

-- Polling fallback: catches changes on filesystems where inotify doesn't fire
-- (network mounts) and cases the directory watcher below misses.
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = checktime_group,
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = checktime_group,
  callback = function()
    vim.notify("File changed on disk, buffer reloaded.", vim.log.levels.WARN)
  end,
})

-- Instant detection: watch the directory of every open file buffer via inotify
-- (same mechanism Oil's `watch_for_changes` uses), so external edits show up
-- immediately instead of waiting for CursorHold/'updatetime' to fire.
local dir_watchers = {} ---@type table<string, {handle: uv.uv_fs_event_t, refcount: integer}>
local buf_dirs = {} ---@type table<integer, string>

local function watch_dir(dir)
  local entry = dir_watchers[dir]
  if entry then
    entry.refcount = entry.refcount + 1
    return
  end
  local handle = vim.uv.new_fs_event()
  if not handle then
    return
  end
  local ok = handle:start(dir, {}, vim.schedule_wrap(function()
    vim.cmd("checktime")
  end))
  if ok then
    dir_watchers[dir] = { handle = handle, refcount = 1 }
  else
    handle:close()
  end
end

local function unwatch_dir(dir)
  local entry = dir_watchers[dir]
  if not entry then
    return
  end
  entry.refcount = entry.refcount - 1
  if entry.refcount <= 0 then
    entry.handle:stop()
    entry.handle:close()
    dir_watchers[dir] = nil
  end
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = checktime_group,
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "" then
      return
    end
    local name = vim.api.nvim_buf_get_name(args.buf)
    if name == "" then
      return
    end
    local dir = vim.fs.dirname(name)
    if not dir then
      return
    end
    buf_dirs[args.buf] = dir
    watch_dir(dir)
  end,
})

vim.api.nvim_create_autocmd("BufDelete", {
  group = checktime_group,
  callback = function(args)
    local dir = buf_dirs[args.buf]
    if dir then
      buf_dirs[args.buf] = nil
      unwatch_dir(dir)
    end
  end,
})

-- Manual trigger, mirroring Oil's own '<C-l>' refresh keymap (buffer-local to
-- Oil, so it takes priority there and doesn't collide with this global one).
vim.keymap.set("n", "<C-l>", "<cmd>checktime<CR>", { desc = "Check for external file changes" })
