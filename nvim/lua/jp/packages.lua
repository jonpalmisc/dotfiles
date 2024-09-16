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

require("lazy").setup({
	-- Personal color scheme.
	{
		dir = "~/Developer/Source/Personal/nvim_industrial_theme",
		lazy = false,
		priority = 1000,
		config = function()
			vim.opt.termguicolors = true
			vim.cmd "colorscheme industrial"
		end,
	},

	-- Auto-close and auto-delete pairs.
	{ "m4xshen/autoclose.nvim", config = true },

	-- Auto-detect indentation on a per-file basis so that Neovim inserts
	-- the right amount of indentation by default during editing.
	"tpope/vim-sleuth",

	-- Well-maintained configurations for many common LSP servers for
	-- automatic integration with Neovim's LSP support.
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("jp.config.lsp").setup()
		end,
	},

	-- Pop-up code completion.
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			-- Snippet engine.
			{
				"L3MON4D3/LuaSnip",
				dependencies = {
					-- Use popular snippets from VSCode.
					"rafamadriz/friendly-snippets",
				},
				config = function(_, _)
					require "jp.config.luasnip"
				end,
			},

			-- Integrate with LSP for completion.
			"hrsh7th/cmp-nvim-lsp",
			-- Auto-complete Neovim Lua APIs.
			"hrsh7th/cmp-nvim-lua",
			-- Suggets words in the buffer as completions.
			"hrsh7th/cmp-buffer",
			-- Helps complete local filesystem paths.
			"hrsh7th/cmp-path",
			-- Show snippets in the completion popup.
			"saadparwaiz1/cmp_luasnip",
		},
		event = "InsertEnter",
		opts = function()
			return require "jp.config.cmp"
		end,
	},

	-- Generic fuzzy-finder API, provides "command palette"-like search
	-- interfaces for files, LSP symbols, etc.
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = { "Telescope" },
		opts = function()
			return require "jp.config.telescope"
		end,
	},

	-- Traditional-style sidebar.
	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeToggle", "NvimTreeFocus" },
		opts = function()
			return require "jp.config.tree"
		end,
	},

	-- Magit-like Git interface.
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
		},
		cmd = { "Neogit" },
		config = true,
	},

	"rktjmp/lush.nvim", -- Framework for easily building themes.
	"rktjmp/shipwright.nvim", -- Used for exporting theme to other formats.
}, {
	defaults = {
		lazy = true,
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"2html_plugin",
				"tohtml",
				"getscript",
				"getscriptPlugin",
				"gzip",
				"logipat",
				"netrw",
				"netrwPlugin",
				"netrwSettings",
				"netrwFileHandlers",
				"matchit",
				"tar",
				"tarPlugin",
				"rrhelper",
				"spellfile_plugin",
				"vimball",
				"vimballPlugin",
				"zip",
				"zipPlugin",
				"tutor",
				"rplugin",
				"syntax",
				"synmenu",
				"optwin",
				"compiler",
				"bugreport",
				"ftplugin",
			},
		},
	},
})
