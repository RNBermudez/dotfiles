---@type vim.lsp.Config
return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = {
		".luarc.json",
		".luarc.jsonc",
		".luacheckrc",
		".stylua.toml",
		"stylua.toml",
		"selene.toml",
		"selene.yml",
		".git",
	},
	settings = {
		-- https://luals.github.io/wiki/settings/
		Lua = {
			codeLens = {
				enable = true,
			},
			completion = {
				callSnippet = "Replace",
				keywordSnippet = "Replace",
			},
			hint = {
				enable = true,
				arrayIndex = true,
			},
			telemetry = {
				enable = false,
			},
			runtime = {
				version = "LuaJIT",
			},
		},
	},
	single_file_support = true,
	log_level = vim.lsp.protocol.MessageType.Warning,
}
