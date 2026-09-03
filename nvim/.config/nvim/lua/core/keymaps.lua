_G.Keys = {}

--- Sets a keymap with `noremap` and `silent` enabled by default.
---
--- @param mode string|string[] Mode(s) in which the keymap applies (e.g. "n", {"n", "v"})
--- @param lhs string The key sequence to map (e.g. "K")
--- @param rhs function|string The command or function to execute
--- @param desc string Description shown in which-key and hover docs
--- @param opts vim.keymap.set.Opts? Optional override vim.keymap.set options
Keys.map = function(mode, lhs, rhs, desc, opts)
	vim.keymap.set(
		mode,
		lhs,
		rhs,
		vim.tbl_extend("force", { noremap = true, silent = true }, opts or {}, { desc = desc })
	)
end

--- Sets a keymap prefixed with <leader> and `noremap` and `silent` enabled by default.
---
--- @param mode string|string[] Mode(s) in which the keymap applies (e.g. "n", {"n", "v"})
--- @param lhs string The key sequence to map, without the leader prefix (e.g. "ff")
--- @param rhs function|string The command or function to execute
--- @param desc string Description shown in which-key and hover docs
--- @param opts vim.keymap.set.Opts? Optional additional vim.keymap.set options
Keys.map_leader = function(mode, lhs, rhs, desc, opts)
	Keys.map(mode, "<leader>" .. lhs, rhs, desc, opts or {})
end

-- Prevent <Space> from moving the cursor before it triggers <leader> mappings
Keys.map({ "n", "v" }, "<Space>", "<Nop>", "Disable Space")

-- Clear search highlights and dismiss any floating windows
Keys.map("n", "<Esc>", "<cmd>nohlsearch<CR>", "Clear search highlights")

-- Navigation
Keys.map("n", "<C-h>", "<C-w>h", "Move focus to the left window")
Keys.map("n", "<C-j>", "<C-w>j", "Move focus to the window below")
Keys.map("n", "<C-k>", "<C-w>k", "Move focus to the window above")
Keys.map("n", "<C-l>", "<C-w>l", "Move focus to the right window")
Keys.map_leader("n", "[", "^", "Go to the first non-blank character of the line")
Keys.map_leader("n", "]", "$", "Go to the end of line")

-- Editing
Keys.map("v", "<", "<gv", "Indent left and reselect")
Keys.map("v", ">", ">gv", "Indent right and reselect")
Keys.map("v", "J", ":m '>+1<CR>gv=gv", "Move selection down")
Keys.map("v", "K", ":m '<-2<CR>gv=gv", "Move selection up")

-- Buffers
Keys.map_leader("n", "<Tab>", "<C-^>", "Alternate between current and last buffer")
Keys.map_leader("n", "bc", "<cmd>bp | bd #<CR>", "Close current buffer")
Keys.map_leader("n", "bC", "<cmd>bp | bd! #<CR>", "Force close current buffer")

-- Toggles
Keys.map_leader("n", "td", function()
	local is_enabled = vim.diagnostic.is_enabled()
	vim.diagnostic.enable(not is_enabled)
	vim.notify("Diagnostics " .. (not is_enabled and "enabled" or "disabled"), vim.log.levels.INFO)
end, "Toggle diagnostics")
Keys.map_leader("n", "ti", function()
	local is_enabled = vim.lsp.inlay_hint.is_enabled()
	vim.lsp.inlay_hint.enable(not is_enabled)
	vim.notify("Inlay hints " .. (not is_enabled and "enabled" or "disabled"), vim.log.levels.INFO)
end, "Toggle inlay hints")
Keys.map_leader("n", "tl", function()
	local is_enabled = vim.lsp.codelens.is_enabled()
	vim.lsp.codelens.enable(not is_enabled)
	vim.notify("Codelens " .. (not is_enabled and "enabled" or "disabled"), vim.log.levels.INFO)
end, "Toggle codelens")
Keys.map_leader("n", "ts", function()
	local is_enabled = vim.o.spell
	vim.o.spell = not is_enabled
	vim.notify("Spell checking " .. (not is_enabled and "enabled" or "disabled"), vim.log.levels.INFO)
end, "Toggle spell checking")
Keys.map_leader("n", "tw", function()
	local is_enabled = vim.o.wrap
	vim.o.wrap = not is_enabled
	vim.notify("Line wrapping " .. (not is_enabled and "enabled" or "disabled"), vim.log.levels.INFO)
end, "Toggle line wrapping")

-- Editor / plugins
Keys.map_leader("n", "epu", vim.pack.update, "Update installed plugins")
Keys.map("i", "<CR>", function()
	if vim.fn.pumvisible() ~= 0 then
		return "<C-e><CR>"
	end
	return "<CR>"
end, "Override <CR> on completion menu to behave as regular Enter", { expr = true, replace_keycodes = true })
