-- This file needs to be a module because of the way it is required in the main
-- packages file; top-level code here will cause problems.
local M = {}

M.on_attach = function(_, buf)
	local map = vim.keymap.set

	map(
		"n",
		"<localleader>gD",
		"<cmd>lua vim.lsp.buf.declaration()<CR>",
		{ buffer = true }
	)
	map(
		"n",
		"<localleader>gd",
		"<cmd>lua vim.lsp.buf.definition()<CR>",
		{ buffer = true }
	)
	map(

		"n",
		"<localleader>gi",
		"<cmd>lua vim.lsp.buf.implementation()<CR>",
		{ buffer = true }
	)
	map(
		"n",
		"<localleader>gr",
		"<cmd>lua vim.lsp.buf.references()<CR>",
		{ buffer = true }
	)
	map(
		"n",
		"<localleader>lr",
		"<cmd>lua vim.lsp.buf.rename()<CR>",
		{ buffer = true }
	)
	map(
		"n",
		"<localleader>la",
		"<cmd>lua vim.lsp.buf.code_action()<CR>",
		{ buffer = true }
	)

	map("i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { buffer = true })
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

-- Further-configure for completion.
--
-- Pirated from: https://github.com/NvChad/NvChad/blob/8d2bb359e47d816e67ff86b5ce2d8f5abfe2b631/lua/nvchad/configs/lspconfig.lua#L40
M.capabilities.textDocument.completion.completionItem = {
	documentationFormat = { "markdown", "plaintext" },
	snippetSupport = true,
	preselectSupport = true,
	insertReplaceSupport = true,
	labelDetailsSupport = true,
	deprecatedSupport = true,
	commitCharactersSupport = true,
	tagSupport = { valueSet = { 1 } },
	resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	},
}

M.setup = function()
	local lsp = require "lspconfig"

	local servers = { "clangd", "rust_analyzer", "pyright", "zls" }
	for _, server in pairs(servers) do
		lsp[server].setup {
			on_attach = M.on_attach,
			capabilities = M.capabilities,
		}
	end
end

return M
