vim.g.mapleader = " "
vim.g.maplocalleader = " "
local keymap = vim.keymap
keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open tree" })
keymap.set("n", "<leader>pc", function()
	vim.cmd("Lexplore " .. vim.fn.expand("%:p:h"))
end, { desc = "Open tree and center current file" })

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

