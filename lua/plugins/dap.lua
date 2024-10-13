return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
        local dap = require("dap")
        require("nvim-dap-virtual-text").setup {}
        vim.keymap.set('n', '<F1>', function() require('dap').step_over() end)
        vim.keymap.set('n', '<F2>', function() require('dap').step_into() end)
        vim.keymap.set('n', '<F3>', function() require('dap').step_out() end)
        vim.keymap.set('n', '<F4>', function() require('dap').continue() end)
        vim.keymap.set('n', '<F5>', function()
            require('dap').disconnect()
            require('dap').close()
            require("dapui").close()
        end)
        vim.keymap.set('n', '<leader>e', function()
            require('dap').disconnect()
            require('dap').close()
            require("dapui").close()
        end)
        vim.keymap.set('n', '<Leader>v', function()
            require('dapui').eval(nil, { enter = true });
        end)
        vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
        vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
    end
}
