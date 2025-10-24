-- ts-comments.nvim
-- Better comment handling with treesitter integration
-- Handles multiple comment types per language (e.g., JSDoc vs regular comments)
--
-- Default keymaps:
--   gc{motion} - Toggle comment (e.g., gcc for line, gcap for paragraph)
--   gb{motion} - Toggle block comment
--   Visual mode: gc/gb - Toggle comment on selection

return {
  setup = function()
    require("ts-comments").setup({})
  end,
}
