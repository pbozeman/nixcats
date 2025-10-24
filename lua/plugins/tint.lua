local ok, tint = pcall(require, "tint")
if not ok then
  return
end

tint.setup({
  -- Darken colors, use a positive value to brighten
  tint = -50,
  -- Saturation to preserve
  saturation = 0.8,
  -- Showing default behavior, but value here can be predefined set of transforms
  transforms = require("tint").transforms.SATURATE_TINT,
  -- Tint background portions of highlight groups
  tint_background_colors = false,
  -- Don't tint number column highlight groups
  highlight_ignore_patterns = { "^LineNr$" },
  -- Disable tint's automatic behavior by ignoring all windows
  window_ignore_function = function()
    return true
  end,
})

-- Track the last window we left
local last_win = nil

vim.api.nvim_create_autocmd("WinLeave", {
  callback = function()
    last_win = vim.api.nvim_get_current_win()
  end,
})

-- Manually control tinting with our own WinEnter
vim.api.nvim_create_autocmd("WinEnter", {
  callback = function()
    local current_win = vim.api.nvim_get_current_win()
    local current_buf = vim.api.nvim_win_get_buf(current_win)
    local current_filetype = vim.bo[current_buf].filetype

    -- When entering neo-tree or snacks, untint the window we left
    if current_filetype == "neo-tree" or current_filetype:match("^snacks_") then
      if last_win and vim.api.nvim_win_is_valid(last_win) then
        tint.untint(last_win)
      end
      return
    end

    -- Tint all windows except current, neo-tree, and snacks
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      local filetype = vim.bo[buf].filetype

      if win == current_win then
        tint.untint(win)
      elseif filetype ~= "neo-tree" and not filetype:match("^snacks_") then
        tint.tint(win)
      end
    end
  end,
})

-- Tint all windows when losing focus
vim.api.nvim_create_autocmd("FocusLost", {
  callback = function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      tint.tint(win)
    end
  end,
})

-- Untint current window, neo-tree, and snacks when gaining focus
vim.api.nvim_create_autocmd("FocusGained", {
  callback = function()
    local current_win = vim.api.nvim_get_current_win()
    tint.untint(current_win)

    -- Always untint neo-tree and snacks windows
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      local filetype = vim.bo[buf].filetype
      if filetype == "neo-tree" or filetype:match("^snacks_") then
        tint.untint(win)
      end
    end
  end,
})
