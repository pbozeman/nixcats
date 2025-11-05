-- tokyonight colorscheme configuration
local ok, tokyonight = pcall(require, "tokyonight")
if not ok then
  return
end

tokyonight.setup({
  transparent = true,
  styles = {
    sidebars = "transparent",
    floats = "normal", -- Use normal background for floats (like Trouble, completion menus)
    comments = { fg = "#f8c8dc", italic = true },
  },
  on_colors = function(colors)
    -- the tokyonight red has no chill, use the red from nord.
    -- (it's a bit too pastel, but better than the default.)
    colors.error = "#bf616a"
    colors.red = "#bf616a"
    colors.red1 = "#bf616a"
    -- Set float background to black
    colors.bg_float = "#000000"
  end,
})

vim.cmd.colorscheme("tokyonight")
