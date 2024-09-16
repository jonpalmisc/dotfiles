return {
	defaults = {
		mappings = {
			i = {
				["<esc>"] = require("telescope.actions").close,
			},
		},

		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
		},

		selection_caret = "  ",
		preview = false,
		prompt_title = false,
		results_title = false,
		storting_strategy = "ascending",

		layout_strategy = "bottom_pane",
		layout_config = {
			height = 10,
			prompt_position = "bottom",
		},
		borderchars = {
			prompt = { " ", " ", "─", " ", " ", " ", "─", "─" },
			results = { "─", " ", " ", " ", "─", "─", " ", " " },
		},
	},
}
