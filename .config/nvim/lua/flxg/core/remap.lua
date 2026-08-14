vim.g.mapleader = " "
vim.g.maplocalleader = " "
local keymap = vim.keymap
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })                   -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })                 -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })                    -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })               -- close current split window

-- Terminal at root (new buffer)
vim.keymap.set("n", "<leader>tr", function()
  vim.cmd("lcd " .. vim.fn.fnameescape(vim.fn.getcwd()))
  vim.cmd("terminal")
  vim.cmd("startinsert")
end, { desc = "Terminal at root (new buffer)" })

-- Terminal at file (new buffer)
vim.keymap.set("n", "<leader>tf", function()
  vim.cmd("lcd " .. vim.fn.fnameescape(vim.fn.expand("%:p:h")))
  vim.cmd("terminal")
  vim.cmd("startinsert")
end, { desc = "Terminal at file (new buffer)" })

-- Terminal at root (split)
vim.keymap.set("n", "<leader>tsr", function()
  vim.cmd("split")
  vim.cmd("lcd " .. vim.fn.fnameescape(vim.fn.getcwd()))
  vim.cmd("terminal")
  vim.cmd("startinsert")
end, { desc = "Terminal at root (split)" })

-- Terminal at file (split)
vim.keymap.set("n", "<leader>tsf", function()
  vim.cmd("split")
  vim.cmd("lcd " .. vim.fn.fnameescape(vim.fn.expand("%:p:h")))
  vim.cmd("terminal")
  vim.cmd("startinsert")
end, { desc = "Terminal at file (split)" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

keymap.set("n", "<leader>oo", ":foldopen<CR>", { desc = "fold open" })
keymap.set("n", "<leader>oc", ":foldclose<CR>", { desc = "fold close" })

keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")

keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")
keymap.set("x", "<leader>p", "\"_dP")

keymap.set("n", "<leader>y", "\"+y")
keymap.set("v", "<leader>y", "\"+y")
keymap.set("n", "<leader>Y", "\"+Y")

keymap.set("i", "<C-c>", "<Esc>")
keymap.set("n", "Q", "<nop>")
keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, { desc = "Format buffer" })

keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

keymap.set("n", "<leader>ga", vim.flxg.ngjump, { desc = "Jump between .ts and .html" })
keymap.set("n", "<leader>gc", vim.flxg.nggc, { desc = "Generate Angular component" })
keymap.set("n", "<leader>pd", vim.flxg.duplicate, { desc = "Duplicates current file at specified path" })

keymap.set("n", "<leader>qo", "<cmd>copen<CR>", { desc = "Open quickfix" })
keymap.set("n", "<leader>qc", "<cmd>cclose<CR>", { desc = "Close quickfix" })

keymap.set("n", "<leader>bd", "<cmd>bd<CR>", { desc = "Close buffer" })

keymap.set("n", "<leader>rc", vim.flxg.run_line, { desc = "Run current line as shell command" })

keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })

vim.keymap.set({'n', 'i', 'v'}, '<F1>', '<nop>')

-- Toggle comment with Ctrl+/
keymap.set("n", "<C-/>", "gcc", { remap = true, desc = "Toggle comment" })
keymap.set("v", "<C-/>", "gc", { remap = true, desc = "Toggle comment" })

-- German umlauts (insert mode): Alt + vowel/s
keymap.set("i", "<A-a>", "ä")
keymap.set("i", "<A-o>", "ö")
keymap.set("i", "<A-u>", "ü")
keymap.set("i", "<A-A>", "Ä")
keymap.set("i", "<A-O>", "Ö")
keymap.set("i", "<A-U>", "Ü")
keymap.set("i", "<A-s>", "ß")

-- Terminal Escape
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Pseudo-restart helpers
local function _all_saved()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].modified then
      vim.notify("Unsaved buffers — save all first.", vim.log.levels.WARN)
      return false
    end
  end
  return true
end

local function _reload_config()
  for name in pairs(package.loaded) do
    if name:match("^flxg") then package.loaded[name] = nil end
  end
  require("flxg.core")
end

local function _reload_bufs()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.fn.bufname(buf) ~= "" then
      vim.api.nvim_buf_call(buf, function() vim.cmd("edit") end)
    end
  end
end

-- <leader>Rc — reload config (options, keymaps, utilities; skips lazy/plugins)
keymap.set("n", "<leader>Rc", function()
  _reload_config()
  vim.notify("Config reloaded.", vim.log.levels.INFO)
end, { desc = "Reload config" })

-- <leader>Rb — reload buffers from disk (requires all saved)
keymap.set("n", "<leader>Rb", function()
  if not _all_saved() then return end
  _reload_bufs()
  vim.notify("Buffers reloaded.", vim.log.levels.INFO)
end, { desc = "Reload buffers from disk" })

-- <leader>Rl — restart LSP without touching buffer content
-- Re-triggers FileType so servers re-attach; safe with unsaved changes.
keymap.set("n", "<leader>Rl", function()
  vim.lsp.stop_client(vim.lsp.get_clients())
  vim.defer_fn(function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) and vim.fn.bufname(buf) ~= "" then
        vim.api.nvim_exec_autocmds("FileType", { buf = buf })
      end
    end
    vim.notify("LSP restarted.", vim.log.levels.INFO)
  end, 500)
end, { desc = "Restart LSP" })

-- <leader>Ra — all: config + LSP + buffers (requires all saved)
keymap.set("n", "<leader>Ra", function()
  if not _all_saved() then return end
  _reload_config()
  vim.lsp.stop_client(vim.lsp.get_clients())
  vim.defer_fn(function()
    _reload_bufs() -- :edit fires FileType → LSP re-attaches
    vim.notify("Pseudo-restart complete.", vim.log.levels.INFO)
  end, 500)
end, { desc = "Pseudo-restart: config + LSP + buffers" })

