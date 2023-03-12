local ok, treesitter = pcall(require, "nvim-treesitter.configs")
if not ok then
	return
end

treesitter.setup {
	ensure_installed = {
		"c",
		"cmake",
		"comment",
		"cpp",
		"css",
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
