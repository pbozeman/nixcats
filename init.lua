-- neovim configuration

-- Make :q behave like :qa (quit all)
vim.cmd([[
  cnoreabbrev <expr> q getcmdtype() == ":" && getcmdline() == "q" ? "qa" : "q"
]])

-- Load config
require("config.options")
require("config.autocmds")
require("config.commands")

-- Load plugins
require("plugins.colorscheme")
require("plugins.which-key")
require("plugins.fzf")
require("plugins.gitsigns")
require("plugins.lsp")
require("plugins.conform")
require("plugins.neo-tree")
require("plugins.tmux")
require("plugins.tint")
require("plugins.ui-toggles")
