local map = vim.keymap.set

-- General
map("n", "<A-k>", ":m .-2<CR>==") -- Swap line up.
map("n", "<A-j>", ":m .+1<CR>==") -- Swap line down.

-- Telescope
map("n", "<leader>fb", "<cmd> :Telescope buffers <CR>")
map("n", "<leader>ff", "<cmd> :Telescope find_files <CR>")
map("n", "<leader>fw", "<cmd> :Telescope live_grep <CR>")
map("n", "<leader>fs", "<cmd> :Telescope lsp_document_symbols <CR>")
map("n", "<leader>fS", "<cmd> :Telescope lsp_workspace_symbols <CR>")
map("n", "<leader>fr", "<cmd> :Telescope lsp_references <CR>")

-- Tree
map("n", "<C-b>", "<cmd> :NvimTreeToggle <CR>")

-- Neogit
map("n", "<leader>gg", "<cmd> :Neogit <CR>")
