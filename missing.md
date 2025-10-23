# Missing Features from lazyvim-nix

Comparison between the old lazyvim-nix configuration and the current nixcats setup.

## Major Missing Features

### 1. Completion System

**Status**: ❌ Not configured at all

Your old config had a full completion setup with:

- `nvim-cmp` (completion engine)
- `cmp-buffer`, `cmp-nvim-lsp`, `cmp-path`, `cmp_luasnip` (sources)
- `LuaSnip` + `friendly-snippets`
- `nvim-snippets`

Your current nixcats has **no completion** configured.

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

**Status**: ⚠️ Partially different

- ❌ `telescope.nvim` + `telescope-fzf-native-nvim` (you're using fzf-lua instead)
- ✅ `marks.nvim` - Better mark visualization (present)
- ❌ `flash.nvim` - Jump to any location
- ❌ `oil-nvim` - File manager

### 5. UI Enhancements

**Status**: ⚠️ Partially missing

- ✅ `indent-blankline-nvim` - Indentation guides (present)
- ❌ `noice.nvim` - Better cmd/message UI
- ❌ `dressing.nvim` - Better vim.ui interfaces
- ❌ `todo-comments.nvim` - Highlight TODO/FIXME
- ❌ `vim-illuminate` - Highlight word under cursor
- ❌ `persistence.nvim` - Session management

### 6. Mini.nvim Modules

**Status**: ⚠️ Partially missing

Your old config had several mini.nvim modules:

- ✅ `mini.indentscope` - Scope indicator (present)
- ✅ `mini.surround` - Surround operations (present)
- ❌ `mini.ai` - Text objects
- ❌ `mini.bufremove` - Better buffer deletion
- ❌ `mini.comment` - Commenting
- ❌ `mini.pairs` - Auto pairs (disabled in old config)

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

- Missing `tex-fmt` formatter configuration

### 8. Git Integration

**Status**: ✅ gitsigns present, ❌ others missing

- ✅ `gitsigns.nvim` (present)
- ❌ `yanky.nvim` - Better yank/paste ring
- ❌ `lazygit` in runtime dependencies

### 9. LSP Enhancements

**Status**: ⚠️ Partially missing

- ❌ `lazydev-nvim` / `neodev-nvim` - Better Lua LSP for Neovim config
- ❌ `neoconf-nvim` - Project-local LSP settings
- ❌ `rust-tools.nvim` - Enhanced Rust support
- ❌ `crates-nvim` - Cargo.toml helper
- ❌ Inlay hints toggle (from `/home/pbozeman/src/lazyvim-nix/config/lua/plugins/hints.lua:18-24`)

### 10. Treesitter Extras

**Status**: ⚠️ Basic treesitter present, extras missing

- ✅ `nvim-treesitter.withAllGrammars` (present)
- ❌ `nvim-treesitter-context` - Show context at top
- ❌ `nvim-treesitter-textobjects` - Text object selection
- ❌ `nvim-ts-autotag` - Auto-close HTML tags
- ❌ `ts-comments-nvim` - Better comment detection

### 11. Other Plugins

**Status**: ❌ Missing

- `snacks-nvim` - Collection of small utilities
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
- `tex-fmt` for LaTeX
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
- `tex-fmt` (LaTeX formatter)
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

- **Completion**: 0% (not configured)
- **LSP**: ~70% (basic setup, missing enhancements)
- **UI Plugins**: ~30% (basic plugins, missing many enhancements)
- **Language-specific**: ~40% (C/C++ missing tools, Rust/Nix basic)
- **Debugging**: 0% (not configured)
- **Keymaps**: ~20% (basic only)
- **Options**: ~60% (core settings present)
- **Autocmds**: ~30% (missing language-specific)

## Priority Recommendations

High priority (core functionality):

1. **Completion system** (nvim-cmp + sources)
2. **Buffer navigation keymaps** (tab/shift-tab)
3. **Spell checking** (options)
4. **Mini.nvim modules** (comment, ai)

Medium priority (quality of life): 5. **C++ development tools** (cmake-tools, overseer) 6. **LSP enhancements** (lazydev, inlay hints) 7. **UI improvements** (todo-comments, dressing) 8. **Missing autocmds** (verilog, java)

Low priority (nice to have): 9. **Debugging setup** (nvim-dap) 10. **Specialized file types** (neorg, plantuml) 11. **Additional tools** (yanky, persistence)
