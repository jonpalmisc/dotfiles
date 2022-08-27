--==--{ editor.lua - Editor plugins and behavior configuration }----------------

local vim_options = {
	encoding = "utf-8", -- Always use UTF-8 (Part 1)
	fileencoding = "utf-8", -- Always use UTF-8 (Part 2)

	clipboard = "unnamedplus", -- Use the system clipboard

	autoindent = true, -- Use auto-indentation
	smartindent = true, -- Use *smart* auto-indentation
	backspace = { "indent", "eol", "start" }, -- Use expected backspace behavior

	showmatch = true, -- Highlight character pairs

	hlsearch = true, -- Highlight search matches
	ignorecase = true, -- Ignore case when searching
	smartcase = true, -- Ignore `ignorecase` if the search is mixed-case

	wrap = false, -- Don't wrap long lines
	scrolloff = 2, -- Add vertical scrolling margin

	textwidth = 80, -- Use the correct true column limit
}

for k, v in pairs(vim_options) do
	vim.opt[k] = v
end

vim.cmd [[set iskeyword-=-]] -- Treat hyphens as word separators
vim.cmd [[set iskeyword-=_]] -- Treat underscores as word separators

require("nvim-autopairs").setup()
require("Comment").setup()
