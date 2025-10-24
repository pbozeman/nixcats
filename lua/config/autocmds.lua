-- Autocommands

local function augroup(name)
  return vim.api.nvim_create_augroup("nixcats_" .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})

-- Go to last cursor position when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].nixcats_last_loc then
      return
    end
    vim.b[buf].nixcats_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Auto-reload files when changed externally
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Periodic file change checking (every 1 second)
local uv = vim.uv or vim.loop
local timer = uv.new_timer()
if timer then
  timer:start(
    1000, -- Start after 1 second
    1000, -- Repeat every 1 second
    vim.schedule_wrap(function()
      if vim.o.buftype ~= "nofile" then
        vim.cmd("checktime")
      end
    end)
  )
end
