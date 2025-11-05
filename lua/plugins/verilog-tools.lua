-- Verilog/SystemVerilog utilities for wrapping code with lint/format directives

local M = {}

-- Custom quickfix text formatter for better alignment
function M.quickfix_format(info)
  local items = vim.fn.getqflist({ id = info.id, items = 0 }).items
  local lines = {}

  for i = info.start_idx, info.end_idx do
    local item = items[i]
    local fname = item.bufnr ~= 0 and vim.fn.bufname(item.bufnr) or ""
    local lnum = item.lnum
    local text = item.text

    -- Format: filename:line | text
    local line = string.format("%-40s|%-4d | %s", fname, lnum, text)
    table.insert(lines, line)
  end

  return lines
end

-- Set quickfix text function
vim.o.quickfixtextfunc = "{info -> v:lua.require'plugins.verilog-tools'.quickfix_format(info)}"

-- Center line after jumping to quickfix item
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  pattern = "[cl]*",
  callback = function()
    vim.cmd("normal! zz")
  end,
  desc = "Center line after quickfix navigation",
})

-- Center line after selecting from quickfix window (only if file changed)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function(args)
    vim.keymap.set("n", "<CR>", function()
      -- Get the quickfix item we're jumping to
      local qf_idx = vim.fn.line(".")
      local qf_item = vim.fn.getqflist()[qf_idx]
      local target_file = vim.fn.bufname(qf_item.bufnr)
      local current_file = vim.fn.expand("%:p")

      vim.cmd(".cc")

      -- Only center if we switched files
      if target_file ~= current_file then
        vim.cmd("normal! zz")
      end
    end, { buffer = args.buf, desc = "Jump to quickfix item and center" })
  end,
  desc = "Setup quickfix window keymaps",
})

-- Errorformat patterns for different tools
M.errorformats = {
  verilator = {
    "%E%%-Error-%\\w%\\+: %f:%l:%c: %m",
    "%W%%-Warning-%\\w%\\+: %f:%l:%c: %m",
    "%E%%Error-%\\w%\\+: %f:%l:%c: %m",
    "%W%%Warning-%\\w%\\+: %f:%l:%c: %m",
    "%Z%p^~%#",
    "%C%m",
    "%-G%.%#",
  },
  iverilog = {
    -- Standard iverilog format
    "%E%f:%l: error: %m",
    "%W%f:%l: warning: %m",
    "%I%f:%l: note: %m",
    -- Custom testbench format (ANSI codes stripped by makeprg)
    -- Capture the whole line including CHECK
    "%E./%f:%l %m",
    "%E%f:%l %m",
    -- Ignore FATAL and other lines
    "%-GFATAL%.%#",
    "%-G%.%#",
  },
  sby = {
    "%ESBX file not found",
    "%WSBX unknown result",
    "%E%f:%l: %m",
    "%-G%.%#",
  },
}

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

--- Detect tool from make target
---@param target string Make target name
---@return string Tool name (verilator, iverilog, or sby)
local function detect_tool(target)
  if target:match("^lint") or target:match("^format") then
    return "verilator"
  elseif target:match("^tb") or target:match("^sim") then
    return "iverilog"
  elseif target:match("^formal") or target:match("_f$") then
    return "sby"
  else
    -- Default to verilator for unknown targets
    return "verilator"
  end
end

--- Set errorformat and makeprg for a specific target
---@param target string Make target name (e.g., "lint", "tb", "formal")
function M.set_make(target)
  local tool = detect_tool(target)
  local formats = M.errorformats[tool] or M.errorformats.verilator
  vim.bo.errorformat = table.concat(formats, ",")

  -- For tb targets, create a wrapper script to strip ANSI codes
  if target:match("^tb") then
    local wrapper = vim.fn.tempname() .. ".sh"
    local script = string.format("#!/bin/sh\nmake %s 2>&1 | sed 's/\\x1b\\[[0-9;]*m//g'\n", target)
    vim.fn.writefile(vim.split(script, "\n"), wrapper)
    vim.fn.setfperm(wrapper, "rwxr-xr-x")
    vim.bo.makeprg = wrapper
  else
    vim.bo.makeprg = "make " .. target
  end
end

--- Run make with appropriate errorformat
---@param target string Make target name
function M.make(target)
  M.set_make(target)
  vim.cmd("make")
end

--- Run make in a terminal (for targets with colored output like testbenches)
---@param target string Make target name
function M.make_term(target)
  -- Open a terminal in a split and run make
  vim.cmd("split")
  vim.cmd("terminal make " .. target)
  vim.cmd("startinsert")
end

-- Setup keybindings for Verilog/SystemVerilog files
local function setup_keybindings(args)
  local bufnr = args.buf

  -- Create buffer-local Make command
  vim.api.nvim_buf_create_user_command(bufnr, "Make", function(opts)
    local target = opts.args ~= "" and opts.args or "lint"
    M.make(target)
  end, {
    nargs = "?",
    desc = "Run make with smart errorformat detection",
  })

  -- Make/build keymaps
  vim.keymap.set("n", "<leader>ml", function() M.make("lint") end,
    { desc = "Make lint", buffer = bufnr })
  vim.keymap.set("n", "<leader>mt", function() M.make("tb") end,
    { desc = "Make tb", buffer = bufnr })
  vim.keymap.set("n", "<leader>mT", function() M.make_term("tb") end,
    { desc = "Make tb (terminal)", buffer = bufnr })
  vim.keymap.set("n", "<leader>mf", function() M.make("formal") end,
    { desc = "Make formal", buffer = bufnr })
  vim.keymap.set("n", "<leader>mc", function() M.make("clean") end,
    { desc = "Make clean", buffer = bufnr })

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

  -- Add which-key groups if available
  local wk_ok, wk = pcall(require, "which-key")
  if wk_ok then
    wk.add({
      { "<leader>m", group = "make" },
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
