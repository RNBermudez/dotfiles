vim.filetype.add({
	extension = {
		env = "dotenv",
	},
	filename = {
		["env"] = "dotenv",
		[".env"] = "dotenv",
	},
	pattern = {
		["env%..*"] = "dotenv",
	},
})

-- Use bash treesitter highlighting for dotenv files without treating them as shell scripts.
-- Since the filetype is "dotenv" and not "sh"/"bash", BashLS and shfmt won't attach.
vim.treesitter.language.register("bash", "dotenv")

-- jsonc uses the json parser
vim.treesitter.language.register("json", "jsonc")
