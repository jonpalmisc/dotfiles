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

local packer_bootstrap = ensure_packer()

function packer_config(use)
	use "wbthomason/packer.nvim"

	--=== Autocompletion & Snippets ===-------------------------------------

	use {
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-nvim-lsp", -- Use LSP suggestions
			"hrsh7th/cmp-buffer", -- Suggest words in the buffer
			"hrsh7th/cmp-path", -- Complete local filesystem paths
		},
	}

	use { "L3MON4D3/LuaSnip", requires = { "saadparwaiz1/cmp_luasnip" } }

	--=== Basic Editing ===-------------------------------------------------

	use "cohama/lexima.vim" -- Auto-close parentheses, etc.
	use "tpope/vim-sleuth" -- Auto-detect indentation preferences

	-- Rapid (un)commenting helpers
	use "numToStr/Comment.nvim"

	--===-------------------------------------------------------------------

	if packer_bootstrap then
		require("packer").sync()
	end
end

-- Configure plugin management.
require("packer").startup(packer_config)

require("Comment").setup()
