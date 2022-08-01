--===-- jp/options.lua ---------------------------------------------------------

local opts = {
	hidden = true, -- Enable background buffers
	history = 100, -- Set max history size
	lazyredraw = true, -- Use faster scrolling
	synmaxcol = 160, -- Set max column for syntax highlighting
	updatetime = 250, -- Run faster?
	swapfile = false, -- Disable swapfile

	backup = false, -- Disable backup files
	autoread = true, -- Auto-reload modified files
	encoding = "utf-8", -- Always use UTF-8 (Part 1)
	fileencoding = "utf-8", -- Always use UTF-8 (Part 2)

	clipboard = "unnamedplus", -- Use the system clipboard

	completeopt = { "menuone", "noselect" },
	wrap = false, -- Don't wrap long lines
	scrolloff = 2, -- Add vertical scrolling margin

	conceallevel = 0,
	autoindent = true, -- Use auto-indentation
	smartindent = true, -- Use *smart* auto-indentation
	backspace = { "indent", "eol", "start" }, -- Use expected backspace behavior

	showmatch = true, -- Highlight character pairs

	hlsearch = true, -- Highlight search matches
	ignorecase = true, -- Ignore case when searching
	smartcase = true, -- Ignore `ignorecase` if the search is mixed-case

	pumheight = 12, -- Limit popup menu height to 12
}

for k, v in pairs(opts) do
	vim.opt[k] = v
end

vim.cmd [[set iskeyword-=-]] -- Treat hyphens as word separators
vim.cmd [[set iskeyword-=_]] -- Treat underscores as word separators

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
