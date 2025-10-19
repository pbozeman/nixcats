-- fzf-lua: fuzzy finder
local ok, fzf = pcall(require, "fzf-lua")
if not ok then
	return
end

local actions = require("fzf-lua.actions")

fzf.setup({
	"default-title",
	fzf_colors = true,
	fzf_opts = {
		["--no-scrollbar"] = true,
	},
	defaults = {
		formatter = "path.filename_first",
	},
	winopts = {
		width = 0.8,
		height = 0.8,
		row = 0.5,
		col = 0.5,
		preview = {
			scrollchars = { "┃", "" },
		},
	},
	files = {
		cwd_prompt = false,
		actions = {
			["alt-i"] = { actions.toggle_ignore },
			["alt-h"] = { actions.toggle_hidden },
		},
	},
	grep = {
		actions = {
			["alt-i"] = { actions.toggle_ignore },
			["alt-h"] = { actions.toggle_hidden },
		},
	},
	lsp = {
		symbols = {
			symbol_hl = function(s)
				return "TroubleIcon" .. s
			end,
			symbol_fmt = function(s)
				return s:lower() .. "\t"
			end,
		},
	},
})

-- Keybindings

-- Find files
vim.keymap.set("n", "<leader><leader>", "<cmd>FzfLua files<cr>", { desc = "Find Files (Root)" })
vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Find Files (Root)" })
vim.keymap.set("n", "<leader>fF", "<cmd>FzfLua files cwd=false<cr>", { desc = "Find Files (cwd)" })

-- Grep
vim.keymap.set("n", "<leader>/", "<cmd>FzfLua live_grep<cr>", { desc = "Grep (Root)" })
vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>", { desc = "Grep (Root)" })
vim.keymap.set("n", "<leader>fG", "<cmd>FzfLua live_grep cwd=false<cr>", { desc = "Grep (cwd)" })
vim.keymap.set("n", "<leader>fw", "<cmd>FzfLua grep_cword<cr>", { desc = "Word (Root)" })
vim.keymap.set("n", "<leader>fW", "<cmd>FzfLua grep_cWORD<cr>", { desc = "WORD (Root)" })

-- Buffers
vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<cr>", { desc = "Buffers" })
vim.keymap.set("n", "<leader>,", "<cmd>FzfLua buffers<cr>", { desc = "Buffers" })

-- Recent files
vim.keymap.set("n", "<leader>fr", "<cmd>FzfLua oldfiles<cr>", { desc = "Recent" })

-- Git
vim.keymap.set("n", "<leader>gc", "<cmd>FzfLua git_commits<cr>", { desc = "Commits" })
vim.keymap.set("n", "<leader>gs", "<cmd>FzfLua git_status<cr>", { desc = "Status" })

-- Search
vim.keymap.set("n", '<leader>s"', "<cmd>FzfLua registers<cr>", { desc = "Registers" })
vim.keymap.set("n", "<leader>sa", "<cmd>FzfLua autocmds<cr>", { desc = "Auto Commands" })
vim.keymap.set("n", "<leader>sb", "<cmd>FzfLua grep_curbuf<cr>", { desc = "Buffer" })
vim.keymap.set("n", "<leader>sc", "<cmd>FzfLua command_history<cr>", { desc = "Command History" })
vim.keymap.set("n", "<leader>sC", "<cmd>FzfLua commands<cr>", { desc = "Commands" })
vim.keymap.set("n", "<leader>sd", "<cmd>FzfLua diagnostics_document<cr>", { desc = "Document Diagnostics" })
vim.keymap.set("n", "<leader>sD", "<cmd>FzfLua diagnostics_workspace<cr>", { desc = "Workspace Diagnostics" })
vim.keymap.set("n", "<leader>sh", "<cmd>FzfLua help_tags<cr>", { desc = "Help Pages" })
vim.keymap.set("n", "<leader>sH", "<cmd>FzfLua highlights<cr>", { desc = "Search Highlight Groups" })
vim.keymap.set("n", "<leader>sj", "<cmd>FzfLua jumps<cr>", { desc = "Jumplist" })
vim.keymap.set("n", "<leader>sk", "<cmd>FzfLua keymaps<cr>", { desc = "Key Maps" })
vim.keymap.set("n", "<leader>sl", "<cmd>FzfLua loclist<cr>", { desc = "Location List" })
vim.keymap.set("n", "<leader>sM", "<cmd>FzfLua man_pages<cr>", { desc = "Man Pages" })
vim.keymap.set("n", "<leader>sm", "<cmd>FzfLua marks<cr>", { desc = "Jump to Mark" })
vim.keymap.set("n", "<leader>sR", "<cmd>FzfLua resume<cr>", { desc = "Resume" })
vim.keymap.set("n", "<leader>sq", "<cmd>FzfLua quickfix<cr>", { desc = "Quickfix List" })
vim.keymap.set("n", "<leader>sw", "<cmd>FzfLua grep_cword<cr>", { desc = "Word (Root)" })
vim.keymap.set("n", "<leader>sW", "<cmd>FzfLua grep_cWORD<cr>", { desc = "WORD (Root)" })

-- LSP
vim.keymap.set("n", "gd", "<cmd>FzfLua lsp_definitions<cr>", { desc = "Goto Definition" })
vim.keymap.set("n", "gr", "<cmd>FzfLua lsp_references<cr>", { desc = "References" })
vim.keymap.set("n", "gI", "<cmd>FzfLua lsp_implementations<cr>", { desc = "Goto Implementation" })
vim.keymap.set("n", "gy", "<cmd>FzfLua lsp_typedefs<cr>", { desc = "Goto Type Definition" })
vim.keymap.set("n", "<leader>ss", "<cmd>FzfLua lsp_document_symbols<cr>", { desc = "Document Symbols" })
vim.keymap.set("n", "<leader>sS", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", { desc = "Workspace Symbols" })
