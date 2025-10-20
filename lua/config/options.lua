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

-- Clipboard
-- Use OSC 52 for consistent clipboard behavior locally and over SSH
opt.clipboard = ""

-- Don't show cmd line when not in use
opt.cmdheight = 0
