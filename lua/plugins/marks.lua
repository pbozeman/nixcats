-- marks.nvim: Better user experience for viewing and interacting with Vim marks
-- See: https://github.com/chentoast/marks.nvim

local ok, marks = pcall(require, "marks")
if not ok then
  return
end

marks.setup({
  -- whether to map keybinds or not. default true
  default_mappings = false,
  -- which builtin marks to show. default {}
  -- builtin_marks = { ".", "<", ">", "^" },
  builtin_marks = {},
  -- whether movements cycle back to the beginning/end of buffer. default true
  cyclic = true,
  -- whether the shada file is updated after modifying uppercase marks. default false
  force_write_shada = false,
  -- how often (in ms) to redraw signs/recompute mark positions.
  -- higher values will have better performance but may cause visual lag,
  -- while lower values may cause performance penalties. default 150.
  refresh_interval = 250,
  -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
  -- marks, and bookmarks.
  -- can be either a table with all/none of the keys, or a single number, in which case
  -- the priority applies to all marks.
  -- default 10.
  sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
  -- disables mark tracking for specific filetypes. default {}
  excluded_filetypes = {},
  -- disables mark tracking for specific buftypes. default {}
  excluded_buftypes = {},
  mappings = {},
})

-- Create custom keymappings for regular marks only
vim.keymap.set("n", "m,", marks.set_next, { desc = "Set next available mark" })
vim.keymap.set("n", "m;", marks.toggle, { desc = "Toggle next available mark" })
vim.keymap.set("n", "m:", marks.preview, { desc = "Preview mark" })
vim.keymap.set("n", "m[", marks.prev, { desc = "Previous mark" })
vim.keymap.set("n", "m]", marks.next, { desc = "Next mark" })
vim.keymap.set("n", "dm-", marks.delete_line, { desc = "Delete marks on line" })
vim.keymap.set("n", "dm<space>", marks.delete_buf, { desc = "Delete marks in buffer" })

-- Register with which-key
local wk_ok, wk = pcall(require, "which-key")
if wk_ok then
  wk.add({
    { "dm", group = "marks", mode = "n" },
  })
end
