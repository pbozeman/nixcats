-- Claude Helper: Integration with Claude Code in tmux
-- Provides keymaps to send diagnostics and code to Claude for help

-- Ask Claude about code/diagnostic (copy formatted prompt to clipboard)
local function ask_claude()
  local mode = vim.fn.mode()
  local filename = vim.fn.expand("%:.")
  local filetype = vim.bo.filetype
  local lines, start_line, end_line

  -- Exit visual mode first so marks are set
  if mode == "v" or mode == "V" or mode == "\22" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
  end

  -- Determine selection range
  if mode == "v" or mode == "V" or mode == "\22" then
    -- Visual mode: get selection from marks
    start_line = vim.fn.line("'<")
    end_line = vim.fn.line("'>")
  else
    -- Normal mode: get context around cursor
    local current_line = vim.fn.line(".")
    local context_lines = 5
    start_line = math.max(1, current_line - context_lines)
    end_line = math.min(vim.fn.line("$"), current_line + context_lines)
  end

  lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

  -- Mark cursor position in code block (non-visual mode only)
  if not (mode == "v" or mode == "V" or mode == "\22") then
    local cursor_line = vim.fn.line(".")
    local cursor_index = cursor_line - start_line + 1
    if cursor_index >= 1 and cursor_index <= #lines then
      lines[cursor_index] = lines[cursor_index] .. "  ← cursor"
    end
  end

  local code_block = table.concat(lines, "\n")

  -- Check for diagnostics in range
  local diagnostics = {}
  for line_num = start_line - 1, end_line - 1 do
    local line_diags = vim.diagnostic.get(0, { lnum = line_num })
    for _, diag in ipairs(line_diags) do
      table.insert(diagnostics, { line = line_num + 1, message = diag.message })
    end
  end

  -- Build prompt
  local prompt
  if #diagnostics > 0 then
    -- Has diagnostics
    local diag_text = {}
    for _, d in ipairs(diagnostics) do
      table.insert(diag_text, string.format("Line %d: %s", d.line, d.message))
    end

    local source_type, location_info
    if mode == "v" or mode == "V" or mode == "\22" then
      source_type = "[Visual selection with diagnostic]"
      location_info = string.format("%s (lines %d-%d)", filename, start_line, end_line)
    else
      source_type = "[Diagnostic at cursor]"
      location_info =
        string.format("%s (cursor at line %d, showing lines %d-%d)", filename, vim.fn.line("."), start_line, end_line)
    end

    prompt = string.format(
      "%s\n\n%d diagnostic%s in %s:\n\n%s\n\nCode:\n```%s\n%s\n```\n\n(If no additional input follows, please help fix this issue. Otherwise, ignore this default request and follow the user's question/comment below.)",
      source_type,
      #diagnostics,
      #diagnostics > 1 and "s" or "",
      location_info,
      table.concat(diag_text, "\n"),
      filetype,
      code_block
    )
  else
    -- No diagnostics
    local location_info
    local source_type
    if mode == "v" or mode == "V" or mode == "\22" then
      source_type = "[Visual selection]"
      location_info = string.format("%s (lines %d-%d)", filename, start_line, end_line)
    else
      source_type = "[Code at cursor]"
      location_info = string.format("%s (line %d, with context)", filename, vim.fn.line("."))
    end

    prompt = string.format(
      "%s\n\n%s:\n\n```%s\n%s\n```\n\n(If no additional input follows, please explain this code. Otherwise, ignore this default request and follow the user's question/comment below.)",
      source_type,
      location_info,
      filetype,
      code_block
    )
  end

  -- Copy to clipboard
  vim.fn.setreg("+", prompt)
  vim.notify(string.format("Copied %d chars to clipboard - paste in Claude window!", #prompt), vim.log.levels.INFO)
end

vim.keymap.set({ "n", "v" }, "<leader>cc", ask_claude, { desc = "Ask Claude About Code" })
