--===-- jp/plugins.lua ---------------------------------------------------------

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

--===---------------------------------------------------------------------------

local ok, packer = pcall(require, "packer")
if not ok then
	return
end

return packer.startup(function(use)
	use "wbthomason/packer.nvim"

	-- mod/editor ----------------------------------------------------------

	use "windwp/nvim-autopairs"
	use "numToStr/Comment.nvim"

	-- mod/completion ------------------------------------------------------

	use "hrsh7th/nvim-cmp"
	use "hrsh7th/cmp-buffer"
	use "hrsh7th/cmp-path"
	use "hrsh7th/cmp-cmdline"
	use "saadparwaiz1/cmp_luasnip"

	use "L3MON4D3/LuaSnip"

	-- mod/ui --------------------------------------------------------------

	use "mhartington/oceanic-next"
	use "nvim-lualine/lualine.nvim"

	-- mod/treesitter ------------------------------------------------------

	use {
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	}

	-- startup -------------------------------------------------------------

	use "lewis6991/impatient.nvim"

	if IS_FRESH_INSTALL then
		require("packer").sync()
	end
end)
