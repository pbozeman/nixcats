-- mini.indentscope - visualize and navigate indent scope
require("mini.indentscope").setup({
  symbol = "│",
  options = { try_as_border = true },
  draw = {
    -- Disable animation for better performance
    animation = require("mini.indentscope").gen_animation.none(),
  },
})

-- Disable in certain filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "Trouble",
    "fzf",
    "help",
    "lazy",
    "mason",
    "neo-tree",
    "notify",
    "trouble",
  },
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
})
