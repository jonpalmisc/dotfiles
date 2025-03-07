local augroup = vim.api.nvim_create_augroup("JPGitRebase", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "gitrebase",
	group = augroup,
	callback = function()
		local map = vim.keymap.set
		local opts = { noremap = true, silent = true, buffer = true }

		map("n", "p", ":Pick <CR>", opts)
		map("n", "r", ":Reword<CR>")
		map("n", "e", ":Edit<CR>")
		map("n", "s", ":Squash<CR>")
		map("n", "f", ":Fixup<CR>")
		map("n", "d", ":Drop<CR>")
	end,
})
