vim.g.mapleader = " "
-- single best remaps ever
-- also this is why evil emacs is dog shit becuase it doesn't support clipboards
vim.keymap.set({ "n", "v", "x" }, "y", '"+y')
vim.keymap.set({ "n", "v", "x" }, "p", '"+p')
vim.keymap.set({ "n", "v", "x" }, "P", '"dp')
vim.keymap.set({ "n", "v", "x" }, "d", '"dd')
vim.keymap.set({ "n", "v", "x" }, "<leader>d", '"+d')
vim.keymap.set({ "n", "v", "x" }, "x", '"_x')

-- basic movement
vim.keymap.set({ "n", "v", "x" }, "J", "5j")
vim.keymap.set({ "n", "v", "x" }, "K", "5k")
vim.keymap.set("n", "h", function()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    if col == 0 then
        local line = vim.api.nvim_get_current_line()
        vim.api.nvim_set_current_line(" " .. line)
        vim.api.nvim_win_set_cursor(0, { row, 0 }) -- move to new space
    else
        vim.api.nvim_win_set_cursor(0, { row, col - 1 })
    end
end, { noremap = true, silent = true })

-- window movement
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to below window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to above window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

vim.keymap.set('n', 'O', 'o<Esc>')

vim.keymap.set({ "n", "v", "x" }, "gq", ":copen<CR>");
-- Mark initial tab and window
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.g.initial_tab = vim.api.nvim_get_current_tabpage()
        vim.g.initial_win = vim.api.nvim_get_current_win()
    end,
})
vim.keymap.set("n", "<Esc>", function()
    local current_tab = vim.api.nvim_get_current_tabpage()
    local current_win = vim.api.nvim_get_current_win()
    if current_win ~= vim.g.initial_win or current_tab ~= vim.g.initial_tab then
        vim.cmd("close")
    end
end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>t", function()
    vim.cmd("tabnew | term")
    vim.cmd("startinsert")
end, { desc = "Open terminal and return to previous window on close" })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = true
vim.o.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.o.errorfile = vim.fn.stdpath('data') .. "/nvim-error.log"
vim.o.swapfile = false
vim.o.undofile = true
vim.o.undodir = "C:/vim/undodir"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.termguicolors = true
vim.o.scrolloff = 99999
vim.o.showtabline = 0
vim.o.signcolumn = "no"
vim.o.hls = true
vim.o.laststatus = 0
vim.opt.fillchars = { eob = " " }
vim.opt.shell = "powershell.exe"
vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command /c"
vim.opt.shellquote = ""
vim.opt.shellxquote = ""
vim.opt.runtimepath:append(vim.fn.stdpath("config") .. "/syntax")
vim.opt.runtimepath:append(vim.fn.stdpath("config") .. "/bin")
vim.o.splitright = true

if vim.g.neovide then
    vim.o.guifont = "Roboto Mono:h19"
    vim.g.neovide_hide_mouse_when_typing = true
    vim.g.neovide_refresh_rate = 360
    vim.g.neovide_fullscreen = false
    vim.g.neovide_profiler = false
    vim.g.neovide_cursor_hack = true
    vim.g.neovide_cursor_animation_length = 0.0
    vim.g.neovide_cursor_short_animation_length = 0.0
    vim.g.neovide_cursor_trail_size = 1.0
    vim.g.neovide_cursor_animate_in_insert_mode = false
    vim.g.neovide_cursor_animate_command_line = false
    vim.g.neovide_cursor_antialiasing = true
    vim.g.neovide_scroll_animation_length = 0.
    vim.g.neovide_window_animation_duration = 0
    vim.g.neovide_cursor_animation_length = 0
end

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd("CursorMoved", {
    group = vim.api.nvim_create_augroup("auto-hlsearch", { clear = true }),
    callback = function()
        if vim.v.hlsearch == 1 and vim.fn.searchcount().exact_match == 0 then
            vim.schedule(function()
                vim.cmd.nohlsearch()
            end)
        end
    end,
})

vim.keymap.set("n", "<leader>i", function()
    print("cwd fn: " .. vim.fn.getcwd() .. " | cwd loop: " .. vim.loop.cwd());
end)

require("colorscheme").setup({})
require("colorscheme").colorscheme()
require("oil").setup({
    view_options = {
        show_hidden = true,
    },
    keymaps = {
        ["g?"] = { "actions.show_help", mode = "n" },
        ["<CR>"] = "actions.select",
        ["<C-r>"] = "actions.refresh",
        ["-"] = { "actions.parent", mode = "n" },
        ["_"] = { "actions.open_cwd", mode = "n" },
        ["`"] = { "actions.cd", mode = "n" },
        ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
        ["gx"] = "actions.open_external",
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },
    },

})
vim.keymap.set({ "n", "v", "x" }, "<BS>", "<CMD>Oil<CR>")
local current_session = nil
vim.api.nvim_create_autocmd("FileType", {
    pattern = "oil",
    callback = function()
        vim.keymap.set("n", "<leader>w", function()
            local oil_dir = require("oil").get_current_dir()
            if current_session ~= nil then
                require("mini.sessions").write(current_session)
            end
            vim.fn.chdir(oil_dir)
            set_current_session()
            if current_session ~= nil then
                require("mini.sessions").read(current_session)
            end
        end, { buffer = true, desc = "Set working directory to Oil dir" })
    end,
})
require("mini.pick").setup({})
vim.keymap.set({ "n", "v", "x" }, "gf", function() require("mini.pick").builtin.files({ cwd = vim.fn.getcwd() }) end)
vim.keymap.set({ "n", "v", "x" }, "gt", function() require("mini.pick").builtin.grep_live({ cwd = vim.fn.getcwd() }) end)
require("mini.move").setup({})
local sessions_dir = vim.fn.stdpath('data') .. '/sessions/'
function set_current_session(read)
    current_session = nil
    for _, session in ipairs(vim.fn.readdir(sessions_dir)) do
        if vim.fn.fnamemodify(vim.fn.getcwd(), ":t") == session then
            current_session = session
            break
        end
    end
end

require("mini.sessions").setup({
    directory = sessions_dir,
    file = '',
    autowrite = false,
    autoread = false,
    verbose = { read = false, write = false, delete = false },
    hooks = {
        post = {
            read = function()
                set_current_session()
            end
        },
        pre = {
            read = function()
            end
        },
    },

})

-- need to wait or else highlight and lsp will not work
vim.defer_fn(function()
    if vim.fn.argc() ~= 0 then
        set_current_session()
        if current_session ~= nil then
            require("mini.sessions").read(current_session)
        end
    end
end, 1)
vim.keymap.set("n", "<leader>s", ":mksession " .. sessions_dir .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. "<CR>")

vim.keymap.set('n', 'gs', function()
    require("mini.pick").start({
        source = {
            items = vim.fn.readdir(sessions_dir),
            choose = function(item)
                vim.cmd('wa')
                local session_path = item
                if current_session ~= nil then
                    require("mini.sessions").write(current_session)
                end
                require("mini.sessions").read(session_path)
            end,
            name = "Goto session:",
        },
    })
end)
vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        if current_session ~= nil then
            require("mini.sessions").write(current_session)
        end
    end,
})
require("mini.pairs").setup({})
require("mini.starter").setup({})
require("mason").setup({})

vim.lsp.enable({ "lua_ls", "clangd" })

vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function(args)
        vim.lsp.buf.format({
            async = false,
            timeout_ms = 500,
            bufnr = args.buf,
        })
    end,
})

vim.diagnostic.config({
    severity_sort = true,
    float = { border = "rounded", source = "if_many" },
    underline = {
        severity = { min = vim.diagnostic.severity.ERROR, max = vim.diagnostic.severity.ERROR },
    },
    signs = vim.g.have_nerd_font and {
        text = {
            [vim.diagnostic.severity.ERROR] = "E",
            [vim.diagnostic.severity.WARN] = "W",
            [vim.diagnostic.severity.INFO] = "I",
            [vim.diagnostic.severity.HINT] = "H",
        },
        severity = { min = vim.diagnostic.severity.ERROR, max = vim.diagnostic.severity.ERROR },
    } or {},
    virtual_text = {
        severity = { min = vim.diagnostic.severity.ERROR, max = vim.diagnostic.severity.ERROR },
        source = "if_many",
        spacing = 2,
        format = function(diagnostic)
            local diagnostic_message = {
                [vim.diagnostic.severity.ERROR] = diagnostic.message,
                [vim.diagnostic.severity.WARN] = diagnostic.message,
                [vim.diagnostic.severity.INFO] = diagnostic.message,
                [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
        end,
    },
})

vim.keymap.set("n", "gd", function()
    local params = vim.lsp.util.make_position_params()

    vim.lsp.buf_request(0, "textDocument/definition", params, function(_, result)
        if not result or vim.tbl_isempty(result) then
            vim.notify("No definition found")
            return
        end

        if #result == 1 then
            vim.lsp.util.jump_to_location(result[1], "utf-8")
        else
            vim.fn.setqflist(vim.lsp.util.locations_to_items(result))
            vim.cmd("copen")
        end
    end)
end, { desc = "LSP: Go to Definition" })

require("blink.cmp").setup(
    {
        keymap = {
            preset = "none",
            ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
            ["<C-e>"] = { "hide", "fallback" },
            ["<S-Tab>"] = {
                function(cmp)
                    if cmp.snippet_active() then
                        return cmp.accept()
                    else
                        return cmp.select_and_accept()
                    end
                end,
                "snippet_forward",
                "fallback",
            },
            ["<Up>"] = { "select_prev", "fallback" },
            ["<Down>"] = { "select_next", "fallback" },
            ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
            ["<C-n>"] = { "select_next", "fallback_to_mappings" },

            ["<C-b>"] = { "scroll_documentation_up", "fallback" },
            ["<C-f>"] = { "scroll_documentation_down", "fallback" },

            ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
        },
        appearance = {
            nerd_font_variant = "mono",
        },
        signature = {
            enabled = true,
        },
        completion = {
            documentation = { auto_show = true },
            menu = {
                direction_priority = { "n" },
                auto_show = true,
            },
        },
        sources = {
            default = { "lsp", "path", "buffer" },
            transform_items = function(_, items)
                return vim.tbl_filter(function(item)
                    return item.kind ~= require('blink.cmp.types').CompletionItemKind.Snippet
                end, items)
            end
        },
        fuzzy = {
            implementation = "lua",
        },
    }
)

require("supermaven-nvim").setup({
    keymaps = {
        accept_suggestion = "<Tab>",
    }
})


require("CopilotChat").setup(
    {
        model = "claude-sonnet-4.5",
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
    }
)

vim.keymap.set("n", "<leader>ai", function()
    vim.cmd("CopilotChatReset")
    vim.cmd("CopilotChatToggle")
    if vim.bo.filetype == "copilot-chat" then
        vim.cmd("startinsert")
    end
end, { desc = "Toggle Copilot Chat" })
-- open the old chat
vim.keymap.set("n", "<leader>ao", function()
    vim.cmd("CopilotChatToggle")
    if vim.bo.filetype == "copilot-chat" then
        vim.cmd("startinsert")
    end
end, { desc = "Toggle Old Copilot Chat" })
vim.keymap.set("n", "<leader>am", "<CMD>CopilotChatModels<CR>", { desc = "Toggle Copilot Chat" })
vim.keymap.set("n", "<leader>aa", "<CMD>CopilotChatAgents<CR>", { desc = "Toggle Copilot Chat" })



vim.g.undotree_WindowLayout = 3
vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>:UndotreeFocus<CR>", { noremap = true, silent = true })

require("builder").setup({})
vim.keymap.set({ "n", "v", "x" }, "<leader>bo", function() require("builder").open_config() end)
vim.keymap.set({ "n", "v", "x" }, "<leader>bb", function() require("builder").run_config() end)
vim.keymap.set({ "n", "v", "x" }, "<leader>ba", function()
    vim.ui.input({ prompt = "Enter your input: " }, function(input)
        if input then
            require("builder").add_config(input)
        end
    end)
end)
vim.keymap.set({ "n", "v", "x" }, "<leader>bs", function()
    local config_dir = require("builder").get_config_dir()
    require("mini.pick").start({
        source = {
            items = vim.fn.readdir(config_dir),
            choose = function(item)
                require("builder").select_config(item)
            end,
            name = "Build Config:",
        },
    })
end)



local raddbg = require("raddbg")
raddbg.setup({
    split_height = 20,
    breakpoint_color = "#51202a",
    keymaps = {
        target_menu = {
            select = "<CR>",
            enabled = "h",
            disabled = "l",
            delete = "d",
            toggle = "t",
        },
        breakpoint_menu = {
            select = "<CR>",
            delete = "d",
        },
    },
})

vim.keymap.set("n", "<leader>db", function()
    raddbg.break_point_menu()
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>dt", function()
    raddbg.target_menu()
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>dr", function()
    raddbg.run()
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>ddb", function()
    raddbg.remove_all_breakpoints()
end, { noremap = true, silent = true })

vim.keymap.set("n", "<A-h>", function()
    raddbg.toggle_breakpoint()
end, { noremap = true, silent = true })

vim.keymap.set("n", "_", function()
    raddbg.step_over_line()
end, { noremap = true, silent = true })

vim.keymap.set("n", "{", function()
    raddbg.step_into_line()
end, { noremap = true, silent = true })

vim.keymap.set("n", "}", function()
    raddbg.step_out()
end, { noremap = true, silent = true })

vim.keymap.set("n", '"', function()
    raddbg.continue()
end, { noremap = true, silent = true })

vim.keymap.set("n", "'", function()
    raddbg.kill()
end, { noremap = true, silent = true })

local function find_rad_files(root)
    local uv = vim.loop
    local queue = { { path = root, depth = 0 } }

    while #queue > 0 do
        local current = table.remove(queue, 1)
        if current.depth > 4 then
            break
        end
        local fd = uv.fs_scandir(current.path)
        if fd then
            while true do
                local name, typ = uv.fs_scandir_next(fd)
                if not name then
                    break
                end
                local fullpath = current.path .. "/" .. name
                if typ == "file" and name:match("%.rad$") then
                    return fullpath
                elseif typ == "directory" then
                    table.insert(queue, { path = fullpath, depth = current.depth + 1 })
                end
            end
        end
    end
    return nil
end

local function select_rad_project()
    local cwd = vim.fn.getcwd()
    local rad_project_file_path = find_rad_files(cwd)

    if rad_project_file_path == nil then
        print("nil rad project file path")
        return
    end

    raddbg.select_project(rad_project_file_path)
end

vim.keymap.set("n", "<leader>dp", function()
    select_rad_project()
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>do", function()
    if raddbg.is_rad_init() == false then
        select_rad_project()
    end
    raddbg.open()
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>da", function()
    if raddbg.is_rad_init() == false then
        print("raddbg not initialized")
        return
    end
    local function find_exe_files_recursive(dir)
        local results = {}
        for _, item in ipairs(vim.fn.readdir(dir)) do
            local full_path = dir .. "/" .. item
            if vim.fn.isdirectory(full_path) == 1 then
                local sub_results = find_exe_files_recursive(full_path)
                vim.list_extend(results, sub_results)
            elseif vim.endswith(item, ".exe") then
                table.insert(results, full_path)
            end
        end
        return results
    end
    local exe_files = find_exe_files_recursive(vim.fn.getcwd())
    require("mini.pick").start({
        source = {
            items = exe_files,
            choose = function(item)
                raddbg.add_target(item)
            end,
            name = "Add Executable:",
        },
    })
end, { noremap = true, silent = true })

require("trouble").setup(
    {
        focus = true,
        open_no_results = true,
        --auto_jump = true,
        keys = {
            ["<esc>"] = "close",
            ["<cr>"] = "jump_close",
        },
        filter = {
            severity = { min = vim.diagnostic.severity.ERROR },
        },
    }
)

vim.keymap.set("n", "ge", "<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR<cr>")

local groups = vim.api.nvim_get_hl(0, {}) -- get all highlight groups
for group, _ in pairs(groups) do
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group })
    if ok and hl.italic then
        hl.italic = false
        vim.api.nvim_set_hl(0, group, hl)
    end
end

vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        local data_dir = vim.fn.stdpath("data")
        local shada = data_dir .. '/shada'
        require('plenary.path'):new(shada):rm({ recursive = true })
    end,
})

vim.api.nvim_create_autocmd('DirChanged', {
    callback = function()
        vim.loop.chdir(vim.fn.getcwd())
    end,
})

require("nvim-treesitter").setup({})

local configs = require("nvim-treesitter.configs")

configs.setup({
    ensure_installed = {
        "c",
        "cpp",
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

require("Comment").setup({
    toggler = {
        line = "?",
    },
    opleader = {
        line = "?",
    },
})
require("todo-comments").setup({})

require("pin").setup({})
vim.keymap.set("n", "<A-J>", function() require("pin").pin(1) end)
vim.keymap.set("n", "<A-K>", function() require("pin").pin(2) end)
vim.keymap.set("n", "<A-L>", function() require("pin").pin(3) end)
vim.keymap.set("n", "<A-:>", function() require("pin").pin(4) end)
vim.keymap.set("n", "<A-j>", function() require("pin").goto_pin(1) end)
vim.keymap.set("n", "<A-k>", function() require("pin").goto_pin(2) end)
vim.keymap.set("n", "<A-l>", function() require("pin").goto_pin(3) end)
vim.keymap.set("n", "<A-;>", function() require("pin").goto_pin(4) end)
