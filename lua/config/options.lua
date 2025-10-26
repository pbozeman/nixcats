-- General options

-- Leader keys (must be set before plugins load)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = false

-- Highlight current line
opt.cursorline = true

-- Don't show cmd line when not in use
opt.cmdheight = 0

-- Auto-reload files when changed outside Neovim
opt.autoread = true

-- Indentation
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = 2 -- Size of an indent
opt.tabstop = 2 -- Number of spaces tabs count for
opt.smartindent = true -- Insert indents automatically
opt.shiftround = true -- Round indent

-- Concealment
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions

-- Spell checking
opt.spell = true
opt.spelllang = { "en_us" }
opt.spellfile = vim.fn.stdpath("data") .. "/spell/en.utf-8.add"

-- Clipboard integration with system clipboard
opt.clipboard = "unnamedplus"

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.grepprg = "rg --vimgrep"
opt.grepformat = "%f:%l:%c:%m"

-- Disable startup screen
opt.shortmess:append("I")

-- Load cfilter plugin for quickfix filtering
vim.cmd("packadd cfilter")
