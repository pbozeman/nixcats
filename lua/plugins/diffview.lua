-- Diffview provides a big, side-by-side diff view
-- for seeing git changes clearly
local ok, diffview = pcall(require, "diffview")
if not ok then
  return
end

diffview.setup({
  diff_binaries = false,
  enhanced_diff_hl = true, -- Better word-level diff highlighting
  git_cmd = { "git" },
  hg_cmd = { "hg" },
  use_icons = true,
  show_help_hints = true,
  watch_index = true,
  icons = {
    folder_closed = "",
    folder_open = "",
  },
  signs = {
    fold_closed = "",
    fold_open = "",
    done = "✓",
  },
  view = {
    default = {
      layout = "diff2_horizontal",
      winbar_info = false,
    },
    merge_tool = {
      layout = "diff3_horizontal",
      disable_diagnostics = true,
      winbar_info = true,
    },
    file_history = {
      layout = "diff2_horizontal",
      winbar_info = false,
    },
  },
  file_panel = {
    listing_style = "tree",
    tree_options = {
      flatten_dirs = true,
      folder_statuses = "only_folded",
    },
    win_config = {
      position = "left",
      width = 35,
      win_opts = {},
    },
  },
  file_history_panel = {
    log_options = {
      git = {
        single_file = {
          diff_merges = "combined",
        },
        multi_file = {
          diff_merges = "first-parent",
        },
      },
    },
    win_config = {
      position = "bottom",
      height = 16,
      win_opts = {},
    },
  },
  commit_log_panel = {
    win_config = {
      win_opts = {},
    },
  },
  default_args = {
    DiffviewOpen = {},
    DiffviewFileHistory = {},
  },
  hooks = {},
  keymaps = {
    disable_defaults = false,
    view = {
      { "n", "<tab>", false },
      { "n", "<s-tab>", false },
      { "n", "gf", false },
      { "n", "<C-w><C-f>", false },
      { "n", "<C-w>gf", false },
      ["<leader>q"] = "<Cmd>DiffviewClose<CR>",
    },
    diff1 = {},
    diff2 = {},
    diff3 = {},
    diff4 = {},
    file_panel = {
      { "n", "j", false },
      { "n", "k", false },
      { "n", "<down>", false },
      { "n", "<up>", false },
      { "n", "<cr>", false },
      { "n", "o", false },
      { "n", "l", false },
      { "n", "<2-LeftMouse>", false },
      { "n", "-", false },
      { "n", "<s-tab>", false },
      { "n", "gf", false },
      { "n", "<C-w><C-f>", false },
      { "n", "<C-w>gf", false },
      { "n", "i", false },
      { "n", "f", false },
      { "n", "R", false },
      { "n", "L", false },
      ["<leader>q"] = "<Cmd>DiffviewClose<CR>",
    },
    file_history_panel = {
      { "n", "g!", false },
      { "n", "<C-A-d>", false },
      { "n", "y", false },
      { "n", "L", false },
      { "n", "zR", false },
      { "n", "zM", false },
      { "n", "j", false },
      { "n", "k", false },
      { "n", "<down>", false },
      { "n", "<up>", false },
      { "n", "<cr>", false },
      { "n", "o", false },
      { "n", "<2-LeftMouse>", false },
      { "n", "<c-b>", false },
      { "n", "<c-f>", false },
      { "n", "<tab>", false },
      { "n", "<s-tab>", false },
      { "n", "gf", false },
      { "n", "<C-w><C-f>", false },
      { "n", "<C-w>gf", false },
      ["<leader>q"] = "<Cmd>DiffviewClose<CR>",
    },
    option_panel = {
      { "n", "<tab>", false },
      { "n", "q", false },
      ["<leader>q"] = "<Cmd>DiffviewClose<CR>",
    },
    help_panel = {
      { "n", "q", false },
      ["<leader>q"] = "<Cmd>DiffviewClose<CR>",
    },
  },
})

-- Better diff colors - make changes more visible
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- Deleted lines/text - more prominent red
    vim.api.nvim_set_hl(0, "DiffDelete", { fg = "#bf616a", bg = "#3f2d32", bold = true })
    vim.api.nvim_set_hl(0, "DiffviewDiffDelete", { fg = "#bf616a", bg = "#3f2d32", bold = true })
    vim.api.nvim_set_hl(0, "DiffText", { bg = "#4a3f4a", bold = true }) -- Changed text within a line

    -- Added lines - more prominent green
    vim.api.nvim_set_hl(0, "DiffAdd", { fg = "#a3be8c", bg = "#2d3a2d", bold = true })
    vim.api.nvim_set_hl(0, "DiffviewDiffAdd", { fg = "#a3be8c", bg = "#2d3a2d", bold = true })

    -- Changed lines - more prominent
    vim.api.nvim_set_hl(0, "DiffChange", { bg = "#2d3243" })
  end,
})

-- Apply immediately
vim.cmd("doautocmd ColorScheme")

-- Keymaps for diffview
local map = vim.keymap.set
map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Diff View" })
map("n", "<leader>gD", "<cmd>DiffviewClose<cr>", { desc = "Diff View Close" })
map("n", "<leader>gH", "<cmd>DiffviewFileHistory<cr>", { desc = "File History" })
map("n", "<leader>gl", "<cmd>DiffviewFileHistory %<cr>", { desc = "Line History" })
