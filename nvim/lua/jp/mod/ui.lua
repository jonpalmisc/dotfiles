--===-- jp/mod/ui.lua ----------------------------------------------------------

vim.opt.guifont = "MD_IO_0.4_Medium:h12.5"

local lualine_theme = "16color"

local xenon_theme = {
	base00 = "#292A2F", -- Background
	base01 = "#2c313c", -- Light Background
	base02 = "#353A4D", -- Selection
	base03 = "#949597", -- Comments
	base04 = "#949597", -- Dark Foreground
	base05 = "#DFDFE0", -- Foreground
	base06 = "#9a9bb3", --
	base07 = "#c5c8e6", --
	base08 = "#a6aedd", -- Variables
	base09 = "#f7dfc2", -- Integers
	base0A = "#96c8bc", -- Classes
	base0B = "#e59f9b", -- Strings
	base0C = "#f7dfc2", -- Special
	base0D = "#89bdd7", -- Functions
	base0E = "#e09eb7", -- Keywords
	base0F = "#949597",
}

-- Report whether Neovim is running under a GUI
function has_gui()
	return vim.fn.exists "g:neovide" == 1 or vim.fn.has "gui_vimr" == 1
end

-- Use a theme when running under GUI clients
if has_gui() then
	lualine_theme = "auto"

	local found, base16 = pcall(require, "base16-colorscheme")
	if found then
		require("base16-colorscheme").setup(xenon_theme)
	end
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
