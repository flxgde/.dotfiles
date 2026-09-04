return {
  'nvim-telescope/telescope.nvim',
  -- Track master: the nvim-treesitter "main" branch previewer fix is not yet
  -- in a tagged release (latest tag 0.1.8 predates it).
  branch = 'master',
  config = function ()
    local actions = require("telescope.actions")
    local telescope = require("telescope")
    local transform_mod = require("telescope.actions.mt").transform_mod

    local trouble = require("trouble")
    local trouble_telescope = require("trouble.sources.telescope")

    -- or create your custom action
    local custom_actions = transform_mod({
      open_trouble_qflist = function(prompt_bufnr)
        trouble.toggle("quickfix")
      end,
    })

    telescope.setup{
      defaults = {
        path_display = { "truncate" },
        layout_config = {
          horizontal = {
            width = 0.9,
            preview_width = 0.5,
          },
        },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.smart_send_to_qflist + custom_actions.open_trouble_qflist,
            ["<C-t>"] = trouble_telescope.open,
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
          }
        }
      },
    }

    -- set keymaps
    local keymap = vim.keymap -- for conciseness
    local builtin = require('telescope.builtin')
    local action_state = require("telescope.actions.state")

    local function get_visual_selection()
      local save_reg, save_regtype = vim.fn.getreg('"'), vim.fn.getregtype('"')
      vim.cmd('noau normal! ""y')
      local text = vim.fn.getreg('"')
      vim.fn.setreg('"', save_reg, save_regtype)
      return text:gsub("\n", "")
    end

    -- Prefills live_grep with `default_text` (e.g. a visual selection or the
    -- previous search) and makes the first <BS> wipe it in one go, as long as
    -- the prompt hasn't been touched yet; afterwards <BS> behaves normally.
    local last_grep_search = ""
    local function live_grep_prefilled(default_text)
      builtin.live_grep({
        default_text = default_text,
        attach_mappings = function(prompt_bufnr, map)
          local picker = action_state.get_current_picker(prompt_bufnr)
          vim.api.nvim_create_autocmd("BufWinLeave", {
            buffer = prompt_bufnr,
            once = true,
            callback = function()
              last_grep_search = picker:_get_prompt()
            end,
          })
          -- The very first keystroke (any printable character, or <BS>)
          -- wipes the prefill instead of editing it in place, like a browser
          -- address bar — then these guards remove themselves immediately,
          -- so every keystroke after that is 100% native, unintercepted
          -- typing. Two things this must avoid:
          -- 1. Re-checking "does the prompt still equal default_text" on
          --    every keystroke instead of consuming a one-shot flag: normal
          --    typing can coincidentally pass through the same text again
          --    (clearing "foo" and then typing "foobert" reconstructs "foo"
          --    after 3 keystrokes) and would wipe it a second time.
          -- 2. Leaving the intercept-and-refeed mapping active for the rest
          --    of the session: re-feeding every single keystroke through
          --    nvim_feedkeys forever is needless overhead for no benefit
          --    once the one-time job is done.
          -- reset_prompt() replaces the whole prompt (and its lone argument
          -- form conveniently also inserts the new text in that same atomic
          -- call) — re-feeding the typed character afterward via
          -- nvim_feedkeys is unnecessary and, worse, unreliable: it can
          -- silently swallow that first character under the rapid
          -- self-triggered re-dispatch.
          if default_text ~= "" then
            local guarded_keys = { "<BS>" }
            for byte = 32, 126 do
              table.insert(guarded_keys, string.char(byte))
            end

            local function clear_prefill_guards()
              for _, key in ipairs(guarded_keys) do
                pcall(vim.keymap.del, "i", key, { buffer = prompt_bufnr })
              end
            end

            map("i", "<BS>", function()
              clear_prefill_guards()
              picker:reset_prompt()
            end)
            for byte = 32, 126 do
              local char = string.char(byte)
              map("i", char, function()
                clear_prefill_guards()
                picker:reset_prompt(char)
              end)
            end
          end
          return true
        end,
      })
    end

    keymap.set("n", "<leader>fg", builtin.git_files, { desc = "Telescope git files" })
    keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fs", function()
      live_grep_prefilled(last_grep_search)
    end, { desc = "Find string in cwd" })
    keymap.set("v", "<leader>fs", function()
      live_grep_prefilled(get_visual_selection())
    end, { desc = "Find selected text in cwd" })
    keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
    keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
    keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
    keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope tags" })
  end,
}
