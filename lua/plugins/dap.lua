return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"theHamsta/nvim-dap-virtual-text", { "igorlfs/nvim-dap-view", opts = {} },
	},
	config = function()
		local dap = require("dap")
		require("nvim-dap-virtual-text").setup {}
		vim.keymap.set('n', 'A', function() require('dap').step_over() end)
		vim.keymap.set('n', 'S', function() require('dap').step_into() end)
		vim.keymap.set('n', 'D', function() require('dap').step_out() end)
		vim.keymap.set('n', 'F', function() require('dap').continue() end)
		vim.keymap.set('n', '<leader>e', function()
			require('dap').disconnect()
			require('dap').close()
			require("dap-view").close()
		end)
		vim.keymap.set("n", "<leader>w", function()
			require("dap-view").add_expr()
		end)
		vim.keymap.set("n", "G", function()
			local widgets = require("dap.ui.widgets")
			widgets.centered_float(widgets.scopes, { border = "rounded" })
		end)
		vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
		dap.listeners.before.attach.dapui_config = function()
			require("dap-view").open()
		end
		dap.listeners.before.launch.dapui_config = function()
			require("dap-view").open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			require("dap-view").close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			require("dap-view").close()
		end
	end
}
