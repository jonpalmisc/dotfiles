local jp = require "jp.core"

local ok, lsp = pcall(require, "lspconfig")
if not ok then
	return
end

local on_attach = function(client, buf)
	jp.buf_map(buf, "n", "<localleader>gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
	jp.buf_map(buf, "n", "<localleader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
	jp.buf_map(buf, "n", "<localleader>gr", "<cmd>lua vim.lsp.buf.references()<CR>")
	jp.buf_map(buf, "n", "<localleader>K", "<cmd>lua vim.lsp.buf.hover()<CR>")
	jp.buf_map(buf, "n", "<localleader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>")
	jp.buf_map(buf, "n", "<localleader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>")
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
	capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
end

local servers = { "clangd", "rust_analyzer", "tsserver", "pyright" }
for _, server in pairs(servers) do
	lsp[server].setup {
		on_attach = on_attach,
		capabilities = capabilities,
	}
end
