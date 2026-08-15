
local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.autoindent = true
opt.expandtab = true

opt.smartindent = true
opt.wrap = false

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

opt.cursorline = true

opt.termguicolors = true
opt.signcolumn = "yes"

opt.backspace = "indent,eol,start"

opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom


vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

opt.swapfile = false
opt.mouse = ""

opt.autoread = true -- reload unmodified buffers when the file changes on disk

vim.cmd [[
  highlight LineNr guifg=#888888 guibg=NONE
]]

