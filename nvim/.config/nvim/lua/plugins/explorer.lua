vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
})

local explorer = require("oil")

explorer.setup({
	columns = {
		"icon",
		"permissions",
		"size",
		"mtime",
	},
	keymaps = {
		["q"] = { "actions.close", mode = "n" },
		["<C-v>"] = { "actions.select", opts = { vertical = true } },
	},
	view_options = {
		show_hidden = true,
	},
	float = {
		border = "rounded",
	},
	preview_win = {
		border = "rounded",
	},
	confirmation = {
		border = "rounded",
	},
	progress = {
		border = "rounded",
	},
})

Keys.map_leader("n", "ee", "<CMD>Oil --float<CR>", "Open parent directory in Oil")
