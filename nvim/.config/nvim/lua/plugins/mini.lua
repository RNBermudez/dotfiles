vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.ai" },
	{ src = "https://github.com/nvim-mini/mini.clue" },
	{ src = "https://github.com/nvim-mini/mini.surround" },
})

require("mini.ai").setup()
require("mini.surround").setup()

local miniclue = require("mini.clue")
miniclue.setup({
	triggers = {
		-- Leader triggers
		{ mode = { "n", "x" }, keys = "<Leader>" },

		-- `[` and `]` keys
		{ mode = "n", keys = "[" },
		{ mode = "n", keys = "]" },

		-- Built-in completion
		{ mode = "i", keys = "<C-x>" },

		-- `g` key
		{ mode = { "n", "x" }, keys = "g" },

		-- Marks
		{ mode = { "n", "x" }, keys = "'" },
		{ mode = { "n", "x" }, keys = "`" },

		-- Registers
		{ mode = { "n", "x" }, keys = '"' },
		{ mode = { "i", "c" }, keys = "<C-r>" },

		-- Window commands
		{ mode = "n", keys = "<C-w>" },

		-- `z` key
		{ mode = { "n", "x" }, keys = "z" },
	},

	clues = {
		{ mode = "n", keys = "<leader>b", desc = "+Buffers" },
		{ mode = "n", keys = "<leader>u", desc = "+Debug" },
		{ mode = "n", keys = "<leader>d", desc = "+Diagnostics" },
		{ mode = "n", keys = "<leader>e", desc = "+Editor" },
		{ mode = "n", keys = "<leader>f", desc = "+Files & Search" },
		{ mode = "n", keys = "<leader>g", desc = "+Git" },
		{ mode = "n", keys = "<leader>h", desc = "+History" },
		{ mode = "n", keys = "<leader>l", desc = "+Location" },
		{ mode = "n", keys = "<leader>r", desc = "+LSP" },
		{ mode = "n", keys = "<leader>m", desc = "+Marks" },
		{ mode = "n", keys = "<leader>q", desc = "+Quickfix" },
		{ mode = "n", keys = "<leader>t", desc = "+Toggles" },
		miniclue.gen_clues.builtin_completion(),
		miniclue.gen_clues.g(),
		miniclue.gen_clues.marks(),
		miniclue.gen_clues.registers(),
		miniclue.gen_clues.square_brackets(),
		miniclue.gen_clues.windows(),
		miniclue.gen_clues.z(),
	},

	window = {
		config = {
			width = "auto",
		},
	},
})
