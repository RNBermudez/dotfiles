vim.pack.add({
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
})

local mode_map = {
	["COMMAND"] = "C",
	["INSERT"] = "I",
	["NORMAL"] = "N",
	["REPLACE"] = "R",
	["SELECT"] = "S",
	["TERMINAL"] = "T",
	["V-BLOCK"] = "B",
	["VISUAL"] = "V",
	["V-LINE"] = "L",
}

local min_width = 80

local function visible_at(width)
	return function()
		return vim.fn.winwidth(0) > width
	end
end

local function format_mode(str)
	if vim.fn.winwidth(0) < min_width then
		return mode_map[str] or str
	end
	return str
end

local statusline = require("lualine")

statusline.setup({
	options = {
		globalstatus = true,
		section_separators = { left = "", right = "" },
		component_separators = { left = "", right = "" },
		always_divide_middle = true,
		theme = "auto",
	},
	sections = {
		lualine_a = {
			{
				"mode",
				fmt = format_mode,
			},
		},
		lualine_b = {
			{ "branch", icons_enabled = false },
			"diff",
			"diagnostics",
		},
		lualine_c = {
			{ "filename", path = 3 },
		},
		lualine_x = {
			{ "encoding", cond = visible_at(min_width) },
			{ "fileformat", cond = visible_at(min_width) },
			{ "filetype", cond = visible_at(min_width) },
		},
		lualine_y = {
			{ "progress", cond = visible_at(min_width) },
		},
		lualine_z = { "location" },
	},
})
