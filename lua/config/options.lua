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
