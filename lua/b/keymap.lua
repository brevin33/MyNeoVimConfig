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
vim.keymap.set('n', '<leader>d', '<C-w>c')
vim.keymap.set('n', '<leader>l', '<C-w>l')
vim.keymap.set('n', '<leader>h', '<C-w>h')
vim.keymap.set('n', '<leader>j', '<C-w>j')
vim.keymap.set('n', '<leader>k', '<C-w>k')

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
