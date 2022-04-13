require("lualine").setup {
	options = {
		icons_enabled = false,
		theme = "16color",
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
