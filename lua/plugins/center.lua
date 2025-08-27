return {
	"Aasim-A/scrollEOF.nvim",
	event = { "CursorMoved", "WinScrolled" },
	opts = {
		pattern = "*",
		insert_mode = true,
		floating = true,
		disabled_filetypes = { "help", "qf", "NvimTree", "TelescopePrompt", "dashboard", "terminal", "copilot-chat" },
		disabled_modes = { "t" },
	},
}
