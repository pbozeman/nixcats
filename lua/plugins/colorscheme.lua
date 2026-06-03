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
    -- Float bg for popups (which-key, snacks picker, blink completion/docs).
    -- Just a touch below the coordinated terminal bg family (wezterm
    -- #111318, tmux active #141720) so popups read as gently recessed,
    -- without the harshness of pure black.
    colors.bg_float = "#0f1117"
  end,
  on_highlights = function(hl, c)
    -- Keep the recessed dark fill (bg_float) only inside floats. Give the
    -- border + title rings a transparent bg so the area around the border
    -- line uses the normal editor bg instead of the dark popup color.
    hl.FloatBorder = { fg = c.border_highlight, bg = c.none }
    hl.FloatTitle = { fg = c.border_highlight, bg = c.none }
    hl.BlinkCmpMenuBorder = { fg = c.border_highlight, bg = c.none }
    hl.BlinkCmpDocBorder = { fg = c.border_highlight, bg = c.none }
    hl.BlinkCmpSignatureHelpBorder = { fg = c.border_highlight, bg = c.none }
    -- snacks picker hardcodes these to bg_float; its other border/title
    -- groups default-link to FloatBorder/FloatTitle handled above.
    hl.SnacksPickerInputBorder = { fg = c.orange, bg = c.none }
    hl.SnacksPickerInputTitle = { fg = c.orange, bg = c.none }
    hl.SnacksPickerBoxTitle = { fg = c.orange, bg = c.none }
  end,
})

vim.cmd.colorscheme("tokyonight")
