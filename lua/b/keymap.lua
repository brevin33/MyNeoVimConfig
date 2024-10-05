vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
local builtin = require('telescope.builtin')
vim.keymap.set('n', 'gf', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', 'gg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', 'gb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', 'gh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>=', builtin.colorscheme, { desc = 'Telescope colorscheme' })
vim.keymap.set('n', 'J', 'jjjjj', { desc = 'big jump down' })
vim.keymap.set('n', 'K', 'kkkkk', { desc = 'big jump up' })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('x', 'p', "\"_dp")
vim.keymap.set('v', 'p', "\"_dp")
vim.keymap.set('n', '<leader>t', ':vs<CR>')
vim.keymap.set('n', '<leader>dt', '<C-w>c')
vim.keymap.set('n', '<leader>l', '<C-w>l')
vim.keymap.set('n', '<leader>h', '<C-w>h')
vim.keymap.set('n', '<leader>j', '<C-w>j')
vim.keymap.set('n', '<leader>k', '<C-w>k')
vim.keymap.set('n', '<CR>', 'nzz')


local lsp_zero = require('lsp-zero')

local lsp_attach = function(client, bufnr)
    local _ = client
    local opts = { buffer = bufnr }

    vim.keymap.set('n', 'L', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({ 'n', 'x' }, '<leader>q', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<leader>c', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    lsp_zero.buffer_autoformat()
end

lsp_zero.extend_lspconfig({
    sign_text = {
        error = '✘',
        warn = '▲',
        hint = '⚑',
        info = '»',
    },
    lsp_attach = lsp_attach,
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

require('mason').setup({
    ensure_installed = { 'clang-format', 'codelldb', 'lua_ls', 'clangd' }
})
require('mason-lspconfig').setup({
    -- Replace the language servers listed here
    -- with the ones you want to install
    ensure_installed = {},
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup({})
        end,
    }
})

local cmp = require('cmp')
local cmp_format = require('lsp-zero').cmp_format({ details = true })
local cmp_action = require('lsp-zero').cmp_action()
require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
    mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = cmp_action.luasnip_supertab(),
        ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
    }),
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    formatting = cmp_format,
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
})
vim.keymap.set("n", "ge", vim.diagnostic.goto_next)
vim.keymap.set("n", "gE", vim.diagnostic.goto_prev)

local status_ok, npairs = pcall(require, "nvim-autopairs")
if not status_ok then
    return
end

npairs.setup {
    check_ts = true,
    ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
        java = false,
    },
    disable_filetype = { "TelescopePrompt", "spectre_panel" },
    fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
        offset = 0,
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "PmenuSel",
        highlight_grey = "LineNr",
    },
}


local dap = require("dap")
local dapui = require("dapui")
dapui.setup()
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

local hmark = require("harpoon.mark")
local hui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", hmark.add_file)
vim.keymap.set("n", "<leader>f", hui.toggle_quick_menu)
vim.keymap.set("n", "<leader>1", function() hui.nav_file(1) end)
vim.keymap.set("n", "<leader>2", function() hui.nav_file(2) end)
vim.keymap.set("n", "<leader>3", function() hui.nav_file(3) end)
vim.keymap.set("n", "<leader>4", function() hui.nav_file(4) end)
vim.keymap.set("n", "<leader>5", function() hui.nav_file(5) end)
vim.keymap.set("n", "<leader>6", function() hui.nav_file(6) end)
vim.keymap.set("n", "<leader>7", function() hui.nav_file(7) end)
vim.keymap.set("n", "<leader>8", function() hui.nav_file(8) end)
vim.keymap.set("n", "<leader>9", function() hui.nav_file(9) end)


local osys = require("cmake-tools.osys")
require("cmake-tools").setup {
    cmake_command = "cmake",                                          -- this is used to specify cmake command path
    ctest_command = "ctest",                                          -- this is used to specify ctest command path
    cmake_use_preset = true,
    cmake_regenerate_on_save = true,                                  -- auto generate when save CMakeLists.txt
    cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" }, -- this will be passed when invoke `CMakeGenerate`
    cmake_build_options = {},                                         -- this will be passed when invoke `CMakeBuild`
    -- support macro expansion:
    --       ${kit}
    --       ${kitGenerator}
    --       ${variant:xx}
    cmake_build_directory = function()
        if osys.iswin32 then
            return "out\\${variant:buildType}"
        end
        return "out/${variant:buildType}"
    end,                                         -- this is used to specify generate directory for cmake, allows macro expansion, can be a string or a function returning the string, relative to cwd.
    cmake_soft_link_compile_commands = true,     -- this will automatically make a soft link from compile commands file to project root dir
    cmake_compile_commands_from_lsp = false,     -- this will automatically set compile commands file location using lsp, to use it, please set `cmake_soft_link_compile_commands` to false
    cmake_kits_path = nil,                       -- this is used to specify global cmake kits path, see CMakeKits for detailed usage
    cmake_variants_message = {
        short = { show = true },                 -- whether to show short message
        long = { show = true, max_length = 40 }, -- whether to show long message
    },
    cmake_dap_configuration = {                  -- debug settings for cmake
        name = "cpp",
        type = "codelldb",
        request = "launch",
        stopOnEntry = false,
        runInTerminal = true,
        console = "integratedTerminal",
    },
    cmake_executor = {                          -- executor to use
        name = "quickfix",                      -- name of the executor
        opts = {},                              -- the options the executor will get, possible values depend on the executor type. See `default_opts` for possible values.
        default_opts = {                        -- a list of default and possible values for executors
            quickfix = {
                show = "always",                -- "always", "only_on_error"
                position = "belowright",        -- "vertical", "horizontal", "leftabove", "aboveleft", "rightbelow", "belowright", "topleft", "botright", use `:h vertical` for example to see help on them
                size = 10,
                encoding = "utf-8",             -- if encoding is not "utf-8", it will be converted to "utf-8" using `vim.fn.iconv`
                auto_close_when_success = true, -- typically, you can use it with the "always" option; it will auto-close the quickfix buffer if the execution is successful.
            },
            toggleterm = {
                direction = "float",   -- 'vertical' | 'horizontal' | 'tab' | 'float'
                close_on_exit = false, -- whether close the terminal when exit
                auto_scroll = true,    -- whether auto scroll to the bottom
                singleton = true,      -- single instance, autocloses the opened one, if present
            },
            overseer = {
                new_task_opts = {
                    strategy = {
                        "toggleterm",
                        direction = "horizontal",
                        autos_croll = true,
                        quit_on_exit = "success"
                    }
                }, -- options to pass into the `overseer.new_task` command
                on_new_task = function(task)
                    require("overseer").open(
                        { enter = false, direction = "right" }
                    )
                end, -- a function that gets overseer.Task when it is created, before calling `task:start`
            },
            terminal = {
                name = "Main Terminal",
                prefix_name = "[CMakeTools]: ", -- This must be included and must be unique, otherwise the terminals will not work. Do not use a simple spacebar " ", or any generic name
                split_direction = "horizontal", -- "horizontal", "vertical"
                split_size = 11,

                -- Window handling
                single_terminal_per_instance = true,  -- Single viewport, multiple windows
                single_terminal_per_tab = true,       -- Single viewport per tab
                keep_terminal_static_location = true, -- Static location of the viewport if avialable
                auto_resize = true,                   -- Resize the terminal if it already exists

                -- Running Tasks
                start_insert = false,       -- If you want to enter terminal with :startinsert upon using :CMakeRun
                focus = false,              -- Focus on terminal when cmake task is launched.
                do_not_add_newline = false, -- Do not hit enter on the command inserted when using :CMakeRun, allowing a chance to review or modify the command before hitting enter.
            },                              -- terminal executor uses the values in cmake_terminal
        },
    },
    cmake_runner = {                     -- runner to use
        name = "terminal",               -- name of the runner
        opts = {},                       -- the options the runner will get, possible values depend on the runner type. See `default_opts` for possible values.
        default_opts = {                 -- a list of default and possible values for runners
            quickfix = {
                show = "always",         -- "always", "only_on_error"
                position = "belowright", -- "bottom", "top"
                size = 10,
                encoding = "utf-8",
                auto_close_when_success = true, -- typically, you can use it with the "always" option; it will auto-close the quickfix buffer if the execution is successful.
            },
            toggleterm = {
                direction = "float",   -- 'vertical' | 'horizontal' | 'tab' | 'float'
                close_on_exit = false, -- whether close the terminal when exit
                auto_scroll = true,    -- whether auto scroll to the bottom
                singleton = true,      -- single instance, autocloses the opened one, if present
            },
            overseer = {
                new_task_opts = {
                    strategy = {
                        "toggleterm",
                        direction = "horizontal",
                        autos_croll = true,
                        quit_on_exit = "success"
                    }
                },   -- options to pass into the `overseer.new_task` command
                on_new_task = function(task)
                end, -- a function that gets overseer.Task when it is created, before calling `task:start`
            },
            terminal = {
                name = "Main Terminal",
                prefix_name = "[CMakeTools]: ", -- This must be included and must be unique, otherwise the terminals will not work. Do not use a simple spacebar " ", or any generic name
                split_direction = "horizontal", -- "horizontal", "vertical"
                split_size = 11,

                -- Window handling
                single_terminal_per_instance = true,  -- Single viewport, multiple windows
                single_terminal_per_tab = true,       -- Single viewport per tab
                keep_terminal_static_location = true, -- Static location of the viewport if avialable
                auto_resize = true,                   -- Resize the terminal if it already exists

                -- Running Tasks
                start_insert = false,       -- If you want to enter terminal with :startinsert upon using :CMakeRun
                focus = false,              -- Focus on terminal when cmake task is launched.
                do_not_add_newline = false, -- Do not hit enter on the command inserted when using :CMakeRun, allowing a chance to review or modify the command before hitting enter.
            },
        },
    },
    cmake_notifications = {
        runner = { enabled = true },
        executor = { enabled = true },
        spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }, -- icons used for progress display
        refresh_rate_ms = 100, -- how often to iterate icons
    },
    cmake_virtual_text_support = true, -- Show the target related to current file using virtual text (at right corner)
}

vim.keymap.set("n", "<leader>cb", vim.cmd.CMakeBuild)
vim.keymap.set("n", "<leader>cr", vim.cmd.CMakeDebug)
vim.keymap.set("n", "<leader>cg", vim.cmd.CMakeGenerate)
vim.keymap.set("n", "<leader>cc", vim.cmd.CMakeSelectBuildType)
vim.keymap.set("n", "<leader>ce", vim.cmd.CMakeQuickStart)
vim.keymap.set("n", "<leader>cs", vim.cmd.CMakeSettings)
vim.keymap.set("n", "<leader>ci", vim.cmd.CMakeInstall)
vim.keymap.set("n", "<leader>ca", vim.cmd.CMakeLaunchArgs)
vim.keymap.set("n", "<leader>cp", vim.cmd.CMakeSelectBuildTarget)
vim.keymap.set("n", "<leader>ct", vim.cmd.CMakeRunTest)
vim.keymap.set("n", "<leader>dc", vim.cmd.CMakeClose)

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}
