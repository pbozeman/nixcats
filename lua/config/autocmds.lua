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

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("json_conceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})
-- Disable conceallevel for quarto files
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("quarto_conceal"),
  pattern = { "quarto" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Setup comment formatting for SystemVerilog
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("systemverilog_comments"),
  pattern = { "verilog", "systemverilog" },
  callback = function()
    -- Set comment string for commentstring (used by comment plugins)
    vim.opt_local.commentstring = "// %s"
    -- Configure comment formatting for gq
    vim.opt_local.comments = "://"
    -- Set textwidth for SystemVerilog files
    vim.opt_local.textwidth = 80
    -- Enable automatic comment formatting
    -- t = auto-wrap text using textwidth
    -- c = auto-wrap comments using textwidth
    -- q = allow formatting comments with gq
    vim.opt_local.formatoptions:append("tcq")
  end,
})

-- Disable LSP formatexpr for verible - use vim's built-in gq for text wrapping
-- Code formatting is already handled by conform.nvim
vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup("verible_no_formatexpr"),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.name == "verible" then
      vim.bo[ev.buf].formatexpr = ""
    end
  end,
})
