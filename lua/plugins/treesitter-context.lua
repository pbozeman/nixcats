-- Treesitter context - show sticky header with current scope context
local ok, tsc = pcall(require, "treesitter-context")
if not ok then
  return
end

-- Setup Snacks toggle for <leader>ut (matching LazyVim)
local ok_snacks, Snacks = pcall(require, "snacks")
if ok_snacks then
  Snacks.toggle({
    name = "Treesitter Context",
    get = tsc.enabled,
    set = function(state)
      if state then
        tsc.enable()
      else
        tsc.disable()
      end
    end,
  }):map("<leader>ut")
end

-- Setup with minimal config (matching LazyVim)
tsc.setup({
  mode = "cursor",
  max_lines = 3,
})

-- Keymap to jump to context
vim.keymap.set("n", "[c", function()
  require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true, desc = "Jump to context" })
