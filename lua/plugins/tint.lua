local ok, tint = pcall(require, "tint")
if not ok then
	return
end

tint.setup({
	-- Darken colors, use a positive value to brighten
	tint = -50,
	-- Saturation to preserve
	saturation = 0.6,
	-- Showing default behavior, but value here can be predefined set of transforms
	transforms = require("tint").transforms.SATURATE_TINT,
	-- Tint background portions of highlight groups
	tint_background_colors = false,
})

-- Tint all windows when Neovim loses focus
vim.api.nvim_create_autocmd("FocusLost", {
	callback = function()
		tint.tint(vim.api.nvim_get_current_win())
	end,
})

-- Untint current window when Neovim gains focus
vim.api.nvim_create_autocmd("FocusGained", {
	callback = function()
		tint.untint(vim.api.nvim_get_current_win())
	end,
})
