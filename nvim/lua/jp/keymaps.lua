--===-- jp/keymaps.lua ---------------------------------------------------------

local opts = { noremap = true, silent = true }
local map = vim.api.nvim_set_keymap

vim.g.mapleader = " "
vim.g.maplocalleader = " "

map("n", "<A-k>", ":m .-2<CR>==", opts) -- Swap line up
map("n", "<A-j>", ":m .+1<CR>==", opts) -- Swap line down

vim.cmd [[
augroup jp_git_rebase
	autocmd!
	autocmd FileType gitrebase nnoremap <buffer> <localleader>p :Pick<CR>
	autocmd FileType gitrebase nnoremap <buffer> <localleader>r :Reword<CR>
	autocmd FileType gitrebase nnoremap <buffer> <localleader>e :Edit<CR>
	autocmd FileType gitrebase nnoremap <buffer> <localleader>s :Squash<CR>
	autocmd FileType gitrebase nnoremap <buffer> <localleader>d :Drop<CR>
augroup END
]]
