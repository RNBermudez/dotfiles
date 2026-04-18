vim.pack.add({
	{ src = "https://github.com/mfussenegger/nvim-lint" },
})

local lint = require("lint")
local lint_aug = vim.api.nvim_create_augroup("LintAug", { clear = true })

lint.linters_by_ft = {
	bash = { "shellcheck" },
	go = { "staticcheck" },
	lua = { "selene" },
	sh = { "shellcheck" },
}

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
	group = lint_aug,
	callback = function()
		lint.try_lint()
	end,
	desc = "Run linter on buffer events",
})
