local jp = require "jp.core"

local ok, files = pcall(require, "mini.files")
if not ok then
	return
end

files.setup()

jp.map("n", "<leader>ft", "<cmd> :lua MiniFiles.open()<CR>")
