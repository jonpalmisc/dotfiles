--==------------------------------== EDITOR ==------------------------------==--
--
-- This portion of this configuration deals exclusively with preferences built
-- into Neovim; it should not attempt to configure or load plugins, and all of
-- its effects should still apply as expected in the absence of Packer.
--
--==------------------------------------------------------------------------==--

local vim_options = {
	hidden = true, -- Enable background buffers
	history = 100, -- Set max history size
	lazyredraw = true, -- Use faster scrolling
	synmaxcol = 160, -- Set max column for syntax highlighting
	updatetime = 250, -- Run faster
	swapfile = false, -- Disable swapfile

	backup = false, -- Disable backup files
	autoread = true, -- Auto-reload modified files

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

for k, v in pairs(vim_options) do
	vim.opt[k] = v
end

-- Configure (local) leader before any plugins or other files use it
vim.g.mapleader = ";"
vim.g.maplocalleader = ";"

vim.cmd [[set iskeyword-=-]] -- Treat hyphens as word separators
vim.cmd [[set iskeyword-=_]] -- Treat underscores as word separators

local map_opts = { noremap = true, silent = true }
local map = vim.api.nvim_set_keymap

map("n", "<A-k>", ":m .-2<CR>==", map_opts) -- Swap line up
map("n", "<A-j>", ":m .+1<CR>==", map_opts) -- Swap line down

--==------------------------------------------------------------------------==--

local rebase_group = vim.api.nvim_create_augroup("GitRebaseJP", {})

function create_rebase_autocmd(cmd)
	vim.api.nvim_create_autocmd(
		"FileType",
		{ pattern = "gitrebase", group = rebase_group, command = cmd }
	)
end

create_rebase_autocmd "nnoremap <buffer> p :Pick<CR>"
create_rebase_autocmd "nnoremap <buffer> r :Reword<CR>"
create_rebase_autocmd "nnoremap <buffer> e :Edit<CR>"
create_rebase_autocmd "nnoremap <buffer> s :Squash<CR>"
create_rebase_autocmd "nnoremap <buffer> f :Fixup<CR>"
create_rebase_autocmd "nnoremap <buffer> d :Drop<CR>"

--==-----------------------------== PLUGINS ==------------------------------==--
--
-- Plugin configuration and anything that depends on Packer should begin after
-- this point. Core settings or anything that doesnt depend on a plugin should
-- NOT be configured below here, since it will not be applied if Packer is not
-- present or fails to load!
--
--==------------------------------------------------------------------------==--

-- Attempt to load 'impatient' to improve startup time.
local ok, impatient = pcall(require, "impatient")
if ok then
	impatient.enable_profile()
end

local ensure_packer = function()
	local fn = vim.fn

	local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system {
			"git",
			"clone",
			"--depth",
			"1",
			"https://github.com/wbthomason/packer.nvim",
			install_path,
		}

		vim.cmd [[packadd packer.nvim]]
		return true
	end

	return false
end

local packer_bootstrap = ensure_packer()

function packer_config(use)
	use "wbthomason/packer.nvim"

	use "lewis6991/impatient.nvim"

	--== Basic Editing ==---------------------------------------------------

	use "cohama/lexima.vim" -- Auto-close parentheses, etc.
	use "tpope/vim-sleuth" -- Auto-detect indentation preferences

	-- Rapid (un)commenting helpers
	use "numToStr/Comment.nvim"

	--== Autocompletion & Snippets ==---------------------------------------

	use {
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-nvim-lsp", -- Use LSP suggestions
			"hrsh7th/cmp-nvim-lua", -- Auto-complete Neovim Lua APIs
			"hrsh7th/cmp-buffer", -- Suggest words in the buffer
			"hrsh7th/cmp-path", -- Complete local filesystem paths
		},
	}

	use { "L3MON4D3/LuaSnip", requires = { "saadparwaiz1/cmp_luasnip" } }

	--== IDE Features ==----------------------------------------------------

	use "neovim/nvim-lspconfig"
	use {
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	}

	--==--------------------------------------------------------------------

	if packer_bootstrap then
		require("packer").sync()
	end
end

-- Attempt to load packer; if it still cannot be loaded (fatal config issue),
-- stop loading this config here.
local ok, packer = pcall(require, "packer")
if not ok then
	return
end

-- Load Packer and plugins.
packer.startup(packer_config)

require("Comment").setup()

--==-------------------------------== LSP ==--------------------------------==--

local ok, _ = pcall(require, "lspconfig")
if not ok then
	return
end

local map_opts = { noremap = true, silent = true }

local on_attach = function(client, bufnr)
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<localleader>gD",
		"<cmd>lua vim.lsp.buf.declaration()<CR>",
		map_opts
	)
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<localleader>gd",
		"<cmd>lua vim.lsp.buf.definition()<CR>",
		map_opts
	)
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<localleader>gr",
		"<cmd>lua vim.lsp.buf.references()<CR>",
		map_opts
	)
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<localleader>K",
		"<cmd>lua vim.lsp.buf.hover()<CR>",
		map_opts
	)
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<localleader>lr",
		"<cmd>lua vim.lsp.buf.rename()<CR>",
		map_opts
	)
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<localleader>la",
		"<cmd>lua vim.lsp.buf.code_action()<CR>",
		map_opts
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
	}
end

--==----------------------------------------------------------------------------

local ok, cmp = pcall(require, "cmp")
if not ok then
	return
end

local ok, luasnip = pcall(require, "luasnip")
if not ok then
	return
end

cmp.setup {
	view = {
		entries = "native",
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
		{ name = "nvim_lua" },
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
