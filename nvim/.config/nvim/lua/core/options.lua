local o = vim.opt
local g = vim.g

g.mapleader = " "
g.maplocalleader = " "

g.have_nerd_font = true
o.updatetime = 1000

-- UI
o.number = true
o.relativenumber = true
o.signcolumn = "yes"
o.colorcolumn = "120"
o.cursorline = true
o.showmode = false
o.ruler = false
o.list = true
o.listchars = {
	tab = "→ ",
	trail = "·",
	nbsp = "␣",
}
o.winborder = "rounded"
o.pumborder = "rounded"
o.pumheight = 10
o.termguicolors = true

-- Windows
o.splitbelow = true
o.splitright = true
o.scrolloff = 10

-- Editing
o.clipboard = "unnamedplus"
o.startofline = false
o.wrap = false
o.undofile = true
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4
o.expandtab = true
o.autoindent = true
o.copyindent = true
o.breakindent = true

-- Search
o.hlsearch = true
o.ignorecase = true
o.smartcase = true
o.inccommand = "split"

-- Completion
o.completeopt = "menuone,noinsert,fuzzy,nearest,popup"
o.autocomplete = true
o.complete = "o,.,w,b,u"

-- Spell checking
o.spell = true
o.spelllang = "en_us"
o.spelloptions = "camel"

-- Opt-ins
vim.cmd("packadd nvim.undotree")
