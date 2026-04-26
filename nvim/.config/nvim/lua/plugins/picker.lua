vim.pack.add({
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
})

local picker = require("fzf-lua")
local picker_aug = vim.api.nvim_create_augroup("LspAttachPickerAug", { clear = true })
local function bind(fn, opts)
	return function()
		fn(opts or {})
	end
end

picker.setup({
	winopts = {
		border = "none",
		preview = {
			border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
		},
	},
	keymap = {
		builtin = {
			["<C-p>"] = "preview-page-up",
			["<C-n>"] = "preview-page-down",
			["<A-p>"] = "toggle-preview",
		},
	},
	fzf_opts = {
		["--info"] = "right",
	},
	grep = {
		hidden = true,
	},
})

picker.register_ui_select()

-- General file search
Keys.map_leader("n", "F", bind(picker.global), "Fuzzy search files, buffers, and symbols")
Keys.map_leader("n", "ff", bind(picker.files), "Fuzzy search files in cwd")
Keys.map_leader("n", "fG", bind(picker.grep), "Fuzzy search text via live grep")
Keys.map_leader("n", "fg", bind(picker.live_grep), "Fuzzy search text via live grep")
Keys.map_leader("n", "fr", bind(picker.resume), "Resume last fuzzy search")
Keys.map_leader("n", "fw", bind(picker.grep_cword), "Fuzzy search current word in project")
Keys.map_leader("n", "fW", bind(picker.grep_cWORD), "Fuzzy search current WORD in project")

-- Search history
Keys.map_leader("n", "hc", bind(picker.command_history), "Fuzzy search commands history")
Keys.map_leader("n", "hf", bind(picker.history), "Fuzzy search files and buffers history")
Keys.map_leader("n", "hs", bind(picker.search_history), "Fuzzy search history")

-- Search open buffers
Keys.map_leader("n", "<leader>", bind(picker.buffers, { sort_lastused = true }), "Fuzzy search active buffers")

-- Live grep in open files
Keys.map_leader("n", "f/", bind(picker.live_grep, { grep_open_files = true }), "Fuzzy search text in open files")

-- Editor and plugin
Keys.map_leader("n", "eb", bind(picker.builtin), "Search fzf-lua resume and builtins")
Keys.map_leader("n", "ec", bind(picker.files, { cwd = vim.fn.stdpath("config") }), "Fuzzy search Neovim config files")
Keys.map_leader("n", "eh", bind(picker.help_tags), "Fuzzy search help documentation")
Keys.map_leader("n", "ek", bind(picker.keymaps), "Fuzzy search keybindings")

-- Diagnostics
Keys.map_leader("n", "dd", bind(picker.diagnostics_document), "Fuzzy search document diagnostics")
Keys.map_leader("n", "dw", bind(picker.diagnostics_workspace), "Fuzzy search workspace diagnostics")

-- Fuzzily search in current buffer (replaces telescope /)
Keys.map_leader("n", "/", bind(picker.lgrep_curbuf), "Fuzzy search within current buffer")

-- Quickfix and Location
Keys.map_leader("n", "l", bind(picker.location), "Location list")
Keys.map_leader("n", "L", bind(picker.location_stack), "Location stack")
Keys.map_leader("n", "q", bind(picker.quickfix), "Quickfix list")
Keys.map_leader("n", "Q", bind(picker.quickfix_stack), "Quickfix stack")

-- Spell suggestions
Keys.map_leader("n", "=", bind(picker.spell_suggest), "Spell suggestions")

-- Git
Keys.map_leader("n", "gb", bind(picker.git_branches), "Git branches")
Keys.map_leader("n", "gC", bind(picker.git_bcommits), "Git buffer commits")
Keys.map_leader("n", "gc", bind(picker.git_commits), "Git commits")
Keys.map_leader("n", "gd", bind(picker.git_diff), "Git diff")
Keys.map_leader("n", "gf", bind(picker.git_files), "Git ls_files")
Keys.map_leader("n", "gm", bind(picker.git_blame), "Git blame")
Keys.map_leader("n", "gr", bind(picker.git_reflog), "Git reflog")
Keys.map_leader("n", "gs", bind(picker.git_status), "Git status")
Keys.map_leader("n", "gt", bind(picker.git_stash), "Git stash")
Keys.map_leader("n", "gw", bind(picker.git_worktrees), "Git worktrees")

-- Marks and jumps
Keys.map_leader("n", "j", bind(picker.jumps), "Jump list")
Keys.map_leader("n", "m", bind(picker.marks), "Marks")

-- Man pages
Keys.map_leader("n", "em", bind(picker.man_pages), "Search man pages")
Keys.map_leader("n", "eu", bind(picker.undotree), "Open the undo tree")

vim.api.nvim_create_autocmd("LspAttach", {
	group = picker_aug,
	callback = function(args)
		local buf = { buffer = args.buf }

		Keys.map_leader("n", "ra", bind(picker.lsp_code_actions), "Code actions", buf)
		Keys.map_leader("n", "ri", bind(picker.lsp_implementations), "Find implementations", buf)
		Keys.map_leader("n", "rn", vim.lsp.buf.rename, "Rename symbol", buf)
		Keys.map_leader("n", "rr", bind(picker.lsp_references), "Find references", buf)
		Keys.map_leader("n", "rd", bind(picker.lsp_definitions), "Go to definition", buf)
		Keys.map_leader("n", "rD", bind(picker.lsp_declarations), "Go to declaration", buf)
		Keys.map_leader("n", "rt", bind(picker.lsp_typedefs), "Find type definitions", buf)
		Keys.map_leader("n", "rO", bind(picker.lsp_document_symbols), "Find symbols in buffer", buf)
		Keys.map_leader("n", "rw", bind(picker.lsp_live_workspace_symbols), "Find symbols in workspace", buf)
		Keys.map_leader({ "n", "v" }, "rx", vim.lsp.codelens.run, "Run codelens", buf)
	end,
})
