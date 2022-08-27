--==--{ plugins.lua - Plugin manager and dependency setup }---------------------

local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	IS_FRESH_INSTALL = vim.fn.system {
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	}

	vim.cmd [[packadd packer.nvim]]
end

local ok, packer = pcall(require, "packer")
if not ok then
	return
end

packer.startup(function(use)
	use "wbthomason/packer.nvim"

	use "windwp/nvim-autopairs"
	use "tpope/vim-sleuth"
	use "numToStr/Comment.nvim"

	use "hrsh7th/nvim-cmp"
	use "hrsh7th/cmp-buffer"
	use "hrsh7th/cmp-path"
	use "hrsh7th/cmp-nvim-lsp"

	use "L3MON4D3/LuaSnip"
	use "saadparwaiz1/cmp_luasnip"

	use "neovim/nvim-lspconfig"
	use {
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	}

	use {
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
	}

	use "lewis6991/impatient.nvim"

	if IS_FRESH_INSTALL then
		require("packer").sync()
	end
end)
