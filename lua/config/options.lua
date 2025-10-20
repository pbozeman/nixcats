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
