-- indent-blankline - show indent guides
require("ibl").setup({
  indent = {
    char = "│",
    tab_char = "│",
  },
  scope = {
    show_start = false,
    show_end = false,
    -- Disable scope since mini.indentscope handles it
    enabled = false,
  },
  exclude = {
    filetypes = {
      "Trouble",
      "help",
      "lazy",
      "mason",
      "neo-tree",
      "notify",
      "trouble",
    },
  },
})
