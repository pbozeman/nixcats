-- nvim-treesitter configuration
-- Provides syntax highlighting, indentation, and text objects via tree-sitter

require("nvim-treesitter.configs").setup({
  -- Highlighting
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  -- Indentation
  indent = {
    enable = true,
  },

  -- Incremental selection
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = false,
      node_decremental = "<bs>",
    },
  },
})

-- Enable folding via treesitter
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false -- Don't fold by default
