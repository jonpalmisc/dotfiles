--===-- jp/mod/treesitter.lua --------------------------------------------------

require("nvim-treesitter.configs").setup {
	ensure_installed = {
		"c",
		"cmake",
		"comment",
		"cpp",
		"css",
		"fennel",
		"fish",
		"go",
		"lua",
		"make",
		"python",
		"rust",
		"yaml",
		"zig",
	},
	sync_install = false,
	highlight = { enable = true },
	indent = { enable = true, disable = { "yaml" } },
}
