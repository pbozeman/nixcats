-- nixCats neovim configuration
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Load plugins
require("plugins.colorscheme")
require("plugins.which-key")
require("plugins.fzf")
require("plugins.lsp")
require("plugins.conform")
require("plugins.neo-tree")
require("plugins.tmux")
require("plugins.tint")
require("plugins.ui-toggles")
