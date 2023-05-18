local ensure_packer = function()
	local fn = vim.fn

	local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system {
			"git",
			"clone",
			"--depth",
			"1",
			"https://github.com/wbthomason/packer.nvim",
			install_path,
		}

		vim.cmd [[packadd packer.nvim]]
		return true
	end

	return false
end

local is_fresh_install = ensure_packer()

function packer_config(use)
	use "wbthomason/packer.nvim"

	use "lewis6991/impatient.nvim"

	--== Basic Editing ==---------------------------------------------------

	use "cohama/lexima.vim" -- Auto-close parentheses, etc.
	use "tpope/vim-sleuth" -- Auto-detect indentation preferences

	-- Rapid (un)commenting helpers
	use "numToStr/Comment.nvim"

	--== Autocompletion & Snippets ==---------------------------------------

	use {
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-nvim-lsp", -- Use LSP suggestions
			"hrsh7th/cmp-nvim-lua", -- Auto-complete Neovim Lua APIs
			"hrsh7th/cmp-buffer", -- Suggest words in the buffer
			"hrsh7th/cmp-path", -- Complete local filesystem paths
		},
	}

	use {
		"L3MON4D3/LuaSnip",
		requires = { "saadparwaiz1/cmp_luasnip", "rafamadriz/friendly-snippets" },
	}

	--== IDE Features ==----------------------------------------------------

	use "neovim/nvim-lspconfig"
	use {
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	}

	use {
		"nvim-telescope/telescope.nvim",
		tag = "0.1.1",
		requires = { { "nvim-lua/plenary.nvim" } },
	}
	--==--------------------------------------------------------------------


	if is_fresh_install then
		require("packer").sync()
	end
end

-- Attempt to load packer; if it still cannot be loaded (fatal config issue),
-- stop loading this config here.
local ok, packer = pcall(require, "packer")
if not ok then
	return
end

-- Load Packer and plugins.
packer.startup(packer_config)
