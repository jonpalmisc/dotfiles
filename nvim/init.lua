--==------------------------------- init.lua -------------------------------==--
--
--			   N E O V I M   C O N F I G
--
--==------------------------------------------------------------------------==--

local ok, impatient = pcall(require, "impatient")
if ok then
	impatient.enable_profile()
end

--==------------------------------------------------------------------------==--
--
--				  CORE OPTIONS
--
--==------------------------------------------------------------------------==--

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

--==------------------------------------------------------------------------==--
--
--				    PLUGINS
--
--==------------------------------------------------------------------------==--

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

--==------------------------------------------------------------------------==--
--
--				     EDITOR
--
--==------------------------------------------------------------------------==--

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

--==------------------------------------------------------------------------==--
--
--				      IDE
--
--==------------------------------------------------------------------------==--

local ok, _ = pcall(require, "lspconfig")
if not ok then
	return
end

local opts = { noremap = true, silent = true }

local on_attach = function(client, bufnr)
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<localleader>gD",
		"<cmd>lua vim.lsp.buf.declaration()<CR>",
		opts
	)
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<localleader>gd",
		"<cmd>lua vim.lsp.buf.definition()<CR>",
		opts
	)
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<localleader>gr",
		"<cmd>lua vim.lsp.buf.references()<CR>",
		opts
	)
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<localleader>K",
		"<cmd>lua vim.lsp.buf.hover()<CR>",
		opts
	)
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<localleader>lr",
		"<cmd>lua vim.lsp.buf.rename()<CR>",
		opts
	)
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<localleader>la",
		"<cmd>lua vim.lsp.buf.code_action()<CR>",
		opts
	)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem = {
	snippetSupport = true,
	resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	},
	documentationFormat = { "markdown", "plaintext" },
	labelDetailsSupport = true,
	deprecatedSupport = true,
	tagSupport = { valueSet = { 1 } },
	preselectSupport = true,
	insertReplaceSupport = true,
	commitCharactersSupport = true,
}

local servers = { "pyright", "rust_analyzer", "clangd", "zls" }
for _, lsp in pairs(servers) do
	require("lspconfig")[lsp].setup {
		on_attach = on_attach,
		capabilities = capabilities,
		flags = {
			debounce_text_changes = 150,
		},
	}
end

--==----------------------------------------------------------------------------

local ok, cmp = pcall(require, "cmp")
if not ok then
	return
end

local compare = require "cmp.config.compare"

local ok, luasnip = pcall(require, "luasnip")
if not ok then
	return
end

-- Custom format function to limit dialog width
local format = function(entry, item)
	local MIN_WIDTH = 16
	local MAX_WIDTH = 32

	local label = item.abbr

	local truncated_label = vim.fn.strcharpart(label, 0, MAX_WIDTH)
	if truncated_label ~= label then
		item.abbr = truncated_label .. "…"
	elseif string.len(label) < MIN_WIDTH then
		local padding = string.rep(" ", MIN_WIDTH - string.len(label))
		item.abbr = label .. padding
	end

	return item
end

cmp.setup {
	view = {
		entries = "native",
	},
	formatting = {
		format = format,
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = {
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<CR>"] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},

		["<Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end,
		["<S-Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end,
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
	},
}

--==----------------------------------------------------------------------------

local ok, treesitter = pcall(require, "nvim-treesitter.configs")
if not ok then
	return
end

treesitter.setup {
	ensure_installed = {
		"c",
		"cmake",
		"comment",
		"cpp",
		"css",
		"go",
		"lua",
		"make",
		"python",
		"rust",
		"yaml",
		"zig",
	},
	sync_install = false,
	highlight = { enable = true },
	indent = { enable = true, disable = { "yaml" } },
}

--==----------------------------------------------------------------------------

local ok, telescope = pcall(require, "telescope")

if not ok then
	return
end

local mappings = {
	i = {
		-- Quit the prompt with a single press of <ESC>
		["<ESC>"] = require("telescope.actions").close,
	},
}

local defaults = {
	mappings = mappings,

	-- Use 'ripgrep' for grep-like activity
	vimgrep_arguments = {
		"rg",
		"--color=never",
		"--no-heading",
		"--with-filename",
		"--line-number",
		"--column",
		"--smart-case",
	},

	-- Hide caret on selected result (highlight is enough)
	selection_caret = "  ",

	-- Hide preview and prompt/results titles
	preview = false,
	prompt_title = false,
	results_title = false,

	-- Place chooser at the bottom of the screen, Ivy-like
	layout_strategy = "bottom_pane",

	-- Limit chooser height and place the prompt at the bottom
	layout_config = {
		height = 10,
		prompt_position = "bottom",
	},
	storting_strategy = "ascending",

	-- Hide certain border elements to match Ivy-style appearance
	borderchars = {
		prompt = { " ", " ", "─", " ", " ", " ", "─", "─" },
		results = { "─", " ", " ", " ", "─", "─", " ", " " },
	},
}

telescope.setup {
	defaults = defaults,
}

function jp_map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end

	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

jp_map("n", "<leader>fb", "<cmd> :Telescope buffers <CR>")
jp_map("n", "<leader>ff", "<cmd> :Telescope find_files <CR>")
jp_map("n", "<leader>fw", "<cmd> :Telescope live_grep <CR>")

--==------------------------------------------------------------------------==--
--
--				    BINDINGS
--
--==------------------------------------------------------------------------==--

local opts = { noremap = true, silent = true }
local map = vim.api.nvim_set_keymap

-- NOTE: Leader keys are configured early in 'program.lua'.

map("n", "<A-k>", ":m .-2<CR>==", opts) -- Swap line up
map("n", "<A-j>", ":m .+1<CR>==", opts) -- Swap line down

map("n", "<C-l>", ":noh<CR>zz", opts) -- Center line and clear highlight

vim.cmd [[
augroup jp_git_rebase
	autocmd!
	autocmd FileType gitrebase nnoremap <buffer> p :Pick<CR>
	autocmd FileType gitrebase nnoremap <buffer> r :Reword<CR>
	autocmd FileType gitrebase nnoremap <buffer> e :Edit<CR>
	autocmd FileType gitrebase nnoremap <buffer> s :Squash<CR>
	autocmd FileType gitrebase nnoremap <buffer> f :Fixup<CR>
	autocmd FileType gitrebase nnoremap <buffer> d :Drop<CR>
augroup END
]]
