return {
  "nvim-treesitter/nvim-treesitter-context",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    max_lines = 3,
  },
  keys = {
    { "<leader>tc", function() require("treesitter-context").go_to_context() end, desc = "Jump to context" },
  },
}
