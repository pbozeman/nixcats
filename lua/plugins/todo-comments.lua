-- todo-comments: Highlight and search for TODO, FIXME, NOTE, etc.

local ok, todo_comments = pcall(require, "todo-comments")
if not ok then
  return
end

local snacks_ok, snacks = pcall(require, "snacks")

todo_comments.setup({
  signs = true, -- show icons in the signs column
  keywords = {
    FIX = {
      icon = " ", -- icon used for the sign, and in search results
      color = "error", -- can be a hex color, or a named color (see below)
      alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
    },
    TODO = { icon = " ", color = "info" },
    HACK = { icon = " ", color = "warning" },
    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
    PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
    NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
    TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
  },
  highlight = {
    multiline = true, -- enable multine todo comments
    multiline_pattern = "^.", -- lua pattern to match the next multiline from the start of the matched keyword
    multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
    before = "", -- "fg" or "bg" or empty
    keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty
    after = "fg", -- "fg" or "bg" or empty
    pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
    comments_only = true, -- uses treesitter to match keywords in comments only
    max_line_len = 400, -- ignore lines longer than this
    exclude = {}, -- list of file types to exclude highlighting
  },
})

-- Keymaps
local map = vim.keymap.set

-- Search todos with snacks picker
if snacks_ok then
  map("n", "<leader>st", function()
    snacks.picker.todo_comments()
  end, { desc = "Todo" })
  map("n", "<leader>sT", function()
    snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
  end, { desc = "Todo/Fix/Fixme" })
end

-- Trouble mappings
map("n", "<leader>xt", "<cmd>Trouble todo<cr>", { desc = "Todo (Trouble)" })
map("n", "<leader>xT", "<cmd>Trouble todo filter={tag={TODO,FIX,FIXME}}<cr>", { desc = "Todo/Fix/Fixme (Trouble)" })
map("n", "]t", function()
  require("todo-comments").jump_next()
end, { desc = "Next Todo Comment" })

map("n", "[t", function()
  require("todo-comments").jump_prev()
end, { desc = "Previous Todo Comment" })
