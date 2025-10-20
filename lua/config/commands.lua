-- Redirect command output to a scratch buffer
local function capture_output(cmd)
  local output = vim.api.nvim_exec2(cmd, { output = true }).output
  local buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(output, "\n"))
  vim.api.nvim_set_current_buf(buf)
end

vim.api.nvim_create_user_command("Capture", function(opts)
  capture_output(opts.args)
end, { nargs = 1, complete = "command" })
