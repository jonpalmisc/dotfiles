--===-- jp/mod/completion.lua --------------------------------------------------

local ok, cmp = pcall(require, "cmp")
if not ok then
	return
end

local compare = require('cmp.config.compare')

local ok, luasnip = pcall(require, "luasnip")
if not ok then
	return
end

-- Custom format function to limit dialog width
local format = function (entry, item)
	local MIN_WIDTH = 16
	local MAX_WIDTH = 32

	local label = item.abbr

	local truncated_label = vim.fn.strcharpart(label, 0, MAX_WIDTH)
	if truncated_label ~= label then
		item.abbr = truncated_label .. '…'
	elseif string.len(label) < MIN_WIDTH then
		local padding = string.rep(' ', MIN_WIDTH - string.len(label))
		item.abbr = label .. padding
	end

	return item
end

cmp.setup {
	view = {
		entries = "native",
	},
	formatting = {
		format = format
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = {
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<CR>"] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},

		["<Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end,
		["<S-Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end,
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
	},
}
