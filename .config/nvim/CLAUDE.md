# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration using lazy.nvim as the plugin manager. The config follows a modular Lua-based structure under the `flxg` namespace.

## Architecture

```
init.lua                     # Entry point: loads core and lazy
lua/flxg/
  core/
    init.lua                 # Loads set, flxg, remap
    set.lua                  # Vim options (tabs=2 spaces, relative numbers, no mouse)
    remap.lua                # Global keymaps (leader=space)
    flxg.lua                 # Custom utilities in vim.flxg namespace
  lazy.lua                   # lazy.nvim bootstrap and plugin spec imports
  plugins/                   # Plugin configs (auto-imported by lazy)
    lsp/
      mason.lua              # LSP server installation
      lspconfig.lua          # LSP configuration and keymaps
    nvim-jdtls.lua           # Java LSP plugin
  localplugins/              # Custom local plugins
    tmuxsession/             # Telescope-based tmux session switcher
ftplugin/
  java.lua                   # Java-specific config (jdtls setup)
```

## Key Patterns

- **Plugin format**: Each plugin is a separate file in `lua/flxg/plugins/` returning a lazy.nvim spec table
- **LSP servers**: Managed via Mason with auto-install list in `lsp/mason.lua`
- **Custom functions**: Added to `vim.flxg` namespace (e.g., `vim.flxg.ngjump` for Angular file jumping)
- **Filetype configs**: Use `ftplugin/<filetype>.lua` for language-specific settings (e.g., Java uses jdtls)
- **Neovim Lua development**: Uses `lazydev.nvim` for `vim.*` completions

## LSP Servers Configured

angularls, ansiblels, ts_ls, html, cssls, tailwindcss, svelte, lua_ls, graphql, emmet_ls, prismals, pyright, jdtls

## Java Support

Multi-module Maven/Gradle projects supported via `nvim-jdtls`. Project root detected by `pom.xml`, `build.gradle`, `settings.gradle`, `mvnw`, `gradlew`. Lombok support included.

## Key Mappings Reference

**Leader**: Space

| Mapping | Description |
|---------|-------------|
| `<leader>ff` | Find files |
| `<leader>fg` | Git files |
| `<leader>fs` | Live grep |
| `<leader>a` | Add to harpoon |
| `<C-e>` | Harpoon menu |
| `<C-1>` – `<C-5>` | Harpoon slots 1-5 |
| `gd` | Go to definition |
| `gR` | LSP references |
| `<leader>ca` | Code actions |
| `<leader>rn` | Rename symbol |
| `<leader>xw` | Trouble workspace diagnostics |
| `<leader>ga` | Jump between Angular .ts/.html |
| `<leader>bd` | Close buffer |
| `<leader>Ra` | Pseudo-restart: reload config + LSP + buffers (requires all saved) |
| `<leader>Rc` | Reload config (options, keymaps, utilities; skips lazy/plugins) |
| `<leader>Rb` | Reload buffers from disk (requires all saved) |
| `<leader>Rl` | Restart LSP (safe with unsaved changes) |

**Java-specific** (available in .java files):

| Mapping | Description |
|---------|-------------|
| `<leader>co` | Organize imports |
| `<leader>cv` | Extract variable |
| `<leader>cc` | Extract constant |
| `<leader>cm` | Extract method (visual) |
