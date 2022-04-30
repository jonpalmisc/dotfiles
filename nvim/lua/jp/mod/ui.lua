--===-- jp/mod/ui.lua ----------------------------------------------------------

vim.opt.guifont = "Go_Mono:h12.5"

local lualine_theme = "16color"

-- Report whether Neovim is running under a GUI
function has_gui()
	return vim.fn.exists "g:neovide" == 1 or vim.fn.has "gui_vimr" == 1
end

-- Use a theme when running under GUI clients
if has_gui() then
	lualine_theme = "auto"
	vim.cmd [[colorscheme OceanicNext]]
end

require("lualine").setup {
	options = {
		icons_enabled = false,
		theme = lualine_theme,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {},
		always_divide_middle = true,
		globalstatus = false,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = {},
		lualine_c = { "filename", "filesize" },
		lualine_x = { "location" },
		lualine_y = { "branch", "diff" },
		lualine_z = { "filetype" },
	},
	inactive_sections = {
		lualine_a = { "" },
		lualine_b = {},
		lualine_c = { "filename", "filesize" },
		lualine_x = { "location" },
		lualine_y = { "branch", "diff" },
		lualine_z = { "filetype" },
	},
}
