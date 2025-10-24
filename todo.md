# nixcats Configuration TODO

Based on comparison with current LazyVim (2025) and missing.md analysis.

## 📊 Progress Summary

**Phase 1 (Critical)**: 2/3 complete (67%)
- ✓ Completion system (blink.cmp)
- ✓ Text objects (mini.ai + treesitter-textobjects)
- ⏳ **ts-comments.nvim** - NEXT UP!

**Phase 2 (Quality of Life)**: 2/7 complete (29%)
- ✓ Some default keymaps (j/k, esc)
- ✓ Some autocmds (yank highlight, cursor position)
- ⏳ Flash.nvim, todo-comments, lazydev, grug-far, remaining keymaps/options

**Phase 3 (Advanced)**: Not started
- DAP debugging, C++ extensions, mini.pairs

**Phase 4 (Specialized)**: Not started
- Build/test tools, old config migration

---

## Phase 1 - Critical Functionality (HIGHEST PRIORITY)

### [ ] Better Comments - ts-comments.nvim

**Status**: Missing - **ONLY REMAINING PHASE 1 ITEM**

- Add to flake.nix: `ts-comments-nvim`
- Create `lua/plugins/ts-comments.lua` config
- Replaces need for mini.comment
- Reference: `/home/pbozeman/src/LazyVim/lua/lazyvim/plugins/coding.lua:28-32`

## Phase 2 - Quality of Life (HIGH PRIORITY)

### [ ] Flash.nvim - Enhanced Navigation

**Status**: Missing - LazyVim core feature

- Add to flake.nix: `flash-nvim`
- Create `lua/plugins/flash.lua` config
- Jump to any location with labeled hints
- Key: `s` (flash), `S` (treesitter)
- Reference: `/home/pbozeman/src/LazyVim/lua/lazyvim/plugins/editor.lua:30-54`

### [ ] Todo Comments

**Status**: Missing - useful for project navigation

- Add to flake.nix: `todo-comments-nvim`
- Create `lua/plugins/todo-comments.lua` config
- Highlights TODO/FIXME/HACK/NOTE in code
- Reference: `/home/pbozeman/src/LazyVim/lua/lazyvim/plugins/editor.lua:254-270`

### [ ] LazyDev - Neovim Lua Development

**Status**: Missing - essential for config development

- Add to flake.nix: `lazydev-nvim`
- Create `lua/plugins/lazydev.lua` config
- Provides completion for `vim.*`, `LazyVim.*`, `Snacks.*` APIs
- Reference: `/home/pbozeman/src/LazyVim/lua/lazyvim/plugins/coding.lua:75-87`

### [ ] Grug-far - Multi-file Search/Replace

**Status**: Missing - useful utility

- Add to flake.nix: `grug-far-nvim`
- Create `lua/plugins/grug-far.lua` config
- Key: `<leader>sr` for search and replace
- Reference: `/home/pbozeman/src/LazyVim/lua/lazyvim/plugins/editor.lua:4-25`

### [ ] Default LazyVim Keymaps

**Status**: Mostly done - few remaining

Update `lua/config/keymaps.lua`:

- [ ] `<S-h>` / `<S-l>` - Previous/Next buffer
- [x] `j` / `k` - Better up/down for wrapped lines (keymaps.lua:6-9)
- [x] `<esc>` - Clear search highlight + close floats (keymaps.lua:12-24)
- [ ] Better indenting with `<` / `>` - stay in visual mode
- Reference: `/home/pbozeman/src/LazyVim/lua/lazyvim/config/keymaps.lua`

### [ ] Default LazyVim Options

**Status**: Some missing

Update `lua/config/options.lua`:

- Set `spelllang = { "en" }`
- Set `root_spec` for project root detection
- Reference: `/home/pbozeman/src/LazyVim/lua/lazyvim/config/options.lua:101,33`

### [ ] Default LazyVim Autocmds

**Status**: Mostly done - spell checking still needed

Update `lua/config/autocmds.lua`:

- [x] Highlight on yank (autocmds.lua:8-13)
- [x] Go to last cursor position (autocmds.lua:16-31)
- [ ] Enable spell + wrap for markdown/text files
- Reference: `/home/pbozeman/src/LazyVim/lua/lazyvim/config/autocmds.lua:98-105`

## Phase 3 - Advanced Features (MEDIUM PRIORITY)

### [ ] Debugging (DAP) Setup

**Status**: Not configured - needed for C++ development

- Add to flake.nix: `nvim-dap`, `nvim-dap-ui`, `nvim-dap-virtual-text`, `nvim-nio`
- Add debugger: `codelldb` to lspsAndRuntimeDeps
- Create `lua/plugins/dap.lua` config
- Keys: `<leader>db` (breakpoint), `<leader>dc` (continue), etc.
- Reference: `/home/pbozeman/src/LazyVim/lua/lazyvim/plugins/extras/dap/core.lua`

### [ ] C++ Development Extensions

**Status**: Partially missing

- Add to flake.nix: `clangd-extensions-nvim`
- Update `lua/plugins/lsp.lua` to integrate clangd_extensions
- Provides: inlay hints, AST viewer, better clangd integration
- Reference: `/home/pbozeman/src/LazyVim/lua/lazyvim/plugins/extras/lang/clangd.lua:25-53`

### [ ] Mini.pairs - Auto-pairs

**Status**: Missing - optional QoL feature

- Already have `mini-nvim` in flake.nix ✓
- Create `lua/plugins/mini-pairs.lua` config
- Auto-close brackets, quotes, etc.
- Reference: `/home/pbozeman/src/LazyVim/lua/lazyvim/plugins/coding.lua:6-23`

## Phase 4 - Specialized Features (AS NEEDED)

### [ ] C++ Build/Test Tools

**Status**: Missing from old config

From old lazyvim-nix `cpp-dev.lua`:

- `cmake-tools.nvim` - CMake integration
- `overseer.nvim` - Task runner for builds/tests
- `cmake-gtest.nvim` - GTest integration

### [ ] Old Configuration Migration

**Status**: Not started - migrate as needed

From old lazyvim-nix config:

- Verilog autocmds (`lua/config/autocmds.lua` in old config)
- Java indentation settings
- Custom formatter configs (doxyformat for specific directories)
- PlantUML support (`nvim-soil`)
- Neorg note-taking setup
- Better-escape (`jk`/`jj` to escape)

### [ ] Missing from Old Config

**Status**: Evaluate if needed

Plugins that were in old config but not yet in nixcats:

- `persistence.nvim` - Session management
- `oil.nvim` - File manager alternative to neo-tree
- `vim-illuminate` - Highlight word under cursor
- `dressing.nvim` - Better vim.ui interfaces
- `noice.nvim` - Better command/message UI (heavy plugin)
- `neoconf.nvim` - Project-local LSP settings
- `project-nvim` - Project management
- `headlines-nvim` - Markdown headline highlighting
- `render-markdown-nvim` - Markdown rendering
- `nix-develop.nvim` - Nix shell integration

## Runtime Dependencies to Add

### [ ] Missing Runtime Tools

**Status**: Need to add to flake.nix lspsAndRuntimeDeps

- `jq` - JSON processing tool
- `lazygit` - Git TUI (if using lazygit keymaps)

## Completed Items ✓

### Phase 1 Complete (except ts-comments)
- ✓ **Completion System** - blink.cmp with friendly-snippets (lua/plugins/blink.lua)
- ✓ **Text Objects** - mini.ai + nvim-treesitter-textobjects (lua/plugins/mini-ai.lua)

### Core Plugins
- ✓ Yanky - Better yank/paste ring (lua/plugins/yanky.lua)
- ✓ Snacks.nvim - Utility collection: picker, terminal, git, etc. (lua/plugins/snacks.lua)
- ✓ Which-key - Keymap helper (lua/plugins/which-key.lua)
- ✓ Gitsigns - Git integration (lua/plugins/gitsigns.lua)
- ✓ Trouble - Diagnostics list (lua/plugins/trouble.lua)
- ✓ Neo-tree - File explorer (lua/plugins/neo-tree.lua)
- ✓ LSP basic setup (lua/plugins/lsp.lua)
- ✓ Treesitter with all grammars (lua/plugins/treesitter.lua)
- ✓ Conform - Formatting (lua/plugins/conform.lua)
- ✓ Lualine - Statusline (lua/plugins/lualine.lua)
- ✓ Mini.surround - Surround operations (lua/plugins/mini-surround.lua)
- ✓ Mini.indentscope - Scope indicator (lua/plugins/mini-indentscope.lua)
- ✓ Indent-blankline - Indentation guides (lua/plugins/indent-blankline.lua)
- ✓ Marks - Better mark visualization (lua/plugins/marks.lua)
- ✓ Smartyank - Smart yank behavior (lua/plugins/smartyank.lua)
- ✓ Tint - Inactive window dimming (lua/plugins/tint.lua)
- ✓ Tmux navigator - Seamless tmux navigation (lua/plugins/tmux.lua)

## Notes

- **Completion**: Chose blink.cmp (faster, more modern) over nvim-cmp ✓
- **Text Objects**: Using mini.ai + nvim-treesitter-textobjects ✓
- Many old plugins replaced by Snacks (fzf-lua → snacks.picker, etc.)
- LazyVim 2025 has moved away from some heavy plugins (noice, etc.)
- **Phase 1 Status**: Almost complete! Only ts-comments.nvim remaining
- Current focus: Finish Phase 1, then move to Phase 2 quality-of-life features
