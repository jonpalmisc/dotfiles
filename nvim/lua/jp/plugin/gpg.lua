function encrypt_selection(opts)
	vim.ui.input({ prompt = "Passphrase: "}, function(passphrase) 
		local output = vim.fn.system("gpg --batch --symmetric --armor --input - --output - --passphrase " .. passphrase, true)
		local cb = vim.api.nvim_get_current_buf()
		vim.api.nvim_buf_set_lines(cb, 0, 0, false, {output})
	end)
end

function decrypt_selection(opts)
	vim.ui.input({ prompt = "Passphrase: "}, function(passphrase) 
		vim.api.nvim_exec("gpg --batch --symmetric --armor --input - --output - --passphrase " .. passphrase, true)
	end)
end

vim.api.nvim_create_user_command("GPGEncrypt", encrypt_selection, {})
vim.api.nvim_create_user_command("GPGDecrypt", decrypt_selection, {})
