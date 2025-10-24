-- UI toggle functions similar to LazyVim

local snacks_ok, snacks = pcall(require, "snacks")

-- Toggle diagnostics
vim.keymap.set("n", "<leader>ud", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle Diagnostics" })

-- Toggle line numbers
vim.keymap.set("n", "<leader>ul", function()
  vim.opt.number = not vim.o.number
end, { desc = "Toggle Line Numbers" })

-- Toggle relative line numbers
vim.keymap.set("n", "<leader>uL", function()
  vim.opt.relativenumber = not vim.o.relativenumber
end, { desc = "Toggle Relative Numbers" })

-- Toggle spell checking
vim.keymap.set("n", "<leader>us", function()
  vim.opt.spell = not vim.o.spell
end, { desc = "Toggle Spelling" })

-- Toggle line wrap
vim.keymap.set("n", "<leader>uw", function()
  vim.opt.wrap = not vim.o.wrap
end, { desc = "Toggle Line Wrap" })

-- Toggle inlay hints
vim.keymap.set("n", "<leader>uh", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle Inlay Hints" })

-- Toggle conceallevel
local conceallevel = vim.o.conceallevel
vim.keymap.set("n", "<leader>uc", function()
  if vim.o.conceallevel == 0 then
    vim.opt.conceallevel = conceallevel
  else
    conceallevel = vim.o.conceallevel
    vim.opt.conceallevel = 0
  end
end, { desc = "Toggle Conceal" })

-- Toggle auto-completion (blink.cmp)
-- When disabled, you can still manually trigger with <C-Space>
if snacks_ok then
  vim.g.auto_completion_enabled = false
  snacks
    .toggle({
      name = "Auto-Completion",
      notify = false,
      get = function()
        return vim.g.auto_completion_enabled
      end,
      set = function(state)
        vim.g.auto_completion_enabled = state
        if not state then
          require("blink.cmp").hide()
        end
      end,
    })
    :map("<leader>ua")
end
