-- nixCats neovim configuration
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Load plugins
require("plugins.colorscheme")
require("plugins.which-key")
require("plugins.lsp")
require("plugins.conform")
require("plugins.tmux")
