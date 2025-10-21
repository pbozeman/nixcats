-- Lualine statusline
local ok, lualine = pcall(require, "lualine")
if not ok then
  return
end

local icons = require("config.icons").icons

lualine.setup({
  options = {
    theme = "auto",
    globalstatus = true,
    disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = {
      {
        "diagnostics",
        symbols = {
          error = icons.diagnostics.Error,
          warn = icons.diagnostics.Warn,
          info = icons.diagnostics.Info,
          hint = icons.diagnostics.Hint,
        },
      },
      { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
      { "filename", path = 1 },
    },
    lualine_x = {
      {
        "diff",
        symbols = {
          added = icons.git.added,
          modified = icons.git.modified,
          removed = icons.git.removed,
        },
      },
    },
    lualine_y = {
      { "progress", separator = " ", padding = { left = 1, right = 0 } },
      { "location", padding = { left = 0, right = 1 } },
    },
    lualine_z = {},
  },
  extensions = { "neo-tree", "fzf" },
})
