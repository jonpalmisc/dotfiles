local M = {}

function M.buf_map(id, mode, keys, command)
	vim.api.nvim_buf_set_keymap(
		id,
		mode,
		keys,
		command,
		{ noremap = true, silent = true }
	)
end

function M.map(mode, keys, command)
	vim.api.nvim_set_keymap(mode, keys, command, { noremap = true, silent = true })
end

function M.set_vim_opts(opts)
	for k, v in pairs(opts) do
		vim.opt[k] = v
	end
end

return M
