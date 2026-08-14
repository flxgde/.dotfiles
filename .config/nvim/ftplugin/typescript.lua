vim.keymap.set("n", "<leader>cM", vim.flxg.multilinify, {
  buffer = true,
  silent = true,
  desc = "Expand array/object/import list to multiline",
})
