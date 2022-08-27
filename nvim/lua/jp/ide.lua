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
