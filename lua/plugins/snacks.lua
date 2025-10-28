-- Snacks.nvim - Collection of QoL plugins including a modern picker
local ok, snacks = pcall(require, "snacks")
if not ok then
  return
end

-- Setup snacks with picker and words enabled
snacks.setup({
  picker = {
    enabled = true,
    matcher = {
      frecency = true,
      cwd_bonus = true,
      history_bonus = true,
      sort_empty = true,
    },
  },
  words = {
    enabled = true,
  },
})

-- Keymaps
local map = vim.keymap.set

-- Quick access
map("n", "<leader><space>", function()
  snacks.picker.files()
end, { desc = "Find Files" })
map("n", "<leader>,", function()
  snacks.picker.buffers()
end, { desc = "Buffers" })
map("n", "<leader>/", function()
  snacks.picker.grep()
end, { desc = "Grep" })
map("n", "<leader>:", function()
  snacks.picker.command_history()
end, { desc = "Command History" })

-- Find files
map("n", "<leader>ff", function()
  snacks.picker.files()
end, { desc = "Find Files" })
map("n", "<leader>fr", function()
  snacks.picker.recent()
end, { desc = "Recent Files" })
map("n", "<leader>fb", function()
  snacks.picker.buffers()
end, { desc = "Buffers" })
map("n", "<leader>fg", function()
  snacks.picker.git_files()
end, { desc = "Git Files" })

-- Git
map("n", "<leader>gs", function()
  snacks.picker.git_status()
end, { desc = "Git Status" })
map("n", "<leader>gc", function()
  snacks.picker.git_log()
end, { desc = "Git Commits" })

-- Search
map("n", '<leader>s"', function()
  snacks.picker.registers()
end, { desc = "Registers" })
map("n", "<leader>sa", function()
  snacks.picker.autocmds()
end, { desc = "Autocmds" })
map("n", "<leader>sb", function()
  snacks.picker.lines()
end, { desc = "Buffer Lines" })
map("n", "<leader>sc", function()
  snacks.picker.command_history()
end, { desc = "Command History" })
map("n", "<leader>sC", function()
  snacks.picker.commands()
end, { desc = "Commands" })
map("n", "<leader>sd", function()
  snacks.picker.diagnostics()
end, { desc = "Diagnostics" })
map("n", "<leader>sg", function()
  snacks.picker.grep()
end, { desc = "Grep" })
map("n", "<leader>sh", function()
  snacks.picker.help()
end, { desc = "Help" })
map("n", "<leader>sH", function()
  snacks.picker.highlights()
end, { desc = "Highlights" })
map("n", "<leader>sj", function()
  snacks.picker.jumps()
end, { desc = "Jumps" })
map("n", "<leader>sk", function()
  snacks.picker.keymaps()
end, { desc = "Keymaps" })
map("n", "<leader>sl", function()
  snacks.picker.loclist()
end, { desc = "Location List" })
map("n", "<leader>sm", function()
  snacks.picker.marks()
end, { desc = "Marks" })
map("n", "<leader>sM", function()
  snacks.picker.man()
end, { desc = "Man Pages" })
map("n", "<leader>sq", function()
  snacks.picker.qflist()
end, { desc = "Quickfix List" })
map("n", "<leader>sR", function()
  snacks.picker.resume()
end, { desc = "Resume Last Picker" })
map("n", "<leader>sw", function()
  snacks.picker.grep_word()
end, { desc = "Word (Root)" })
map("n", "<leader>sW", function()
  snacks.picker.grep_word()
end, { desc = "WORD (Root)" })

-- LSP (will be available when in LSP buffers)
map("n", "gd", function()
  snacks.picker.lsp_definitions()
end, { desc = "Goto Definition" })
map("n", "gr", function()
  snacks.picker.lsp_references()
end, { desc = "References" })
map("n", "gI", function()
  snacks.picker.lsp_implementations()
end, { desc = "Goto Implementation" })
map("n", "gy", function()
  snacks.picker.lsp_type_definitions()
end, { desc = "Goto Type Definition" })
map("n", "<leader>ss", function()
  snacks.picker.lsp_symbols()
end, { desc = "LSP Symbols" })
map("n", "<leader>sS", function()
  snacks.picker.lsp_workspace_symbols()
end, { desc = "LSP Workspace Symbols" })

-- Navigate between word references (from snacks.words)
local repeat_jump = require("config.smart-repeat").make_repeatable_map(
  function()
    snacks.words.jump(vim.v.count1)
  end,
  function()
    snacks.words.jump(-vim.v.count1)
  end
)
map("n", "]r", repeat_jump("forward"), { desc = "Next Reference" })
map("n", "[r", repeat_jump("backward"), { desc = "Prev Reference" })
