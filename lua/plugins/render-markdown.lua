-- Markdown rendering in Neovim
-- Based on LazyVim's extras/lang/markdown.lua

require("render-markdown").setup({
  code = {
    sign = false,
    width = "block",
    right_pad = 1,
  },
  heading = {
    sign = false,
    icons = {},
  },
  checkbox = {
    enabled = false,
  },
})

-- Create a toggle for render-markdown using Snacks
Snacks.toggle({
  name = "Render Markdown",
  get = require("render-markdown").get,
  set = require("render-markdown").set,
}):map("<leader>um")
