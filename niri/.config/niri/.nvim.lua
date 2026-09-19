local format = require("conform")

format.formatters_by_ft.kdl = { "kdlfmt_v1" }

format.formatters.kdlfmt_v1 = {
	command = "kdlfmt",
	args = { "format", "--kdl-version", "v1", "-" },
}
