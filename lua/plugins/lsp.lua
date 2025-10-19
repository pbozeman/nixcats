-- LSP Configuration

-- Diagnostic icons (using Nerd Font icons)
local signs = {
  Error = "󰅚 ",
  Warn = "󰀪 ",
  Hint = "󰌶 ",
  Info = " ",
}

-- Configure diagnostics (based on LazyVim)
vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●",
  },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = signs.Error,
      [vim.diagnostic.severity.WARN] = signs.Warn,
      [vim.diagnostic.severity.HINT] = signs.Hint,
      [vim.diagnostic.severity.INFO] = signs.Info,
    },
  },
})

-- Setup Nix LSP using new vim.lsp.config API
vim.lsp.config('nil_ls', {
  cmd = { 'nil' },
  filetypes = { 'nix' },
  root_markers = { 'flake.nix', '.git' },
  capabilities = {
    workspace = {
      fileOperations = {
        didRename = true,
        willRename = true,
      },
    },
  },
})

vim.lsp.enable('nil_ls')

-- Enable inlay hints by default
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('LspInlayHints', {}),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.supports_method('textDocument/inlayHint') then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
  end,
})

-- LSP Keymaps (based on LazyVim approach)
local M = {}

-- Check if LSP client supports a specific method
function M.has(buffer, method)
  if type(method) == "table" then
    for _, m in ipairs(method) do
      if M.has(buffer, m) then
        return true
      end
    end
    return false
  end

  method = method:find("/") and method or "textDocument/" .. method
  local clients = vim.lsp.get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    if client.supports_method(method) then
      return true
    end
  end
  return false
end

-- Get all LSP keymaps
function M.get_keymaps()
  return {
    { "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
    { "gr", vim.lsp.buf.references, desc = "References", has = "references" },
    { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation", has = "implementation" },
    { "gy", vim.lsp.buf.type_definition, desc = "Goto Type Definition", has = "typeDefinition" },
    { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration", has = "declaration" },
    { "K", vim.lsp.buf.hover, desc = "Hover", has = "hover" },
    { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
    { "<c-k>", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp", mode = "i" },
    { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "codeAction" },
    { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
  }
end

-- LSP keymaps (only set when LSP attaches)
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local buffer = ev.buf

    for _, keymap in ipairs(M.get_keymaps()) do
      local opts = { buffer = buffer, desc = keymap.desc }
      local mode = keymap.mode or "n"

      -- Only set keymap if LSP supports the method
      if not keymap.has or M.has(buffer, keymap.has) then
        vim.keymap.set(mode, keymap[1], keymap[2], opts)
      end
    end
  end,
})

-- Diagnostic keymaps (global, not buffer-specific)
vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next Diagnostic' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Prev Diagnostic' })
vim.keymap.set('n', ']e', function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, { desc = 'Next Error' })
vim.keymap.set('n', '[e', function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, { desc = 'Prev Error' })
vim.keymap.set('n', ']w', function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN }) end, { desc = 'Next Warning' })
vim.keymap.set('n', '[w', function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN }) end, { desc = 'Prev Warning' })
