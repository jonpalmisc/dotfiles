local jp = require "jp.core"

local ok, comment = pcall(require, "mini.comment")
if ok then
	comment.setup()
end

local ok, files = pcall(require, "mini.files")
if ok then
	files.setup()

	jp.map("n", "<leader>ft", "<cmd> :lua MiniFiles.open()<CR>")
end

local ok, pairs = pcall(require, "mini.pairs")
if ok then
	pairs.setup()
end
