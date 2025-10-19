-- nixCats neovim configuration
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Load plugins
require("plugins.which-key")
require("plugins.lsp")
require("plugins.tmux")
