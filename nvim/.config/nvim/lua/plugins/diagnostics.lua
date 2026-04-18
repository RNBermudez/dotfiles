local diag = vim.diagnostic
local sev = diag.severity

diag.config({
	signs = {
		linehl = {
			[sev.ERROR] = "DiagnosticVirtualTextError",
			[sev.WARN] = "DiagnosticVirtualTextWarn",
			[sev.INFO] = "DiagnosticVirtualTextInfo",
			[sev.HINT] = "DiagnosticVirtualTextHint",
		},
	},
	float = {
		border = "rounded",
		source = true,
	},
	severity_sort = true,
	underline = true,
	update_in_insert = false,
	virtual_lines = {
		current_line = true,
	},
	virtual_text = false,
})

local function diagnostic_jump(count, severity)
	return function()
		diag.jump({ count = count, float = true, severity = severity })
	end
end

Keys.map_leader("n", "df", diag.open_float, "Open floating diagnostic message")
Keys.map_leader("n", "dq", diag.setqflist, "Send diagnostics to quickfix list")
Keys.map_leader("n", "dl", diag.setloclist, "Send diagnostics to location list")
Keys.map("n", "]e", diagnostic_jump(1, sev.ERROR), "Next error")
Keys.map("n", "[e", diagnostic_jump(-1, sev.ERROR), "Previous error")
Keys.map("n", "]w", diagnostic_jump(1, sev.WARN), "Next warning")
Keys.map("n", "[w", diagnostic_jump(-1, sev.WARN), "Previous warning")
