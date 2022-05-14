local ok, telescope = pcall(require, "telescope")

if not ok then
	return
end

local mappings = {
	i = {
		-- Quit the prompt with a single press of <ESC>
		["<ESC>"] = require("telescope.actions").close,
	},
}

local defaults = {
	mappings = mappings,

	-- Use 'ripgrep' for grep-like activity
	vimgrep_arguments = {
		"rg",
		"--color=never",
		"--no-heading",
		"--with-filename",
		"--line-number",
		"--column",
		"--smart-case",
	},

	-- Hide caret on selected result (highlight is enough)
	selection_caret = "  ",

	-- Hide preview and prompt/results titles
	preview = false,
	prompt_title = false,
	results_title = false,

	-- Place chooser at the bottom of the screen, Ivy-like
	layout_strategy = "bottom_pane",

	-- Limit chooser height and place the prompt at the bottom
	layout_config = {
		height = 10,
		prompt_position = "bottom",
	},
	storting_strategy = "ascending",

	-- Hide certain border elements to match Ivy-style appearance
	borderchars = {
		prompt = { " ", " ", "─", " ", " ", " ", "─", "─" },
		results = { "─", " ", " ", " ", "─", "─", " ", " " },
	},
}

telescope.setup {
	defaults = defaults,
}

local map = require("jp.utils").map

map("n", "<leader>fb", "<cmd> :Telescope buffers <CR>")
map("n", "<leader>ff", "<cmd> :Telescope find_files <CR>")
map("n", "<leader>fw", "<cmd> :Telescope live_grep <CR>")
