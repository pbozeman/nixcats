-- neovim configuration

-- Make :q behave like :qa (quit all)
vim.cmd([[
  cnoreabbrev <expr> q getcmdtype() == ":" && getcmdline() == "q" ? "qa" : "q"
]])

-- Load config
require("config.options")
require("config.autocmds")
require("config.commands")
require("config.keymaps")

-- Load plugins
require("plugins.treesitter") -- Must load before plugins that depend on it
require("plugins.colorscheme")
require("plugins.which-key")
require("plugins.trouble")
require("plugins.lualine")
require("plugins.snacks")
require("plugins.gitsigns")
require("plugins.blink")
require("plugins.lsp")
require("plugins.conform")
require("plugins.indent-blankline")
require("plugins.marks")
require("plugins.mini-indentscope")
require("plugins.mini-surround")
require("plugins.mini-ai")
require("plugins.neo-tree")
require("plugins.smartyank")
require("plugins.tmux")
require("plugins.tint")
require("plugins.ui-toggles")
require("plugins.yanky")
require("plugins.claude-helper")
