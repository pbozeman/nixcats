-- Better yank/paste with history ring
local ok, yanky = pcall(require, "yanky")
if not ok then
  return
end

-- Setup yanky with highlight timer
yanky.setup({
  highlight = {
    timer = 150,
  },
})

-- Helper function for opening yank history picker
local function open_yank_history()
  -- Try snacks picker first, fallback to command
  local snacks_ok, snacks = pcall(require, "snacks")
  if snacks_ok and snacks.picker then
    snacks.picker.yanky()
  else
    vim.cmd([[YankyRingHistory]])
  end
end

-- Keymaps
local map = vim.keymap.set

-- Open yank history picker
map({ "n", "x" }, "<leader>p", open_yank_history, { desc = "Open Yank History" })

-- Enhanced yank (with highlighting)
map({ "n", "x" }, "y", "<Plug>(YankyYank)", { desc = "Yank Text" })

-- Enhanced put operations
map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", { desc = "Put Text After Cursor" })
map({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", { desc = "Put Text Before Cursor" })
map({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", { desc = "Put Text After Selection" })
map({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", { desc = "Put Text Before Selection" })

-- Cycle through yank history (after pasting)
map("n", "[y", "<Plug>(YankyCycleForward)", { desc = "Cycle Forward Through Yank History" })
map("n", "]y", "<Plug>(YankyCycleBackward)", { desc = "Cycle Backward Through Yank History" })

-- Put with auto-indent (linewise)
map("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)", { desc = "Put Indented After Cursor (Linewise)" })
map("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)", { desc = "Put Indented Before Cursor (Linewise)" })
map("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)", { desc = "Put Indented After Cursor (Linewise)" })
map("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)", { desc = "Put Indented Before Cursor (Linewise)" })

-- Put and indent
map("n", ">p", "<Plug>(YankyPutIndentAfterShiftRight)", { desc = "Put and Indent Right" })
map("n", "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", { desc = "Put and Indent Left" })
map("n", ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", { desc = "Put Before and Indent Right" })
map("n", "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", { desc = "Put Before and Indent Left" })

-- Put with filter
map("n", "=p", "<Plug>(YankyPutAfterFilter)", { desc = "Put After Applying a Filter" })
map("n", "=P", "<Plug>(YankyPutBeforeFilter)", { desc = "Put Before Applying a Filter" })
