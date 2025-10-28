-- Smart repeat functionality for ]] and [[
-- Tracks the last jump type and allows repeating it
local M = {}

-- Track the last forward and backward jump functions
M.last_forward = nil
M.last_backward = nil

-- Wrapper function that tracks jumps
function M.make_repeatable_map(forward_fn, backward_fn)
  return function(direction)
    return function()
      if direction == "forward" then
        M.last_forward = forward_fn
        M.last_backward = backward_fn
        forward_fn()
      else
        M.last_forward = forward_fn
        M.last_backward = backward_fn
        backward_fn()
      end
    end
  end
end

-- Repeat last jump
function M.repeat_forward()
  if M.last_forward then
    M.last_forward()
  else
    vim.notify("No previous jump to repeat", vim.log.levels.WARN)
  end
end

function M.repeat_backward()
  if M.last_backward then
    M.last_backward()
  else
    vim.notify("No previous jump to repeat", vim.log.levels.WARN)
  end
end

-- Set up the ]] and [[ mappings
vim.keymap.set("n", "]]", M.repeat_forward, { desc = "Repeat Last Forward Jump" })
vim.keymap.set("n", "[[", M.repeat_backward, { desc = "Repeat Last Backward Jump" })

return M
