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
map("n", "[q", function()
  if trouble.is_open() then
    trouble.prev({ skip_groups = true, jump = true })
  else
    local ok_cmd, err = pcall(vim.cmd.cprev)
    if not ok_cmd then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end
end, { desc = "Previous Trouble/Quickfix Item" })

map("n", "]q", function()
  if trouble.is_open() then
    trouble.next({ skip_groups = true, jump = true })
  else
    local ok_cmd, err = pcall(vim.cmd.cnext)
    if not ok_cmd then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end
end, { desc = "Next Trouble/Quickfix Item" })
