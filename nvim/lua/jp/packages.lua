local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system {
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	}
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup {
	"cohama/lexima.vim", -- Auto-close parentheses, etc.
	"tpope/vim-sleuth", -- Auto-detect indentation preferences
	"numToStr/Comment.nvim", -- Rapid (un)commenting

	{
		-- Code completion engine
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- Use LSP suggestions
			"hrsh7th/cmp-nvim-lua", -- Auto-complete Neovim Lua APIs
			"hrsh7th/cmp-buffer", -- Suggest words in the buffer
			"hrsh7th/cmp-path", -- Complete local filesystem paths
		},
	},

	{
		-- Snippet engine & default snippets
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
	},

	"neovim/nvim-lspconfig", -- LSP support

	{
		-- Better syntax highlighting
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},

	{
		-- Fuzzy finder UI
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	"rktjmp/lush.nvim", -- Theme-building platform
	"rktjmp/shipwright.nvim", -- Export functionality for Lush
	{ dir = "~/Developer/Source/Other/industrial" }, -- Personal theme
}
