--===-- jp/mod/lsp.lua ---------------------------------------------------------

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
		"<localleader>gT",
		"<cmd>lua vim.lsp.buf.type_definition()<CR>",
		opts
	)
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<localleader>gi",
		"<cmd>lua vim.lsp.buf.implementation()<CR>",
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
		"<localleader>wl",
		"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
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

-- Configure LSP-backed auto-completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local servers = { "pyright", "rust_analyzer", "tsserver" }
for _, lsp in pairs(servers) do
	require("lspconfig")[lsp].setup {
		on_attach = on_attach,
		capabilities = capabilities,
		flags = {
			debounce_text_changes = 150,
		},
	}
end
