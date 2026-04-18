local treesitter_update_aug = vim.api.nvim_create_augroup("TreesitterUpdate", { clear = true })
local treesitter_start_aug = vim.api.nvim_create_augroup("TreesitterStart", { clear = true })

vim.api.nvim_create_autocmd("PackChanged", {
	group = treesitter_update_aug,
	pattern = "nvim-treesitter",
	callback = function(args)
		local kind, name = args.data.kind, args.data.spec.name
		if kind == "install" or kind == "update" then
			vim.cmd.packadd({ args = { name }, bang = false })
			vim.cmd("TSUpdate")
		end
	end,
	desc = "Run TSUpdate after pack changed",
})

vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
})

local treesitter = require("nvim-treesitter")

-- https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md
local parsers = {
	"awk",
	"bash",
	"css",
	"desktop",
	"diff",
	"dockerfile",
	"editorconfig",
	"git_config",
	"git_rebase",
	"go",
	"gomod",
	"gowork",
	"gosum",
	"groovy",
	"helm",
	"html",
	"ini",
	"javascript",
	"jq",
	"jsdoc",
	"json",
	"json5",
	"lua",
	"luadoc",
	"luap",
	"markdown",
	"markdown_inline",
	"query",
	"regex",
	"terraform",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"xml",
	"yaml",
	"zsh",
}

treesitter.install(parsers)

vim.api.nvim_create_autocmd("FileType", {
	group = treesitter_start_aug,
	callback = function(args)
		local lang = vim.treesitter.language.get_lang(args.match)
		if lang and vim.tbl_contains(treesitter.get_installed(), lang) then
			vim.treesitter.start(args.buf)
		end
	end,
	desc = "Start treesitter highlighting for installed languages",
})
