local wezterm = require "wezterm"

-- Must be manually synced with Industrial theme!
local industrial_colors = {
	black = "#000000",
	grey = "#666666",
	white = "#EEEEEE",

	red = "#F0866F",
	green = "#7FDA95",
	yellow = "#E7B00D",
	blue = "#7DC0EE",
	purple = "#DF92D1",
	cyan = "#73D0CE",
}

local ansi_colors = {
	industrial_colors.grey,
	industrial_colors.red,
	industrial_colors.green,
	industrial_colors.yellow,
	industrial_colors.blue,
	industrial_colors.purple,
	industrial_colors.cyan,
	industrial_colors.white,
}

return {
	font = wezterm.font "Berkeley Mono",

	initial_cols = 96,
	initial_rows = 32,

	use_ime = false, -- Interpret C-q, etc. correctly

	colors = {
		background = industrial_colors.black,
		foreground = industrial_colors.white,

		cursor_bg = industrial_colors.white,
		cursor_fg = industrial_colors.black,

		ansi = ansi_colors,
		brights = ansi_colors,
	},
	bold_brightens_ansi_colors = "No",

	hide_tab_bar_if_only_one_tab = true,
}
