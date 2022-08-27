--==--{ bindings.lua - Key bindings for built-in and plugin operations }--------

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
