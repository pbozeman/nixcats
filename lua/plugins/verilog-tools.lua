-- Verilog/SystemVerilog utilities for wrapping code with lint/format directives

local M = {}

--- Get the indentation of a line
---@param lnum number Line number (1-indexed)
---@return string Indentation string (spaces/tabs)
local function get_indent(lnum)
  local line = vim.fn.getline(lnum)
  local indent = line:match("^%s*") or ""
  return indent
end

--- Wrap selection or current line with verilator lint directives
---@param rule string Verilator rule name (e.g., "UNUSEDSIGNAL")
function M.wrap_verilator_lint(rule)
  local mode = vim.fn.mode()
  local start_line, end_line

  if mode == "v" or mode == "V" or mode == "\22" then -- visual modes
    -- Get visual selection range
    vim.cmd('normal! \27') -- escape visual mode
    start_line = vim.fn.line("'<")
    end_line = vim.fn.line("'>")
  else
    -- Normal mode: use current line
    start_line = vim.fn.line(".")
    end_line = start_line
  end

  -- Get indentation from the first selected line
  local indent = get_indent(start_line)

  -- Insert lint_off directive above selection
  local off_directive = indent .. "// verilator lint_off: " .. rule
  vim.fn.append(start_line - 1, off_directive)

  -- Insert lint_on directive below selection (accounting for the line we just added)
  local on_directive = indent .. "// verilator lint_on: " .. rule
  vim.fn.append(end_line + 1, on_directive)

  -- Move cursor to the line after the off directive
  vim.fn.cursor(start_line + 1, 1)
end

--- Wrap selection or current line with verilog_format directives
function M.wrap_verilog_format()
  local mode = vim.fn.mode()
  local start_line, end_line

  if mode == "v" or mode == "V" or mode == "\22" then -- visual modes
    -- Get visual selection range
    vim.cmd('normal! \27') -- escape visual mode
    start_line = vim.fn.line("'<")
    end_line = vim.fn.line("'>")
  else
    -- Normal mode: use current line
    start_line = vim.fn.line(".")
    end_line = start_line
  end

  -- Get indentation from the first selected line
  local indent = get_indent(start_line)

  -- Insert format directives
  local off_directive = indent .. "// verilog_format: off"
  vim.fn.append(start_line - 1, off_directive)

  local on_directive = indent .. "// verilog_format: on"
  vim.fn.append(end_line + 1, on_directive)

  -- Move cursor to the line after the off directive
  vim.fn.cursor(start_line + 1, 1)
end

--- Insert a single-line verilator lint_off directive
---@param rule string Verilator rule name
function M.insert_verilator_lint_off(rule)
  local lnum = vim.fn.line(".")
  local indent = get_indent(lnum)
  local directive = indent .. "// verilator lint_off: " .. rule
  vim.fn.append(lnum - 1, directive)
  vim.fn.cursor(lnum + 1, 1)
end

--- Insert a single-line verilog_format: off directive
function M.insert_verilog_format_off()
  local lnum = vim.fn.line(".")
  local indent = get_indent(lnum)
  local directive = indent .. "// verilog_format: off"
  vim.fn.append(lnum - 1, directive)
  vim.fn.cursor(lnum + 1, 1)
end

--- Prompt for custom verilator rule and wrap
function M.wrap_verilator_custom()
  vim.ui.input({ prompt = "Verilator rule name: " }, function(rule)
    if rule and rule ~= "" then
      M.wrap_verilator_lint(rule)
    end
  end)
end

-- Setup keybindings for Verilog/SystemVerilog files
local function setup_keybindings(args)
  local bufnr = args.buf

  -- Set keymaps directly - flattened structure
  vim.keymap.set({ "n", "v" }, "<leader>vf", function() M.wrap_verilog_format() end,
    { desc = "Wrap verilog_format off/on", buffer = bufnr })

  -- Lint waivers
  vim.keymap.set({ "n", "v" }, "<leader>vu", function() M.wrap_verilator_lint("UNUSEDSIGNAL") end,
    { desc = "Waive UNUSEDSIGNAL", buffer = bufnr })
  vim.keymap.set({ "n", "v" }, "<leader>vd", function() M.wrap_verilator_lint("UNDRIVEN") end,
    { desc = "Waive UNDRIVEN", buffer = bufnr })
  vim.keymap.set({ "n", "v" }, "<leader>vp", function() M.wrap_verilator_lint("UNUSEDPARAM") end,
    { desc = "Waive UNUSEDPARAM", buffer = bufnr })
  vim.keymap.set({ "n", "v" }, "<leader>vb", function() M.wrap_verilator_lint("BLKSEQ") end,
    { desc = "Waive BLKSEQ", buffer = bufnr })
  vim.keymap.set({ "n", "v" }, "<leader>vw", function() M.wrap_verilator_lint("WIDTHCONCAT") end,
    { desc = "Waive WIDTHCONCAT", buffer = bufnr })
  vim.keymap.set({ "n", "v" }, "<leader>vm", function() M.wrap_verilator_lint("MULTIDRIVEN") end,
    { desc = "Waive MULTIDRIVEN", buffer = bufnr })
  vim.keymap.set({ "n", "v" }, "<leader>va", function() M.wrap_verilator_lint("ASSIGNIN") end,
    { desc = "Waive ASSIGNIN", buffer = bufnr })
  vim.keymap.set({ "n", "v" }, "<leader>vs", function() M.wrap_verilator_lint("SYNCASYNCNET") end,
    { desc = "Waive SYNCASYNCNET", buffer = bufnr })
  vim.keymap.set({ "n", "v" }, "<leader>vi", function() M.wrap_verilator_lint("PINMISSING") end,
    { desc = "Waive PINMISSING", buffer = bufnr })
  vim.keymap.set({ "n", "v" }, "<leader>vc", function() M.wrap_verilator_custom() end,
    { desc = "Waive custom rule", buffer = bufnr })

  -- Add which-key group if available
  local wk_ok, wk = pcall(require, "which-key")
  if wk_ok then
    wk.add({
      { "<leader>v", group = "verilog" },
    }, { buffer = bufnr })
  end
end

-- Auto-setup for Verilog/SystemVerilog files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "verilog", "systemverilog" },
  callback = setup_keybindings,
  desc = "Setup Verilog tools keybindings",
})

return M
