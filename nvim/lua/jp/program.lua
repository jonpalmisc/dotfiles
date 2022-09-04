--==--{ program.lua - Generic program options and miscellaneous config }--------

local vim_options = {
	hidden = true, -- Enable background buffers
	history = 100, -- Set max history size
	lazyredraw = true, -- Use faster scrolling
	synmaxcol = 160, -- Set max column for syntax highlighting
	updatetime = 250, -- Run faster?
	swapfile = false, -- Disable swapfile

	backup = false, -- Disable backup files
	autoread = true, -- Auto-reload modified files

	completeopt = { "menuone", "noselect" },

	conceallevel = 0,

	pumheight = 12, -- Limit popup menu height to 12
}

for k, v in pairs(vim_options) do
	vim.opt[k] = v
end

local disabled_plugins = {
	"2html_plugin",
	"black",
	"getscript",
	"getscriptPlugin",
	"gzip",
	"logipat",
	"matchit",
	"netrw",
	"netrwFileHandlers",
	"netrwPlugin",
	"netrwSettings",
	"remote_plugins",
	"rrhelper",
	"spellfile_plugin",
	"tar",
	"tarPlugin",
	"vimball",
	"vimballPlugin",
	"zip",
	"zipPlugin",
}

for _, plugin in pairs(disabled_plugins) do
	vim.g["loaded_" .. plugin] = 1
end

-- Configure (local) leader before any plugins or other files use it
vim.g.mapleader = ";"
vim.g.maplocalleader = ";"
