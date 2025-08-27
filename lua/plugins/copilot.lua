return {
	{
		"supermaven-inc/supermaven-nvim",
		config = function()
			require("supermaven-nvim").setup({
				keymaps = {
					accept_suggestion = "<Tab>",
				},
			})
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "github/copilot.vim" },              -- or zbirenbaum/copilot.lua
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		},
		-- build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			-- See Configuration section for options
			context = { "buffer", "files:*.h", "files:*.hpp" },
			mappings = {
				submit_prompt = {
					normal = "<CR>",
					insert = "<CR>",
				},
				complete = {
					insert = "~",
				},
				show_diff = {
					full_diff = true,
				},
			},
		},
		-- See Commands section for default commands if you want to lazy load on them
	},
}
