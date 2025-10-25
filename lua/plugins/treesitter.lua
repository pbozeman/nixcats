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

-- Auto-close and auto-rename HTML tags
require("nvim-ts-autotag").setup({
  opts = {
    enable_close = true, -- Auto close tags
    enable_rename = true, -- Auto rename pairs of tags
    enable_close_on_slash = false, -- Auto close on trailing </
  },
})

-- Enable folding via treesitter
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false -- Don't fold by default

-- Language mapping for SystemVerilog
-- nvim-treesitter defaults: systemverilog filetype -> verilog language (for queries)
-- But only systemverilog.so parser exists, not verilog.so
-- Register both filetype->parser and language->parser mappings
-- This keeps highlight queries working (they're in queries/verilog/)
-- Queries symlinked: after/queries/systemverilog -> after/queries/verilog
vim.treesitter.language.register("systemverilog", {"verilog", "systemverilog"})

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

-- Reparse after text changes in normal mode (for commenting/uncommenting)
-- Only fires after normal mode changes, not while typing in insert mode
vim.api.nvim_create_autocmd("TextChanged", {
  callback = function(args)
    local buf = args.buf
    if vim.bo[buf].buftype ~= "" then
      return
    end

    local ok, parser = pcall(vim.treesitter.get_parser, buf)
    if ok and parser then
      parser:parse()
    end
  end,
})
