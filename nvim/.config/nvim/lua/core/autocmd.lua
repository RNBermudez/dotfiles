local general = vim.api.nvim_create_augroup("GeneralAug", { clear = true })

-- Close windows with <q>
vim.api.nvim_create_autocmd("FileType", {
	group = general,
	pattern = {
		"checkhealth",
		"git",
		"help",
		"lspinfo",
		"man",
		"nvim-pack",
		"nvim-undotree",
		"pager",
		"qf",
		"scratch",
		"vim",
	},
	callback = function(args)
		if args.match ~= "help" or not vim.bo[args.buf].modifiable then
			vim.keymap.set("n", "q", "<CMD>quit<CR>", { buffer = args.buf })
		end
	end,
	desc = "Close windows with <q>",
})

-- Open Help in a vertical window split
vim.api.nvim_create_autocmd("BufWinEnter", {
	group = general,
	callback = function(args)
		if vim.bo[args.buf].filetype == "help" then
			vim.cmd("wincmd L")
		end
	end,
	desc = "Open help in a vertical split",
})

-- Disable automatic comment on new lines
vim.api.nvim_create_autocmd("FileType", {
	group = general,
	callback = function()
		vim.opt.formatoptions:remove({ "o" })
	end,
	desc = "Disable comment leader on 'o'/'O' only",
})

-- foot.ini does not follow the default ini commentstring
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = general,
	pattern = "foot.ini",
	callback = function(args)
		vim.bo[args.buf].commentstring = "# %s"
		vim.bo[args.buf].comments = ":#"
	end,
	desc = "Set comment style for foot.ini",
})

-- Briefly highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = general,
	callback = function()
		vim.highlight.on_yank({ timeout = 350 })
	end,
	desc = "Highlight yanked text",
})

-- Wrap text filetypes
vim.api.nvim_create_autocmd("FileType", {
	group = general,
	pattern = {
		"text",
		"plaintex",
		"gitcommit",
		"markdown",
	},
	callback = function()
		vim.opt_local.wrap = true
	end,
	desc = "Enable line wrapping for text filetypes",
})
