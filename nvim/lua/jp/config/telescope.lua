local jp = require "jp.core"

local ok, telescope = pcall(require, "telescope")
if not ok then
	return
end

local actions = require "telescope.actions"

local defaults = {
	mappings = {
		i = {
			["<esc>"] = actions.close,
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
}

telescope.setup { defaults = defaults }

jp.map("n", "<leader>fb", "<cmd> :Telescope buffers <CR>")
jp.map("n", "<leader>ff", "<cmd> :Telescope find_files <CR>")
jp.map("n", "<leader>fw", "<cmd> :Telescope live_grep <CR>")

jp.map("n", "<leader>fs", "<cmd> :Telescope lsp_document_symbols <CR>")
jp.map("n", "<leader>fr", "<cmd> :Telescope lsp_references <CR>")
