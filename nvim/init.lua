local opt = vim.opt

-- Performance -----------------------------------------------------------------

opt.hidden = true -- Enable background buffers
opt.history = 100 -- Set max history size
opt.lazyredraw = true -- Use faster scrolling
opt.synmaxcol = 160 -- Set max column for syntax highlighting
opt.updatetime = 250 -- Run faster?
opt.swapfile = false -- Disable swapfile

-- Editing ---------------------------------------------------------------------

opt.encoding = "utf-8" -- Use UTF-8 by default
opt.autoread = true -- Auto-read changed files from the disk

opt.clipboard = "unnamedplus" -- Use system clipboard

opt.autoindent = true -- Auto-indent new lines
opt.smartindent = true -- Smartly auto-indent new lines
opt.backspace = { "indent", "eol", "start" } -- Use expected backspace behavior

opt.showmatch = true -- Highlight matching parentheses

opt.wrap = false -- Don't wrap long lines
opt.scrolloff = 4 -- Use greater scroll margin

opt.shortmess:append "sI" -- Disable splash screen

-- Plugins ---------------------------------------------------------------------

local packer = require "packer"
local use = packer.use

packer.reset()
packer.init()

use "wbthomason/packer.nvim"

use {
	use "nvim-treesitter/nvim-treesitter",
	run = ":TSUpdate",
	config = require "config.treesitter",
}

use {
	"nvim-lualine/lualine.nvim",
	config = require "config.lualine",
}
