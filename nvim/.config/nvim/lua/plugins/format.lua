vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" },
})

local format = require("conform")
local settings = {
	lsp_format = "fallback",
	async = false,
	timeout_ms = 500,
}

-- https://github.com/stevearc/conform.nvim#formatters
local formatters_by_filetype = {
	bash = { "shfmt" },
	css = { "prettierd" },
	go = { "gofumpt" },
	jsonc = { "prettierd" },
	json = { "prettierd" },
	lua = { "stylua" },
	markdown = { "prettierd" },
	sh = { "shfmt" },
	toml = { "taplo" },
	yaml = { "prettierd" },
	zsh = { "shfmt" },
	["_"] = { "trim_whitespace" },
}

format.setup({
	formatters_by_ft = formatters_by_filetype,
	format_on_save = settings,
	notify_on_error = true,
})

Keys.map_leader({ "n", "v" }, "ef", function()
	format.format(settings)
end, "Format the document")
