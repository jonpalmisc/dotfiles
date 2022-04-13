require("nvim-treesitter.configs").setup {
	ensure_installed = {
		"fish",
		"c",
		"cpp",
		"lua",
	},
	highlight = {
		enable = true,
	},
}
