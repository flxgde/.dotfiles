-- `autoread` only reloads a buffer when Vim happens to check; these events make
-- it check on focus/cursor-idle instead of just on a handful of built-in triggers.
local checktime_group = vim.api.nvim_create_augroup("flxg_checktime", { clear = true })

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
