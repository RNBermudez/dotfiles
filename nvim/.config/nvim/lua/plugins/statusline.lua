-- This file must be sourced after the colorscheme since `set_hl_groups()`
-- reads colors from existing highlight groups at load time.
--
-- Based on: https://jacobnscott.com/posts/nvim-statusline/
-- and https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/statusline.lua

--- Width threshold in columns that control which components are rendered
--- `min_window_width` hides components at this threshold
--- `path_full_width` and `path_relative_width` control how much of the buffer's path is shown
local min_window_width = 80
local path_full_width = 120
local path_relative_width = 90
local spinner_interval_ms = 100

local hl = {}

-- Indexing `hl` with a highlight group returns a function that applies that
-- highlight to some text within the statusline.
setmetatable(hl, {
	__index = function(t, group)
		local fn = function(text)
			return "%#" .. group .. "#" .. text .. "%*"
		end
		rawset(t, group, fn)
		return fn
	end,
})

---@param group string
---@return vim.api.keyset.get_hl_info
local function get_hl(group)
	return vim.api.nvim_get_hl(0, { name = group, create = false })
end

local function set_hl_groups()
	local statusline_bg = get_hl("StatusLine").bg

-- stylua: ignore start
    --- Allows highlight groups override from colorscheme config with a fallback
	---@type table<string, vim.api.keyset.highlight>
	local groups = {
		StatusLineModeNormal = {
			fg = get_hl("StatusLineModeNormal").fg or get_hl("MiniStatuslineModeNormal").bg or get_hl("Function").fg,
			bg = get_hl("StatusLineModeNormal").bg or statusline_bg,
			bold = true,
		},
		StatusLineModeInsert = {
			fg = get_hl("StatusLineModeInsert").fg or get_hl("MiniStatuslineModeInsert").bg or get_hl("String").fg,
			bg = get_hl("StatusLineModeInsert").bg or statusline_bg,
			bold = true,
		},
		StatusLineModeVisual = {
			fg = get_hl("StatusLineModeVisual").fg or get_hl("MiniStatuslineModeVisual").bg or get_hl("Constant").fg,
			bg = get_hl("StatusLineModeVisual").bg or statusline_bg,
			bold = true,
		},
		StatusLineModeReplace = {
			fg = get_hl("StatusLineModeReplace").fg or get_hl("MiniStatuslineModeReplace").bg or get_hl( "Error").fg,
			bg = get_hl("StatusLineModeReplace").bg or statusline_bg,
			bold = true,
		},
		StatusLineModeCommand = {
			fg = get_hl("StatusLineModeCommand").fg or get_hl("MiniStatuslineModeCommand").bg or get_hl( "Number").fg,
			bg = get_hl("StatusLineModeCommand").bg or statusline_bg,
			bold = true,
		},
		StatusLineModePending = {
			fg = get_hl("StatusLineModePending").fg or get_hl("MiniStatuslineModeOther").bg or get_hl("Comment").fg,
			bg = get_hl("StatusLineModePending").bg or statusline_bg,
			bold = true,
		},
		StatusLineModeOther = {
			fg = get_hl("StatusLineModeOther").fg or get_hl("MiniStatuslineModeOther").bg or get_hl("Comment").fg,
            bg = get_hl("StatusLineModeOther").bg or statusline_bg,
			bold = true,
		},

		StatusLineDiagError = {
			fg = get_hl("StatusLineDiagError").fg or get_hl("DiagnosticError").fg,
			bg = get_hl("StatusLineDiagError").bg or statusline_bg,
		},
		StatusLineDiagWarn = {
			fg = get_hl("StatusLineDiagWarn").fg or get_hl("DiagnosticWarn").fg,
			bg = get_hl("StatusLineDiagWarn").bg or statusline_bg,
		},
		StatusLineDiagInfo = {
			fg = get_hl("StatusLineDiagInfo").fg or get_hl("DiagnosticInfo").fg,
			bg = get_hl("StatusLineDiagInfo").bg or statusline_bg,
		},
		StatusLineDiagHint = {
			fg = get_hl("StatusLineDiagHint").fg or get_hl("DiagnosticHint").fg,
			bg = get_hl("StatusLineDiagHint").bg or statusline_bg,
		},

		StatusLineGitBranch = {
			fg = get_hl("StatusLineGitBranch").fg or get_hl("Identifier").fg,
			bg = get_hl("StatusLineGitBranch").bg or statusline_bg,
		},
		StatusLineGitAdd = {
			fg = get_hl("StatusLineGitAdd").fg or get_hl("Added").fg or get_hl("DiffAdd").bg,
			bg = get_hl("StatusLineGitAdd").bg or statusline_bg,
		},
		StatusLineGitChange = {
			fg = get_hl("StatusLineGitChange").fg or get_hl("Changed").fg or get_hl("DiffChange").bg,
			bg = get_hl("StatusLineGitChange").bg or statusline_bg,
		},
		StatusLineGitDelete = {
			fg = get_hl("StatusLineGitDelete").fg or get_hl("Removed").fg or get_hl("DiffDelete").bg,
			bg = get_hl("StatusLineGitDelete").bg or statusline_bg,
		},

		StatusLineDim = {
			fg = get_hl("StatusLineDim").fg or get_hl("Comment").fg,
			bg = get_hl("StatusLineDim").bg or statusline_bg,
		},
		StatusLineBold = {
			fg = get_hl("StatusLineBold").fg or get_hl("StatusLine").fg,
			bg = get_hl("StatusLineBold").bg or statusline_bg,
			bold = true,
		},
		StatusLinePath = {
		    fg = get_hl("StatusLinePath").fg or get_hl("StatusLine").fg,
		    bg = get_hl("StatusLinePath").bg or statusline_bg,
        },
		StatusLinePosition = {
		    fg = get_hl("StatusLinePosition").fg or get_hl("StatusLine").fg,
		    bg = get_hl("StatusLinePosition").bg or statusline_bg,
         },
		StatusLineLspSpinner = {
		    fg = get_hl("StatusLineLspSpinner").fg or get_hl("StatusLine").fg,
		    bg = get_hl("StatusLineLspSpinner").bg or statusline_bg,
         },
	}
	-- stylua: ignore end

	for group, opts in pairs(groups) do
		vim.api.nvim_set_hl(0, group, opts)
	end
end

set_hl_groups()

-- Re-apply highlight groups on colorscheme change
vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("StatusLineColorsAug", { clear = true }),
	desc = "Re-apply statusline highlights on colorscheme change",
	callback = set_hl_groups,
})

-- Force statusline redraw for immediate state changes (buffer switch,
-- diagnostics, modes, LSP attach/detach)
vim.api.nvim_create_autocmd({
	"BufEnter",
	"BufLeave",
	"BufWinEnter",
	"DiagnosticChanged",
	"ModeChanged",
	"LspAttach",
	"LspDetach",
}, {
	group = vim.api.nvim_create_augroup("StatusLineRedrawAug", { clear = true }),
	callback = function()
		vim.schedule(function()
			vim.cmd.redrawstatus()
		end)
	end,
	desc = "Redraw statusline on state changes",
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

-- stylua: ignore start
---@type table<string, {name: string, hl: string}>
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
---@type table<string, string>
local mode_abbr = {
    normal        = " N",
    pending       = " P",
    visual        = " V",
    ["v-line"]    = "VL",
    ["v-block"]   = "VB",
    select        = " S",
    ["s-line"]    = "SL",
    ["s-block"]   = "SB",
    insert        = " I",
    replace       = " R",
    ["v-replace"] = "VR",
    command       = " C",
    ex            = "EX",
    more          = " M",
    confirm       = " ?",
    shell         = " !",
    terminal      = " T",
}
-- stylua: ignore end

---@type table<integer, boolean>
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

	local branch = nil
	local added, changed, removed = 0, 0, 0

	local function finish()
		git_pending[buf] = nil

		vim.schedule(function()
			if not vim.api.nvim_buf_is_valid(buf) then
				return
			end
			if vim.api.nvim_buf_get_name(buf) ~= path then
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

	local ok_status = pcall(
		vim.system,
		{ "git", "-C", root, "status", "--porcelain=v2", "--branch" },
		{ text = true },
		function(result)
			if result.code == 0 then
				for line in (result.stdout or ""):gmatch("[^\n]+") do
					local kind = line:sub(1, 1)
					if kind == "#" then
						local head = line:match("^# branch%.head (.+)$")
						if head then
							branch = (head ~= "(detached)") and head or nil
						end
					elseif kind == "?" then
						added = added + 1
					elseif kind == "1" or kind == "2" or kind == "u" then
						local xy = line:match("^[12u] (%S%S)")
						if xy then
							if xy:find("D", 1, true) then
								removed = removed + 1
							elseif xy:find("A", 1, true) then
								added = added + 1
							else
								changed = changed + 1
							end
						end
					end
				end
			end
			finish()
		end
	)
	if not ok_status then
		finish()
	end
end

-- Refresh git status
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "FocusGained", "DirChanged" }, {
	group = vim.api.nvim_create_augroup("StatusLineGitAug", { clear = true }),
	callback = function(args)
		refresh_git_status(args.buf)
	end,
	desc = "Refresh git branch/status for the statusline",
})

local spinner_frames = { "⠋", "⠙", "⠚", "⠞", "⠖", "⠦", "⠴", "⠲", "⠳", "⠓" }
local spinner_frame = 1
local spinner_timer = nil

---@type table<integer, table<integer, boolean>>
local lsp_progress = {}

local function stop_spinner()
	if spinner_timer then
		spinner_timer:stop()
		spinner_timer:close()
		spinner_timer = nil
	end
end

local function start_spinner()
	if spinner_timer then
		return
	end

	local timer = vim.uv.new_timer()
	if not timer then
		return
	end

	spinner_timer = timer
	spinner_timer:start(0, spinner_interval_ms, function()
		spinner_frame = (spinner_frame % #spinner_frames) + 1
		vim.schedule(function()
			vim.cmd.redrawstatus()
		end)
	end)
end

-- Force a redraw when LSP progress updates
vim.api.nvim_create_autocmd("LspProgress", {
	group = vim.api.nvim_create_augroup("StatusLineLspProgressAug", { clear = true }),
	desc = "Track LSP progress for statusline spinner",
	callback = function(ev)
		local client_id = ev.data.client_id
		local token = ev.data.params.token

		if ev.data.params.value.kind == "end" then
			if lsp_progress[client_id] then
				lsp_progress[client_id][token] = nil
				if not next(lsp_progress[client_id]) then
					lsp_progress[client_id] = nil
				end
			end
		else
			lsp_progress[client_id] = lsp_progress[client_id] or {}
			lsp_progress[client_id][token] = true
		end

		if next(lsp_progress) then
			start_spinner()
		else
			stop_spinner()
		end

		vim.cmd.redrawstatus()
	end,
})

local window_size = 0
local is_wide_window = false

-- Each component is a zero-arg function that returns a string (or nil/"" to be skipped).
--- @type table<string, fun(): string?>
local components = {}

--- @return string
function components.mode()
	local settings = mode_settings[vim.api.nvim_get_mode().mode] or {}
	local name = settings.name or "unknown"
	local group = settings.hl or "Other"
	local text = is_wide_window and string.format("%9" .. "s", name) or (mode_abbr[name] or name)
	return hl["StatusLineMode" .. group](text)
end

--- @return string
function components.path()
	local buf_path = vim.api.nvim_buf_get_name(0)
	if buf_path == "" then
		return hl.StatusLinePath("[No Name]")
	end

	local filename = vim.fn.fnamemodify(buf_path, ":t")
	local text = filename

	if window_size > path_full_width then
		local full_path = vim.fn.fnamemodify(buf_path, ":~")
		text = full_path
	elseif window_size >= path_relative_width and window_size <= path_full_width then
		local cwd_path = vim.fn.fnamemodify(buf_path, ":.")
		text = cwd_path
	end

	text = hl.StatusLinePath(text)

	if vim.bo.modified then
		text = text .. hl.StatusLineBold("*")
	end

	return text
end

--- @return string?
function components.diagnostics()
	local text = vim.diagnostic.status(0)
	return text ~= "" and text or nil
end

--- @return string?
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

--- @return string?
function components.encoding()
	if not is_wide_window then
		return nil
	end
	local enc = vim.bo.fileencoding
	if enc == "" then
		enc = vim.o.encoding
	end
	return enc ~= "" and hl.StatusLineDim(enc) or nil
end

--- @return string?
function components.filetype()
	if not is_wide_window then
		return nil
	end
	local ft = vim.bo.filetype
	return ft ~= "" and hl.StatusLineDim(ft) or nil
end

--- @return string?
function components.fileformat()
	if not is_wide_window then
		return nil
	end
	local ff = vim.bo.fileformat
	return ff ~= "" and hl.StatusLineDim(ff) or nil
end

--- @return string?
function components.lsp()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		return nil
	end

	local busy = false
	for _, client in ipairs(clients) do
		if lsp_progress[client.id] then
			busy = true
			break
		end
	end

	local status = busy and hl.StatusLineLspSpinner(spinner_frames[spinner_frame]) or " "

	local names = {}
	for _, client in ipairs(clients) do
		table.insert(names, client.name)
	end

	return hl.StatusLineDim(table.concat(names, ",") .. " " .. status)
end

--- @return string
function components.position()
	if not is_wide_window then
		return hl.StatusLinePosition("%8(%l,%c%)")
	end
	return hl.StatusLinePosition("%12(%l,%c %p%%%)")
end

--- @return string
function components.separator()
	return hl.StatusLineDim("|")
end

-- "%=" is the built-in split point between the left- and right-aligned halves.
-- "%<" marks where Vim is allowed to start truncating.
---@type string[]
local sections = {
	"mode",
	"%<",
	"path",
	"%=",
	"diagnostics",
	"separator",
	"git",
	"separator",
	"encoding",
	"fileformat",
	"filetype",
	"separator",
	"lsp",
	"position",
}

---@alias StatusLineItem { kind: "raw"|"separator"|"text", value: string? }
---@return StatusLineItem[]
local function collect_items()
	local items = {}
	for _, name in ipairs(sections) do
		if vim.startswith(name, "%") then
			table.insert(items, { kind = "raw", value = name })
		elseif name == "separator" then
			local last = items[#items]
			if not (last and last.kind == "separator") then
				table.insert(items, { kind = "separator", value = components.separator() })
			end
		else
			local component = components[name]
			local text = component and component()
			if text and text ~= "" then
				table.insert(items, { kind = "text", value = text })
			end
		end
	end
	return items
end

local function render()
	window_size = vim.fn.winwidth(0)
	is_wide_window = window_size > min_window_width

	local items = collect_items()
	local parts = {}

	for i, item in ipairs(items) do
		if item.kind == "separator" then
			local prev_item, next_item = items[i - 1], items[i + 1]
			if
				prev_item
				and prev_item.kind == "text"
				and next_item
				and next_item.kind == "text"
				and next_item ~= items[#items]
			then
				table.insert(parts, item.value)
			end
		else
			table.insert(parts, item.value)
		end
	end

	return table.concat(parts, " ")
end

-- Called by vim.o.statusline in core/options.lua
return render
