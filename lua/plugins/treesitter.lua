return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = {
				"c",
				"cpp",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"elixir",
				"heex",
				"javascript",
				"html",
				"python",
				"go",
				"rust",
			},
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		})
		vim.opt_local.formatoptions:remove({ "r", "o" })
	end,
}
