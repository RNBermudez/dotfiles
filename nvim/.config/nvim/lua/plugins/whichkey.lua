vim.pack.add({
	{ src = "https://github.com/folke/which-key.nvim" },
})
local whichkey = require("which-key")

whichkey.setup({
	preset = "helix",
	delay = function(ctx)
		if ctx.plugin then
			return 50
		end
		return 1000
	end,
	win = {
		border = "rounded",
		padding = { 1, 1 },
	},
	icons = {
		separator = "",
	},
})

whichkey.add({
	{ "<leader>f", group = "Files & Search" },
	{ "<leader>e", group = "Editor" },
	{ "<leader>r", group = "LSP" },
	{ "<leader>g", group = "Git" },
	{ "<leader>d", group = "Diagnostics" },
	{ "<leader>u", group = "Debug" },
	{ "<leader>t", group = "Toggles" },
	{ "<leader>b", group = "Buffers" },
	{ "<leader>q", group = "Quickfix" },
	{ "<leader>l", group = "Location" },
	{ "<leader>m", group = "Marks" },
})

Keys.map_leader("n", "?", function()
	require("which-key").show()
end, "Buffer Local Keymaps (which-key)")
