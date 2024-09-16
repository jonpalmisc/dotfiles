local cmp = require "cmp"

return {
	view = {
		entries = "native",
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = {
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<CR>"] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},

		["<Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif require("luasnip").expand_or_jumpable() then
				require("luasnip").expand_or_jump()
			else
				fallback()
			end
		end,
		["<S-Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif require("luasnip").jumpable(-1) then
				require("luasnip").jump(-1)
			else
				fallback()
			end
		end,
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "nvim_lua" },
		{ name = "path" },
	},
}
