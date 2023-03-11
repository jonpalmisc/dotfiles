local wezterm = require "wezterm"

return {
	font = wezterm.font "Berkeley Mono",
	color_scheme = "Catppuccin Macchiato",

	use_ime = false, -- Interpret C-q, etc. correctly

	hide_tab_bar_if_only_one_tab = true,
}
