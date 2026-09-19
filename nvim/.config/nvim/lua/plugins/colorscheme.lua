vim.pack.add({
	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/rose-pine/neovim" },
})

local tokyonight = require("tokyonight")

tokyonight.setup({
	style = "night",
	transparent = true,
	styles = {
		keywords = {
			italic = false,
		},
	},
})

local rose_pine = require("rose-pine")

rose_pine.setup({
	variant = "main",
	dim_inactive_windows = true,
	styles = {
		italic = false,
		transparency = true,
	},
	highlight_groups = {
		Visual = { bg = "foam", blend = 30 },
		StatusLineDim = { fg = "muted" },
		StatusLineModeCommand = { fg = "gold" },
		StatusLineModeReplace = { fg = "love" },
		StatusLineGitBranch = { fg = "iris" },
		StatusLineLspSpinner = { fg = "pine" },
	},
})

vim.cmd("colorscheme tokyonight")
-- vim.cmd("colorscheme rose-pine")
