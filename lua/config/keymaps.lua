-- Keymaps configuration

-- Clear search highlights and close floating windows on escape
vim.keymap.set({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  -- Close all floating windows (scheduled to avoid E565)
  vim.schedule(function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local config = vim.api.nvim_win_get_config(win)
      if config.relative ~= "" then
        vim.api.nvim_win_close(win, false)
      end
    end
  end)
  return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

-- Quickfix list
vim.keymap.set("n", "<leader>xq", function()
  local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
  if qf_winid ~= 0 then
    vim.cmd.cclose()
  else
    vim.cmd.copen()
  end
end, { desc = "Quickfix List" })
