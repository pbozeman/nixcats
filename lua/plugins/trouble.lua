-- Trouble: Better diagnostics list and others
-- Shows a pretty list for diagnostics, references, quickfix, location list, etc.

local ok, trouble = pcall(require, "trouble")
if not ok then
  return
end

-- Enable trouble in lualine for statusline symbols
vim.g.trouble_lualine = true

-- Setup trouble
trouble.setup({
  modes = {
    lsp = {
      win = { position = "right" },
    },
  },
})

-- Keymaps
local map = vim.keymap.set

map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle focus=true<cr>", { desc = "Diagnostics (Trouble)" })
map(
  "n",
  "<leader>xX",
  "<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<cr>",
  { desc = "Buffer Diagnostics (Trouble)" }
)
map("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=true<cr>", { desc = "Symbols (Trouble)" })
map("n", "<leader>cS", "<cmd>Trouble lsp toggle focus=true<cr>", { desc = "LSP references/definitions/... (Trouble)" })
map("n", "<leader>xL", "<cmd>Trouble loclist toggle focus=true<cr>", { desc = "Location List (Trouble)" })
map("n", "<leader>xQ", "<cmd>Trouble qflist toggle focus=true<cr>", { desc = "Quickfix List (Trouble)" })

-- Navigate trouble items (or fallback to quickfix)
local repeat_jump = require("config.smart-repeat").make_repeatable_map(
  function()
    if trouble.is_open() then
      trouble.next({ skip_groups = true, jump = true })
    else
      local current_file = vim.fn.expand("%:p")
      -- Try cnext, wrap to first if at end
      local ok_cmd = pcall(vim.cmd.cnext)
      if not ok_cmd then
        pcall(vim.cmd.cfirst)
      end
      -- Only center if we switched files
      if current_file ~= vim.fn.expand("%:p") then
        vim.cmd("normal! zz")
      end
    end
  end,
  function()
    if trouble.is_open() then
      trouble.prev({ skip_groups = true, jump = true })
    else
      local current_file = vim.fn.expand("%:p")
      -- Try cprev, wrap to last if at beginning
      local ok_cmd = pcall(vim.cmd.cprev)
      if not ok_cmd then
        pcall(vim.cmd.clast)
      end
      -- Only center if we switched files
      if current_file ~= vim.fn.expand("%:p") then
        vim.cmd("normal! zz")
      end
    end
  end
)
map("n", "]q", repeat_jump("forward"), { desc = "Next Trouble/Quickfix Item" })
map("n", "[q", repeat_jump("backward"), { desc = "Previous Trouble/Quickfix Item" })
