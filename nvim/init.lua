local jp = require "jp.core"

jp.set_vim_opts {
	hidden = true, -- Enable background buffers
	history = 100, -- Set max history size
	lazyredraw = true, -- Use faster scrolling
	synmaxcol = 160, -- Set max column for syntax highlighting
	updatetime = 250, -- Run faster
	swapfile = false, -- Disable swapfile
	shortmess = "I", -- Hide intro message

	backup = false, -- Disable backup files
	autoread = true, -- Auto-reload modified files

	mouse = "", -- Less mouse

	completeopt = { "menuone", "noselect" },

	pumheight = 8, -- Limit popup menu height

	--===-------------------------------------------------------------------

	encoding = "utf-8", -- Always use UTF-8 (Part 1)
	fileencoding = "utf-8", -- Always use UTF-8 (Part 2)

	clipboard = "unnamedplus", -- Use the system clipboard

	autoindent = true, -- Use auto-indentation
	smartindent = true, -- Use "smart" auto-indentation
	backspace = { "indent", "eol", "start" }, -- Use "normal" backspace

	showmatch = true, -- Highlight character pairs

	hlsearch = true, -- Highlight search matches
	ignorecase = true, -- Ignore case when searching
	smartcase = true, -- Don't ignore case if the search is mixed-case

	wrap = false, -- Don't wrap long lines
	scrolloff = 2, -- Add vertical scrolling margin

	conceallevel = 0, -- Don't hide characters
}

-- Configure (local) leader before any plugins or other files use it
vim.g.mapleader = ";"
vim.g.maplocalleader = ";"

vim.cmd [[set iskeyword-=-]] -- Treat hyphens as word separators
vim.cmd [[set iskeyword-=_]] -- Treat underscores as word separators

jp.map("n", "<A-k>", ":m .-2<CR>==") -- Swap line up
jp.map("n", "<A-j>", ":m .+1<CR>==") -- Swap line down

--==------------------------------------------------------------------------==--

require "jp.plugin.rebase"

--==------------------------------------------------------------------------==--

require "jp.packages"

require "jp.config.mini"
require "jp.config.cmp"
require "jp.config.lsp"
require "jp.config.telescope"
require "jp.config.theme"
