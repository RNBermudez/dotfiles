vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.ai" },
	{ src = "https://github.com/nvim-mini/mini.surround" },
})

require("mini.ai").setup()
require("mini.surround").setup()
