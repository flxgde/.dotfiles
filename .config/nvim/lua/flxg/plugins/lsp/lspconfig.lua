return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
  },
  config = function()
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local keymap = vim.keymap -- for conciseness

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buf = ev.buf, silent = true }

        -- set keybinds
        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

        -- ts_ls and angularls both answer textDocument/references, so the
        -- default quickfix list ends up with every entry duplicated. Dedupe.
        opts.desc = "Show LSP references (quickfix, deduped)"
        keymap.set("n", "grr", function()
          vim.lsp.buf.references(nil, {
            on_list = function(list)
              local seen, items = {}, {}
              for _, item in ipairs(list.items) do
                local key = string.format("%s:%d:%d", item.filename, item.lnum, item.col)
                if not seen[key] then
                  seen[key] = true
                  table.insert(items, item)
                end
              end
              vim.fn.setqflist({}, " ", { title = list.title, items = items })
              vim.cmd("botright copen")
            end,
          })
        end, opts)

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, on_jump = function() vim.diagnostic.open_float() end }) end, opts)

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, on_jump = function() vim.diagnostic.open_float() end }) end, opts)

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", function()
          local bufnr = vim.api.nvim_get_current_buf()
          for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
            local config = client.config
            vim.lsp.stop_client(client.id)
            vim.defer_fn(function()
              vim.lsp.start(config, { bufnr = bufnr })
            end, 500)
          end
        end, opts) -- restart lsp clients attached to the current buffer
      end,
    })

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()


    -- Configure how diagnostics are displayed
    vim.diagnostic.config({
      virtual_text = {
        prefix = "●", -- could be "■", "▎", "x"
        spacing = 2,
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = "󰠠 ",
          [vim.diagnostic.severity.INFO] = " ",
        },
      },
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
      },
    })

    -- Server installation and enabling are handled by mason-lspconfig
    -- (ensure_installed + automatic_enable). Here we only define config that
    -- deep-merges onto nvim-lspconfig's bundled lsp/<name>.lua specs.

    -- Apply cmp completion capabilities to every server.
    vim.lsp.config("*", { capabilities = capabilities })

    -- angularls and svelte are left to the bundled configs: the former now
    -- derives cmd/probe paths and the Angular version itself, the latter
    -- already ships the $/onDidChangeTsOrJsFile reload workaround.

    vim.lsp.config("graphql", {
      filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
    })

    vim.lsp.config("emmet_ls", {
      filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
    })

    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          completion = { callSnippet = "Replace" },
          diagnostics = { globals = { "vim" } },
        },
      },
    })
  end,
}

