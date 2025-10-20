-- Smartyank - smart clipboard handling with OSC 52 support

require("smartyank").setup({
  highlight = {
    -- already handled in autocmds
    enabled = false,
    higroup = "IncSearch",
    timeout = 200,
  },
  clipboard = {
    enabled = true,
  },
  tmux = {
    enabled = true,
    cmd = { "tmux", "set-buffer", "-w" },
  },
  osc52 = {
    enabled = true,
    ssh_only = true,
    silent = false,
    echo_hl = "Directory",
  },
})
