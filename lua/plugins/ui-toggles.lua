-- UI toggle functions using Snacks (matching LazyVim)

local ok, Snacks = pcall(require, "snacks")
if not ok then
  return
end

-- Toggle diagnostics
Snacks.toggle({
  name = "Diagnostics",
  get = vim.diagnostic.is_enabled,
  set = vim.diagnostic.enable,
}):map("<leader>ud")

-- Toggle line numbers
Snacks.toggle({
  name = "Line Numbers",
  get = function()
    return vim.opt.number:get()
  end,
  set = function(state)
    vim.opt.number = state
  end,
}):map("<leader>ul")

-- Toggle relative line numbers
Snacks.toggle({
  name = "Relative Numbers",
  get = function()
    return vim.opt.relativenumber:get()
  end,
  set = function(state)
    vim.opt.relativenumber = state
  end,
}):map("<leader>uL")

-- Toggle spell checking
Snacks.toggle({
  name = "Spelling",
  get = function()
    return vim.opt.spell:get()
  end,
  set = function(state)
    vim.opt.spell = state
  end,
}):map("<leader>us")

-- Toggle line wrap
Snacks.toggle({
  name = "Line Wrap",
  get = function()
    return vim.opt.wrap:get()
  end,
  set = function(state)
    vim.opt.wrap = state
  end,
}):map("<leader>uw")

-- Toggle inlay hints
Snacks.toggle({
  name = "Inlay Hints",
  get = function()
    return vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
  end,
  set = function(state)
    vim.lsp.inlay_hint.enable(state)
  end,
}):map("<leader>uh")

-- Toggle conceallevel
Snacks.toggle({
  name = "Conceal Level",
  get = function()
    return vim.opt.conceallevel:get() > 0
  end,
  set = function(state)
    vim.opt.conceallevel = state and 2 or 0
  end,
}):map("<leader>uc")

-- Toggle auto-completion (blink.cmp)
-- When disabled, you can still manually trigger with <C-Space>
vim.g.auto_completion_enabled = false
Snacks.toggle({
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
}):map("<leader>ua")
