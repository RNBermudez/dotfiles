vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.files" },
})

local explorer = require("mini.files")

explorer.setup({
	mappings = {
		go_in = "L",
		go_in_plus = "l",
	},
	windows = {
		max_number = 3,
		preview = true,
	},
})

Keys.map_leader("n", "ee", function()
	explorer.open(vim.uv.cwd())
end, "Open mini.files in CWD")
