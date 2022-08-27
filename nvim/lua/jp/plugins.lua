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
	use "terrortylor/nvim-comment"

	if IS_FRESH_INSTALL then
		require("packer").sync()
	end
end)
