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
