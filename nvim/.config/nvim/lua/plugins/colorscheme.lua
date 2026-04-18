vim.pack.add({
	{ src = "https://github.com/folke/tokyonight.nvim" },
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

vim.cmd("colorscheme tokyonight")
