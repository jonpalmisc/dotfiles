local treesitter = require "nvim-treesitter.configs"

treesitter.setup {
	ensure_installed = {
		"bash",
		"c",
		"cpp",
		"cmake",
		"llvm",
		"lua",
		"python",
		"zig",

		"comment",
		"vim",
		"vimdoc",
	},
	sync_install = false,

	highlight = { enable = true },
	indent = { enable = true, disable = { "yaml" } },
}
