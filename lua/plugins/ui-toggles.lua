-- UI toggle functions similar to LazyVim

-- Toggle diagnostics
vim.keymap.set("n", "<leader>ud", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle Diagnostics" })

-- Toggle line numbers
vim.keymap.set("n", "<leader>ul", function()
  vim.opt.number = not vim.opt.number:get()
end, { desc = "Toggle Line Numbers" })

-- Toggle relative line numbers
vim.keymap.set("n", "<leader>uL", function()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, { desc = "Toggle Relative Numbers" })

-- Toggle spell checking
vim.keymap.set("n", "<leader>us", function()
  vim.opt.spell = not vim.opt.spell:get()
end, { desc = "Toggle Spelling" })

-- Toggle line wrap
vim.keymap.set("n", "<leader>uw", function()
  vim.opt.wrap = not vim.opt.wrap:get()
end, { desc = "Toggle Line Wrap" })

-- Toggle inlay hints
vim.keymap.set("n", "<leader>uh", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle Inlay Hints" })

-- Toggle conceallevel
local conceallevel = vim.opt.conceallevel:get()
vim.keymap.set("n", "<leader>uc", function()
  if vim.opt.conceallevel:get() == 0 then
    vim.opt.conceallevel = conceallevel
  else
    conceallevel = vim.opt.conceallevel:get()
    vim.opt.conceallevel = 0
  end
end, { desc = "Toggle Conceal" })
