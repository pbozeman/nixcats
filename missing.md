# Missing Features from lazyvim-nix

Comparison between the old lazyvim-nix configuration and the current nixcats setup.

**Last Updated**: 2025-10-24

## Overall Progress

**~75% Complete** - Most core functionality is now configured!

✅ **Fully Configured** (100%):
- Completion (blink.cmp)
- Navigation & Search (snacks picker with frecency)
- Treesitter (with textobjects, ts-comments)

✅ **Mostly Configured** (70-90%):
- UI Enhancements (todo-comments, trouble, which-key, tint, ui-toggles)
- Git Integration (gitsigns, yanky, smartyank, snacks git pickers)
- LSP (basic setup, inlay hints toggle, conform formatting)
- Mini.nvim modules (ai, surround, indentscope)

⚠️ **Partially Configured** (40-60%):
- Keymaps (many via plugins, some custom ones missing)
- Options (core settings, some missing)
- Language-specific features (formatters/LSPs present, specialized tools missing)

❌ **Missing** (0%):
- Debugging (nvim-dap)
- C++ Development Tools (cmake-tools, overseer)
- Specialized file types (neorg, plantuml)
- Some autocmds (verilog auto-format, java settings)

## Major Features Status

### 1. Completion System

**Status**: ✅ **CONFIGURED** (Using blink.cmp instead of nvim-cmp)

Your current nixcats has:
- `blink-cmp` (modern completion engine - faster than nvim-cmp)
- `friendly-snippets` (snippet collection)
- Auto-completion disabled by default, toggle with `<leader>ua`
- Configured in `lua/plugins/blink.lua`

**Note**: Switched from nvim-cmp to blink.cmp (better performance)

### 2. C++ Development Tools

**Status**: ❌ Missing

Missing plugins from `/home/pbozeman/src/lazyvim-nix/config/lua/plugins/cpp-dev.lua`:

- `cmake-tools.nvim` - CMake integration with keymaps (`<leader>c*`)
- `overseer.nvim` - Task runner for tests/builds (`<leader>o`)
- `cmake-gtest.nvim` - GTest integration
- `clangd_extensions-nvim` - Enhanced clangd features

### 3. Debugging (DAP)

**Status**: ❌ Missing

Missing entire debugging setup:

- `nvim-dap`, `nvim-dap-ui`, `nvim-dap-virtual-text`
- `codelldb` debugger wrapper

### 4. Navigation & Search

**Status**: ✅ **CONFIGURED** (Using snacks.nvim picker)

- ✅ `snacks.nvim` - Modern file picker with frecency sorting (configured in `lua/plugins/snacks.lua`)
- ✅ `marks.nvim` - Better mark visualization (present)
- ✅ `neo-tree.nvim` - File explorer (replaces oil-nvim)
- ❌ `flash.nvim` - Jump to any location (missing)

**Note**: Using snacks picker instead of telescope/fzf-lua. Frecency enabled for smart file sorting.

### 5. UI Enhancements

**Status**: ⚠️ Partially configured

- ✅ `indent-blankline-nvim` - Indentation guides (configured)
- ✅ `todo-comments.nvim` - Highlight TODO/FIXME (configured in `lua/plugins/todo-comments.lua`)
- ✅ `trouble.nvim` - Better diagnostics/quickfix UI (configured)
- ✅ `which-key.nvim` - Keybinding hints (configured)
- ✅ `tint-nvim` - Dim inactive windows (configured)
- ✅ UI toggles - Diagnostic, line numbers, spell, wrap, etc. (in `lua/plugins/ui-toggles.lua`)
- ❌ `noice.nvim` - Better cmd/message UI (missing)
- ❌ `dressing.nvim` - Better vim.ui interfaces (missing)
- ❌ `vim-illuminate` - Highlight word under cursor (missing)
- ❌ `persistence.nvim` - Session management (missing)

### 6. Mini.nvim Modules

**Status**: ✅ **MOSTLY CONFIGURED**

Your current config has:
- ✅ `mini.indentscope` - Scope indicator (configured in `lua/plugins/mini-indentscope.lua`)
- ✅ `mini.surround` - Surround operations (configured in `lua/plugins/mini-surround.lua`)
- ✅ `mini.ai` - Text objects (configured in `lua/plugins/mini-ai.lua`)
- ❌ `mini.bufremove` - Better buffer deletion (missing)
- ❌ `mini.comment` - Commenting (missing - using ts-comments instead)
- ❌ `mini.pairs` - Auto pairs (missing, was disabled in old config anyway)

### 7. Specialized File Types

**Status**: ❌ Missing

#### Neorg (note-taking)

From `/home/pbozeman/src/lazyvim-nix/config/lua/plugins/neorg.lua`:

```lua
workspaces = { notes = "~/notes" }
```

#### PlantUML

From `/home/pbozeman/src/lazyvim-nix/config/lua/plugins/plantuml.lua`:

- `nvim-soil` for diagram generation

#### LaTeX

- ✅ `tex-fmt` formatter configuration (present)

### 8. Git Integration

**Status**: ✅ **CONFIGURED**

- ✅ `gitsigns.nvim` - Git signs in gutter (configured in `lua/plugins/gitsigns.lua`)
- ✅ `yanky.nvim` - Better yank/paste ring (configured in `lua/plugins/yanky.lua`)
- ✅ `smartyank.nvim` - OSC52 clipboard sync (configured in `lua/plugins/smartyank.lua`)
- ✅ Git pickers in snacks - git_status, git_files, git_log
- ❌ `lazygit` in runtime dependencies (missing)

### 9. LSP Enhancements

**Status**: ⚠️ Partially configured

- ✅ LSP basic configuration (configured in `lua/plugins/lsp.lua`)
- ✅ Inlay hints toggle - `<leader>uh` (in `lua/plugins/ui-toggles.lua`)
- ✅ `conform.nvim` - Formatting (configured)
- ❌ `lazydev-nvim` / `neodev-nvim` - Better Lua LSP for Neovim config (missing)
- ❌ `neoconf-nvim` - Project-local LSP settings (missing)
- ❌ `rust-tools.nvim` - Enhanced Rust support (missing)
- ❌ `crates-nvim` - Cargo.toml helper (missing)

### 10. Treesitter Extras

**Status**: ✅ **CONFIGURED**

- ✅ `nvim-treesitter.withAllGrammars` - All parsers (configured in `lua/plugins/treesitter.lua`)
- ✅ `nvim-treesitter-textobjects` - Text object selection (in flake.nix)
- ✅ `ts-comments-nvim` - Better comment detection (configured in `lua/plugins/ts-comments.lua`)
- ✅ SystemVerilog syntax highlighting fixed (maps to verilog queries)
- ✅ Folding via treesitter enabled
- ✅ Incremental selection configured
- ❌ `nvim-treesitter-context` - Show context at top (missing)
- ❌ `nvim-ts-autotag` - Auto-close HTML tags (missing)

### 11. Other Plugins

✅ `snacks-nvim` - Collection of small utilities

- `project-nvim` - Project management
- `headlines-nvim` - Markdown headline highlighting
- `render-markdown-nvim` - Markdown rendering
- `better-escape.nvim` - `jk`/`jj` escape
- `nix-develop.nvim` - Nix shell integration
- `none-ls-nvim` (null-ls) - Linting/formatting bridge
- `bufferline-nvim` - Buffer tabs (was disabled in old config)
- `dashboard-nvim` - Start screen (was disabled in old config)

## Configuration Differences

### Keymaps

Missing from `/home/pbozeman/src/nixcats/lua/config/keymaps.lua`:

```lua
-- Tab/Shift-Tab for buffer navigation
vim.keymap.set("n", "<tab>", "<cmd> bn <CR>")
vim.keymap.set("n", "<S-tab>", "<cmd> bp <CR>")

-- gR for LSP references
vim.keymap.set("n", "gR", "<cmd> Trouble lsp_references <CR>")

-- Alt-j/k tmux workaround
vim.keymap.set("n", "<A-k>", "<esc>k", { desc = "Move up" })
vim.keymap.set("n", "<A-j>", "<esc>j", { desc = "Move down" })
vim.keymap.set("i", "<A-k>", "<esc>gk", { desc = "Move up" })
vim.keymap.set("i", "<A-j>", "<esc>gj", { desc = "Move down" })
vim.keymap.set("v", "<A-k>", "<esc>gk", { desc = "Move up" })
vim.keymap.set("v", "<A-j>", "<esc>gj", { desc = "Move down" })
```

### Options

Missing from `/home/pbozeman/src/nixcats/lua/config/options.lua`:

```lua
vim.cmd("packadd cfilter")  -- Quickfix filtering
vim.opt.spell = true
vim.opt.spelllang = { "en_us" }
vim.g.root_spec = { ".git" }
```

### Autocmds

Missing from `/home/pbozeman/src/nixcats/lua/config/autocmds.lua`:

```lua
-- Verilog auto-format on save with verible-verilog-format
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.v", "*.sv" },
  callback = function()
    -- Strip trailing whitespace in the current buffer
    vim.cmd([[%s/\s\+$//e]])

    local file = vim.fn.expand("<afile>")
    vim.cmd('!verible-verilog-format --inplace ...' .. file)
  end,
})

-- Java indentation (4 spaces)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
  end,
})

-- Disable formatting for these file types
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "cpp.j2", "java" },
  callback = function()
    vim.b.autoformat = false
  end,
})
```

### Formatter Configs

Missing from your conform setup in `/home/pbozeman/src/nixcats/lua/plugins/conform.lua`:

- `jq` for JSON formatting (you currently use prettier)
- `doxyformat` for C++ (conditional on directory):

  ```lua
  formatters_by_ft = {
    cpp = { "clang_format", "doxyformat" },
  },
  formatters = {
    doxyformat = {
      command = "doxyformat",
      args = { "-i", "$FILENAME" },
      stdin = false,
      condition = function(self, ctx)
        return string.match(ctx.dirname, "amsr%-vector%-fs%-ipcbinding") ~= nil
      end,
    },
  }
  ```

- `cmake_format --autosort=true`
- `nixpkgs_fmt` option (you use nixfmt instead)

## Runtime Dependencies

Missing tools in flake.nix that were in old `runtime.nix`:

- `jq` (JSON tool)
- `lazygit` (Git TUI)
- Custom `codelldb` wrapper for debugging

## LazyVim Base Framework

**Important Note**: Your old config used **LazyVim** as a base framework, which provides:

- Sensible default keymaps
- Pre-configured options
- Standard autocmds
- Plugin configurations and integrations
- UI enhancements

Your new nixcats setup is building from scratch, so you'll need to explicitly add any LazyVim features you want. This means many features that "just worked" in LazyVim now need manual configuration.

## Plugins in flake.nix vs Configured

Some plugins are declared in `/home/pbozeman/src/nixcats/flake.nix` but don't have Lua configuration yet:

- All plugins are listed in `startupPlugins.general` but not all have corresponding Lua config files

## Summary Statistics

- **Completion**: ✅ 100% (blink.cmp configured with snippets)
- **LSP**: ✅ 80% (configured, missing some enhancements)
- **UI Plugins**: ✅ 70% (todo-comments, trouble, which-key, tint, ui-toggles configured)
- **Treesitter**: ✅ 90% (configured with textobjects and ts-comments)
- **Navigation**: ✅ 100% (snacks picker with frecency, neo-tree, marks)
- **Git Integration**: ✅ 80% (gitsigns, yanky, smartyank, git pickers)
- **Mini.nvim**: ✅ 75% (ai, surround, indentscope configured)
- **Language-specific**: ⚠️ 40% (C/C++ missing tools, Rust/Nix basic)
- **Debugging**: ❌ 0% (not configured)
- **Keymaps**: ⚠️ 60% (many configured via plugins)
- **Options**: ⚠️ 60% (core settings present)
- **Autocmds**: ⚠️ 30% (missing language-specific)

## Recent Additions (Last Session)

- ✅ `todo-comments.nvim` - Configured with snacks picker integration
- ✅ `snacks.nvim` picker - Frecency sorting enabled (cwd_bonus, history_bonus)
- ✅ SystemVerilog highlighting - Fixed in preview windows
- ✅ `yanky.nvim` - Yank ring with snacks picker
- ✅ `ui-toggles.lua` - Toggle diagnostics, line numbers, spell, wrap, inlay hints, conceal, auto-completion

## Priority Recommendations

High priority (core functionality):

1. ~~**Completion system**~~ ✅ DONE (blink.cmp configured)
2. **Buffer navigation keymaps** (tab/shift-tab) - Still missing
3. **Spell checking** (options) - Toggle available via `<leader>us`, but not enabled by default
4. ~~**Mini.nvim modules**~~ ✅ MOSTLY DONE (ai, surround, indentscope configured)

Medium priority (quality of life):

5. **C++ development tools** (cmake-tools, overseer) - Still missing
6. **LSP enhancements** (lazydev, inlay hints toggle) - Inlay hints toggle exists in ui-toggles
7. ~~**UI improvements**~~ ✅ MOSTLY DONE (todo-comments, trouble, tint configured)
8. **Missing autocmds** (verilog auto-format, java settings) - Still missing

Low priority (nice to have):

9. **Debugging setup** (nvim-dap) - Still missing
10. **Specialized file types** (neorg, plantuml) - Still missing
11. ~~**Yanky**~~ ✅ DONE
12. **Additional UI** (dressing, noice, persistence) - Still missing
