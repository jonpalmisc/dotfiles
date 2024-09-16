vim.opt.hidden = true -- Enable background buffers.
vim.opt.history = 100 -- Set max history size.
vim.opt.lazyredraw = true -- Use faster scrolling?
vim.opt.synmaxcol = 160 -- Set max column for syntax highlighting (performance).
vim.opt.updatetime = 250 -- Run faster, allegedly.
vim.opt.swapfile = false -- Disable swapfile.
vim.opt.shortmess = "I" -- Hide intro message.

vim.opt.backup = false -- Disable backup files.
vim.opt.autoread = true -- Auto-reload modified files.

vim.opt.mouse = "" -- No mouse!

-- Make popup menu behave better.
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.pumheight = 8

-- Always use UTF-8 (twice as sure).
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- Yank to and paste from the system clipboard.
vim.opt.clipboard = "unnamedplus"

-- Do the right thing with auto-indentation.
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Fix default backspace behavior insanity.
vim.opt.backspace = { "indent", "eol", "start" }

vim.opt.showmatch = true -- Highlight character pairs.
vim.opt.hlsearch = true -- Highlight search matches.
vim.opt.ignorecase = true -- Ignore case when searching.
vim.opt.smartcase = true -- Don't ignore case if the search is mixed-case.

vim.opt.splitbelow = true -- Split below on horizontal splits.
vim.opt.splitright = true -- Split to right on vertical splits.

vim.opt.wrap = false -- Don't wrap long lines.
vim.opt.scrolloff = 2 -- Add vertical scrolling margin.

vim.opt.conceallevel = 0 -- Don't hide characters, e.g. in Markdown

-- Configure (local) leader before any plugins or other files use it.
vim.g.mapleader = ";"
vim.g.maplocalleader = ";"

-- Disable some provider nonsense.
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

vim.cmd [[set iskeyword-=-]] -- Treat hyphens as word separators.
vim.cmd [[set iskeyword-=_]] -- Treat underscores as word separators.
