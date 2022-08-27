--==--{ ide.lua - LSP and IDE-like feature setup }------------------------------

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

local map = require("jp.utils").map

map("n", "<leader>fb", "<cmd> :Telescope buffers <CR>")
map("n", "<leader>ff", "<cmd> :Telescope find_files <CR>")
map("n", "<leader>fw", "<cmd> :Telescope live_grep <CR>")
