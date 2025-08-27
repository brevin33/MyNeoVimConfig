return {
	"folke/trouble.nvim",
	opts = {
		focus = true,
		open_no_results = true,
		--auto_jump = true,
		keys = {
			["<esc>"] = "close",
			["<cr>"] = "jump_close",
		},
	}, -- for default options, refer to the configuration section for custom setup.
	cmd = "Trouble",
	keys = {
		{
			"ge",
			"<cmd>Trouble diagnostics toggle<cr>",
			desc = "Diagnostics (Trouble)",
		},
	},
}
