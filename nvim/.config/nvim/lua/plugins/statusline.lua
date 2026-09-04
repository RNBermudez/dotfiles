-- Based on: https://jacobnscott.com/posts/nvim-statusline/

local hl = {}

-- Indexing `hl` with a highlight group returns a function that applies that
-- highlight to some text within the statusline.
setmetatable(hl, {
	__index = function(_, group)
		return function(text)
			return "%#" .. group .. "#" .. text .. "%*"
		end
	end,
})

---@param group string
---@return vim.api.keyset.get_hl_info
local function get_hl(group)
	return vim.api.nvim_get_hl(0, { name = group, link = false, create = false })
end

local function set_hl_groups()
	local bg = get_hl("StatusLine").bg

	---@type table<string, vim.api.keyset.highlight>
	local groups = {
		StatusLineModeNormal = { fg = get_hl("Keyword").fg, bg = bg, bold = true },
		StatusLineModeInsert = { fg = get_hl("String").fg, bg = bg, bold = true },
		StatusLineModeVisual = { fg = get_hl("Special").fg, bg = bg, bold = true },
		StatusLineModeReplace = { fg = get_hl("Error").fg, bg = bg, bold = true },
		StatusLineModeCommand = { fg = get_hl("Number").fg, bg = bg, bold = true },
		StatusLineModePending = { fg = get_hl("Comment").fg, bg = bg, bold = true },
		StatusLineModeOther = { fg = get_hl("Comment").fg, bg = bg, bold = true },

		StatusLineDiagError = { fg = get_hl("DiagnosticError").fg, bg = bg },
		StatusLineDiagWarn = { fg = get_hl("DiagnosticWarn").fg, bg = bg },
		StatusLineDiagInfo = { fg = get_hl("DiagnosticInfo").fg, bg = bg },
		StatusLineDiagHint = { fg = get_hl("DiagnosticHint").fg, bg = bg },

		StatusLineGitBranch = { fg = get_hl("Identifier").fg, bg = bg },
		StatusLineGitAdd = { fg = get_hl("diffAdded").fg, bg = bg },
		StatusLineGitChange = { fg = get_hl("diffChanged").fg, bg = bg },
		StatusLineGitDelete = { fg = get_hl("diffRemoved").fg, bg = bg },

		StatusLineDim = { fg = get_hl("Comment").fg, bg = bg },
		StatusLineBold = { fg = get_hl("StatusLine").fg, bg = bg, bold = true },
	}

	for group, opts in pairs(groups) do
		vim.api.nvim_set_hl(0, group, opts)
	end
end

set_hl_groups()

-- Re-apply highlight groups on colorscheme change
vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("StatuslineColorsAug", { clear = true }),
	desc = "Re-apply statusline highlights on colorscheme change",
	callback = set_hl_groups,
})

-- Diagnostics are colored per-severity via vim.diagnostic's own status
-- formatter, so vim.diagnostic.status(0) returns formatted text.
vim.diagnostic.config({
	status = {
        -- stylua: ignore
        format = function(counts)
            local order = {
                { severity = vim.diagnostic.severity.ERROR, label = "E", group = "StatusLineDiagError" },
                { severity = vim.diagnostic.severity.WARN,  label = "W", group = "StatusLineDiagWarn" },
                { severity = vim.diagnostic.severity.INFO,  label = "I", group = "StatusLineDiagInfo" },
                { severity = vim.diagnostic.severity.HINT,  label = "H", group = "StatusLineDiagHint" },
            }

            local parts = {}
            for _, item in ipairs(order) do
                local count = counts[item.severity]
                if count then
                    table.insert(parts, hl[item.group](string.format("%s:%d", item.label, count)))
                end
            end

            return table.concat(parts, " ")
        end,
	},
})

-- Redraw the statusline whenever diagnostics change, so counts stay current.
vim.api.nvim_create_autocmd("DiagnosticChanged", {
	group = vim.api.nvim_create_augroup("StatuslineDiagnosticsAug", { clear = true }),
	callback = function()
		vim.cmd.redrawstatus()
	end,
	desc = "Redraw statusline when diagnostics change",
})

-- stylua: ignore start
local mode_settings = {
    ["c"]     = { name = "command",  hl = "Command" },
    ["ce"]    = { name = "ex",       hl = "Command" },
    ["cv"]    = { name = "ex",       hl = "Command" },
    ["t"]     = { name = "terminal", hl = "Command" },
    ["ic"]    = { name = "insert",   hl = "Insert" },
    ["i"]     = { name = "insert",   hl = "Insert" },
    ["ix"]    = { name = "insert",   hl = "Insert" },
    ["s"]     = { name = "select",   hl = "Insert" },
    ["r?"]    = { name = "confirm",  hl = "Normal" },
    ["rm"]    = { name = "more",     hl = "Normal" },
    ["niI"]   = { name = "normal",   hl = "Normal" },
    ["niR"]   = { name = "normal",   hl = "Normal" },
    ["niV"]   = { name = "normal",   hl = "Normal" },
    ["n"]     = { name = "normal",   hl = "Normal" },
    ["nt"]    = { name = "normal",   hl = "Normal" },
    ["ntT"]   = { name = "normal",   hl = "Normal" },
    ["r"]     = { name = "replace",  hl = "Normal" },
    ["\19"]   = { name = "s-block",  hl = "Normal" },
    ["!"]     = { name = "shell",    hl = "Normal" },
    ["S"]     = { name = "s-line",   hl = "Normal" },
    ["no\22"] = { name = "pending",  hl = "Pending" },
    ["no"]    = { name = "pending",  hl = "Pending" },
    ["nov"]   = { name = "pending",  hl = "Pending" },
    ["noV"]   = { name = "pending",  hl = "Pending" },
    ["Rc"]    = { name = "replace",  hl = "Replace" },
    ["R"]     = { name = "replace",  hl = "Replace" },
    ["Rx"]    = { name = "replace",  hl = "Replace" },
    ["Rvc"]   = { name = "v-replace",hl = "Replace" },
    ["Rv"]    = { name = "v-replace",hl = "Replace" },
    ["Rvx"]   = { name = "v-replace",hl = "Replace" },
    ["\22"]   = { name = "v-block",  hl = "Visual" },
    ["\22s"]  = { name = "v-block",  hl = "Visual" },
    ["v"]     = { name = "visual",   hl = "Visual" },
    ["vs"]    = { name = "visual",   hl = "Visual" },
    ["V"]     = { name = "v-line",   hl = "Visual" },
    ["Vs"]    = { name = "v-line",   hl = "Visual" },
}

-- Single-letter form shown when the window is narrower than `min_width`.
local mode_abbr = {
    normal        = "N",
    pending       = "P",
    visual        = "V",
    ["v-line"]    = "VL",
    ["v-block"]   = "VB",
    select        = "S",
    ["s-line"]    = "SL",
    ["s-block"]   = "SB",
    insert        = "I",
    replace       = "R",
    ["v-replace"] = "VR",
    command       = "C",
    ex            = "EX",
    more          = "M",
    confirm       = "?",
    shell         = "!",
    terminal      = "T",
}
-- stylua: ignore end

-- Entering Insert/Command/Replace forces a redraw as a side effect of other work.
-- Entering Visual/Select does not, so force it explicitly.
vim.api.nvim_create_autocmd("ModeChanged", {
	group = vim.api.nvim_create_augroup("StatuslineModeAug", { clear = true }),
	callback = function()
		vim.cmd.redrawstatus()
	end,
	desc = "Redraw statusline immediately on mode change",
})

-- Prevents overlapping git jobs for the same buffer if events fire in quick succession.
local git_pending = {}

---@param buf integer
local function refresh_git_status(buf)
	if git_pending[buf] then
		return
	end

	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end

	local path = vim.api.nvim_buf_get_name(buf)
	if path == "" then
		return
	end

	local root = vim.fs.root(path, ".git")
	if not root then
		vim.b[buf].git_status = nil
		return
	end

	git_pending[buf] = true

	-- Branch and status don't depend on each other, so both are fired at
	-- once and merged once both jobs land, rather than chaining them.
	local remaining_checks = 2
	local branch = nil
	local added, changed, removed = 0, 0, 0

	local function finish()
		remaining_checks = remaining_checks - 1
		if remaining_checks > 0 then
			return
		end

		git_pending[buf] = nil

		vim.schedule(function()
			if not vim.api.nvim_buf_is_valid(buf) then
				return
			end
			vim.b[buf].git_status = {
				branch = branch,
				added = added,
				changed = changed,
				removed = removed,
			}
			vim.cmd.redrawstatus()
		end)
	end

	vim.system({ "git", "-C", root, "branch", "--show-current" }, { text = true }, function(branch_result)
		local name = vim.trim(branch_result.stdout or "")
		branch = name ~= "" and name or nil
		finish()
	end)

	vim.system({ "git", "-C", root, "status", "--porcelain" }, { text = true }, function(status_result)
		if status_result.code == 0 then
			for line in (status_result.stdout or ""):gmatch("[^\n]+") do
				local x, y = line:sub(1, 1), line:sub(2, 2)
				if x == "?" then
					added = added + 1
				elseif x == "D" or y == "D" then
					removed = removed + 1
				elseif x == "A" or y == "A" then
					added = added + 1
				else
					changed = changed + 1
				end
			end
		end
		finish()
	end)
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "FocusGained", "DirChanged" }, {
	group = vim.api.nvim_create_augroup("StatuslineGitAug", { clear = true }),
	callback = function(args)
		refresh_git_status(args.buf)
	end,
	desc = "Refresh git branch/status for the statusline",
})

-- Force a redraw when LSP progress updates
vim.api.nvim_create_autocmd("LspProgress", {
	callback = function(ev)
		local value = ev.data.params.value
		local buf = ev.buf

		if value.kind == "end" then
			vim.b[buf].lsp_progress = nil
			vim.cmd.redrawstatus()
			return
		end

		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		local parts = {
			client and (client.name .. ":"),
			value.title,
			value.message,
			value.percentage and string.format("%d%%", value.percentage),
		}

		local clean = {}
		for _, p in ipairs(parts) do
			if p and p ~= "" then
				table.insert(clean, p)
			end
		end

		vim.b[buf].lsp_progress = table.concat(clean, " ")
		vim.cmd.redrawstatus()
	end,
})

---@param width integer
---@return fun(): boolean
local function visible_at(width)
	return function()
		return vim.fn.winwidth(0) > width
	end
end

local min_width = 80
local is_wide = visible_at(min_width)

-- Each component is a zero-arg function that returns a string (or nil/"" to be skipped).
---@type table<string, fun(): string?>
local components = {}

function components.mode()
	local settings = mode_settings[vim.api.nvim_get_mode().mode] or {}
	local name = settings.name or "unknown"
	local group = settings.hl or "Other"
	local text = is_wide() and name or (mode_abbr[name] or name)
	return hl["StatusLineMode" .. group](text)
end

function components.progress()
	local text = vim.b.lsp_progress
	return (text and text ~= "") and hl.StatusLineDim(text) or nil
end

function components.path()
	local buf_path = vim.api.nvim_buf_get_name(0)
	if buf_path == "" then
		return "[No Name]"
	end

	local tail = vim.fn.fnamemodify(buf_path, ":t")
	local head = vim.fn.fnamemodify(buf_path, ":~:h")

	local text = head == "." and tail or hl.StatusLineDim(head .. "/") .. tail

	if vim.bo.modified then
		text = text .. hl.StatusLineBold("*")
	end

	return text
end

local encoding_visible = visible_at(min_width)
function components.encoding()
	if not encoding_visible() then
		return nil
	end
	local enc = vim.bo.fileencoding
	if enc == "" then
		enc = vim.o.encoding
	end
	return enc ~= "" and hl.StatusLineDim(enc) or nil
end

local filetype_visible = visible_at(min_width)
function components.filetype()
	if not filetype_visible() then
		return nil
	end
	local ft = vim.bo.filetype
	return ft ~= "" and hl.StatusLineDim(ft) or nil
end

local fileformat_visible = visible_at(min_width)
function components.fileformat()
	if not fileformat_visible() then
		return nil
	end
	local ff = vim.bo.fileformat
	return ff ~= "" and hl.StatusLineDim(ff) or nil
end

function components.diagnostics()
	local text = vim.diagnostic.status(0)
	return text ~= "" and text or nil
end

function components.git()
	local status = vim.b.git_status
	if not status then
		return nil
	end

	local has_changes = status.added > 0 or status.changed > 0 or status.removed > 0
	if not status.branch and not has_changes then
		return nil
	end

	local parts = { hl.StatusLineGitBranch(status.branch or "(detached)") }

	if status.added > 0 then
		table.insert(parts, hl.StatusLineGitAdd("+" .. status.added))
	end
	if status.changed > 0 then
		table.insert(parts, hl.StatusLineGitChange("~" .. status.changed))
	end
	if status.removed > 0 then
		table.insert(parts, hl.StatusLineGitDelete("-" .. status.removed))
	end

	return table.concat(parts, " ")
end

function components.position()
	return "%3l:%-2c %3p%%"
end

-- "%=" is the built-in split point between the left- and right-aligned halves.
-- "%<" marks where Vim is allowed to start truncating.
local sections = {
	"mode",
	"%<",
	"path",
	"progress",
	"%=",
	"diagnostics",
	"git",
	"encoding",
	"fileformat",
	"filetype",
	"position",
}

---@param name string
---@return string?
local function render_section(name)
	if vim.startswith(name, "%") then
		return name
	end

	local component = components[name]
	if not component then
		return nil
	end

	return component()
end

---@return string
local function render()
	local parts = {}

	for _, name in ipairs(sections) do
		local text = render_section(name)
		if text and text ~= "" then
			table.insert(parts, text)
		end
	end

	return table.concat(parts, " ")
end

-- Called by vim.o.statusline in core/options.lua
return render
