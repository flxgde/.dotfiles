return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = {
    {
      "<leader>e",
      function()
        local name = vim.api.nvim_buf_get_name(0)
        local oil_dir = name:match("^oil://(.*)")
        if oil_dir then
          vim.cmd("Neotree toggle dir=" .. oil_dir)
        else
          vim.cmd("Neotree toggle")
        end
      end,
      desc = "Toggle file tree",
    },
    { "<leader>E", "<cmd>Neotree reveal<CR>", desc = "Reveal file in tree" },
  },
  opts = {
    close_if_last_window = true,
    window = {
      width = 32,
      mappings = {
        ["<space>"] = "none", -- don't steal leader
        ["l"] = "open",
        ["h"] = "close_node",
      },
    },
    filesystem = {
      follow_current_file = { enabled = true },
      hijack_netrw_behavior = "disabled", -- oil handles netrw
      use_libuv_file_watcher = true,
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = true,
      },
    },
    default_component_configs = {
      git_status = {
        symbols = {
          added     = "",
          modified  = "",
          deleted   = "✖",
          renamed   = "󰁕",
          untracked = "",
          ignored   = "",
          unstaged  = "󰄱",
          staged    = "",
          conflict  = "",
        },
      },
    },
  },
}
