local lazy_path = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazy_path) then
	vim.fn.system {
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazy_path,
	}
end

vim.opt.rtp:prepend(lazy_path)

require("lazy").setup {
	-- Lots of minimal "mini plugins" that implement functionality I want.
	{ 'echasnovski/mini.nvim', version = '*' },

	-- Well-maintained configurations for many common LSP servers for
	-- automatic integration with Neovim's LSP support.
	"neovim/nvim-lspconfig",

	-- Auto-detects indentation on a per-file basis so that Neovim inserts
	-- the right amount of indentation by default during editing.
	"tpope/vim-sleuth",

	-- Pop-up code completion.
	--
	-- TODO: Migrating to the completion offered `mini.nvim` in the future
	-- might be nice, but for now, this offers a better set of completion
	-- sources and more predictable behavior.
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			-- Integrate with LSP for completion.
			"hrsh7th/cmp-nvim-lsp",
			-- Auto-complete Neovim Lua APIs.
			"hrsh7th/cmp-nvim-lua",
			-- Suggets words in the buffer as completions.
			"hrsh7th/cmp-buffer",
			-- Helps complete local filesystem paths.
			"hrsh7th/cmp-path",
		},
	},

	-- Popular plugin for code snippet expansion.
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			-- Show snippets in the completion popup.
			"saadparwaiz1/cmp_luasnip",
			-- Use popular snippets from VSCode.
			"rafamadriz/friendly-snippets",
		},
	},

	-- Generic fuzzy-finder API, provides "command palette"-like search
	-- interfaces for files, LSP symbols, etc.
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	-- Framework for easily building themes.
	{
		"rktjmp/lush.nvim",
		dependencies = {
			-- Used for exporting theme to other formats.
			"rktjmp/shipwright.nvim"
		},
	},

	-- Personal theme.
	{ dir = "~/Developer/Source/Personal/nvim_industrial_theme" },
}
