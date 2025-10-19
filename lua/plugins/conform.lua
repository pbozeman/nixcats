-- Formatter Configuration using conform.nvim

local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    -- Bash
    bash = { "shfmt" },
    sh = { "shfmt" },

    -- C/C++
    c = { "clang-format" },
    cpp = { "clang-format" },

    -- CMake
    cmake = { "cmake_format" },

    -- Go
    go = { "goimports-reviser", "gofumpt", "golines" },

    -- JavaScript/TypeScript
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },

    -- JSON
    json = { "prettier" },
    jsonc = { "prettier" },

    -- Lua
    lua = { "stylua" },

    -- Markdown & Quarto
    markdown = { "prettier", "markdownlint-cli2" },
    -- Quarto files - use prettier with markdown parser
    quarto = { "prettier", "markdownlint-cli2" },

    -- Nix
    nix = { "nixfmt" },

    -- Python
    python = { "isort", "black" },

    -- Rust
    rust = { "rustfmt" },

    -- TOML
    toml = { "taplo" },

    -- Web (HTML, CSS)
    html = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },

    -- YAML
    yaml = { "prettier" },

    -- Verilog/SystemVerilog
    verilog = { "verible" },
    systemverilog = { "verible" },
  },

  -- Format on save
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 2000,
    lsp_format = "fallback",
  },

  -- Customize formatters
  formatters = {
    shfmt = {
      prepend_args = { "-i", "2", "-ci" },
    },
    prettier = {
      -- Force markdown parser for quarto files
      prepend_args = function(self, ctx)
        if vim.bo[ctx.buf].filetype == "quarto" then
          return { "--parser", "markdown" }
        end
        return {}
      end,
    },
  },
})

-- Manual format keymap
vim.keymap.set({ "n", "v" }, "<leader>cf", function()
  conform.format({
    lsp_format = "fallback",
    timeout_ms = 2000,
  })
end, { desc = "Format" })

-- Format info keymap
vim.keymap.set("n", "<leader>ci", function()
  local formatters = conform.list_formatters(0)
  if #formatters == 0 then
    vim.notify("No formatters available for this buffer", vim.log.levels.INFO)
    return
  end

  local lines = { "Active formatters:" }
  for _, formatter in ipairs(formatters) do
    table.insert(lines, string.format("  • %s (%s)", formatter.name, formatter.available and "ready" or "not available"))
  end

  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end, { desc = "Formatter Info" })
