require("nvim-autopairs").setup {
	fast_wrap = {},
	disable_filetype = {
		"TelescopePrompt",
		"vim",
	},
}

require("cmp").event:on(
	"confirm_done",
	require("nvim-autopairs.completion.cmp").on_confirm_done()
)
