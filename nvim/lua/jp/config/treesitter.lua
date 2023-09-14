local ok, treesitter = pcall(require, "nvim-treesitter.configs")
if not ok then
	return
end

treesitter.setup {
	ensure_installed = {
		"comment",

		"c",
		"cpp",
		"cmake",
		"llvm",
		"make",
		"rust",

		"css",
		"html",
		"javascript",
		"typescript",
		"tsx",

		"bash",
		"lua",
		"python",

		"yaml",
	},
	sync_install = false,
	highlight = { enable = true },
	indent = { enable = true, disable = { "yaml" } },
}
