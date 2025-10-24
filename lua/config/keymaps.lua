-- Keymaps configuration

-- Better up/down navigation - respects line wrapping
-- When no count is given, move by visual line (gj/gk)
-- When count is given (e.g., 5j), move by actual line (j/k)
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

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

-- Messages viewer
vim.keymap.set("n", "<leader>xm", function()
  -- Open :messages in a proper buffer window
  vim.cmd("botright split")
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(0, buf)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "messages"

  -- Get messages and put in buffer
  local output = vim.fn.execute("messages")
  local messages = vim.split(vim.trim(output), "\n")
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, messages)
  vim.bo[buf].modifiable = false

  -- Scroll to bottom to see latest messages
  vim.cmd("normal! G")
end, { desc = "Messages" })
