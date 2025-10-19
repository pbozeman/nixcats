-- Utility functions
local M = {}

--- Find the root directory by looking for .git directory
--- @param path string|nil Starting path (defaults to current buffer's directory)
--- @return string Root directory path
function M.get_root(path)
  path = path or vim.api.nvim_buf_get_name(0)

  -- If path is empty (e.g., for empty buffers), use cwd
  if path == "" then
    return vim.uv.cwd()
  end

  -- Get the directory of the file
  local file_dir = vim.fn.fnamemodify(path, ":p:h")

  -- Look for .git directory
  local git_dir = vim.fn.finddir(".git", file_dir .. ";")

  if git_dir ~= "" then
    -- Return the parent directory of .git
    return vim.fn.fnamemodify(git_dir, ":h")
  end

  -- Fall back to current working directory
  return vim.uv.cwd()
end

return M
