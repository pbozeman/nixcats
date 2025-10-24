-- blink.cmp - Fast completion engine
-- Based on LazyVim's blink extra

local blink = require("blink.cmp")

---@type blink.cmp.Config
local opts = {
  snippets = {
    preset = "default",
  },

  appearance = {
    use_nvim_cmp_as_default = false,
    nerd_font_variant = "mono",
  },

  completion = {
    accept = {
      auto_brackets = {
        enabled = true,
      },
    },
    menu = {
      auto_show = function()
        return vim.g.auto_completion_enabled ~= false
      end,
      draw = {
        treesitter = { "lsp" },
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
    },
    ghost_text = {
      enabled = true,
    },
  },

  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },

  keymap = {
    preset = "enter",
    ["<C-y>"] = { "select_and_accept" },
    ["<C-j>"] = { "select_next" },
    ["<C-k>"] = { "select_prev" },
  },
}

blink.setup(opts)
