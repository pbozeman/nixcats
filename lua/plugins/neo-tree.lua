-- neo-tree: file explorer
local ok, neo_tree = pcall(require, "neo-tree")
if not ok then
  return
end

neo_tree.setup({
  close_if_last_window = false,
  popup_border_style = "rounded",
  enable_git_status = true,
  enable_diagnostics = true,

  window = {
    position = "left",
    width = 30,
    mappings = {
      ["<space>"] = "none", -- disable space in neo-tree to avoid conflicts
      ["[b"] = "prev_source",
      ["]b"] = "next_source",
    },
  },

  filesystem = {
    follow_current_file = {
      enabled = true,
    },
    use_libuv_file_watcher = true,
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_by_name = {
        ".git",
        "node_modules",
      },
    },
  },
})

-- Keybindings
local util = require("util")

vim.keymap.set("n", "<leader>e", function()
  -- Check if neo-tree is currently visible
  local manager = require("neo-tree.sources.manager")
  local state = manager.get_state("filesystem")
  local window_exists = state.winid and vim.api.nvim_win_is_valid(state.winid)

  if window_exists then
    -- Close if already open
    require("neo-tree.command").execute({ action = "close" })
  else
    -- Open and reveal current file
    local reveal_file = vim.fn.expand("%:p")
    if reveal_file == "" then
      require("neo-tree.command").execute({ action = "focus", dir = util.get_root() })
    else
      require("neo-tree.command").execute({ action = "focus", reveal_file = reveal_file, reveal_force_cwd = true })
    end
  end
end, { desc = "Explorer NeoTree (Root Dir)" })
vim.keymap.set("n", "<leader>fe", function()
  local reveal_file = vim.fn.expand("%:p")
  if reveal_file == "" then
    require("neo-tree.command").execute({ toggle = true, dir = util.get_root() })
  else
    require("neo-tree.command").execute({ action = "focus", reveal_file = reveal_file, reveal_force_cwd = true })
  end
end, { desc = "Explorer NeoTree (Root Dir)" })
vim.keymap.set("n", "<leader>fE", function()
  require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
end, { desc = "Explorer NeoTree (cwd)" })
vim.keymap.set("n", "<leader>ge", function()
  require("neo-tree.command").execute({ source = "git_status", toggle = true })
end, { desc = "Git Explorer" })
vim.keymap.set("n", "<leader>be", function()
  require("neo-tree.command").execute({ source = "buffers", toggle = true })
end, { desc = "Buffer Explorer" })
