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

-- Override the language mapping AFTER treesitter.configs.setup
-- systemverilog filetype should use systemverilog parser (not verilog)
-- (Neovim/nvim-treesitter default to mapping systemverilog → verilog, but parser is systemverilog.so)
vim.treesitter.language.register("systemverilog", "systemverilog")

-- Ensure treesitter parses on buffer enter
-- This is needed for mini.ai to work immediately (otherwise parser is lazy)
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  callback = function(args)
    local buf = args.buf
    if vim.bo[buf].buftype ~= "" then
      return
    end -- Skip special buffers

    -- Try to get parser and parse
    local ok, parser = pcall(vim.treesitter.get_parser, buf)
    if ok and parser then
      parser:parse()
    end
  end,
})
