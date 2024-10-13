return {
    'rmagatti/auto-session',
    lazy = false,
    keys = {
        -- Will use Telescope if installed or a vim.ui.select picker otherwise
        { 'gs',        '<cmd>SessionSearch<CR>',         desc = 'Session search' },
        { '<leader>-', '<cmd>SessionToggleAutoSave<CR>', desc = 'Toggle autosave' },
    },
    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
        suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
        session_lens = {
            -- If load_on_setup is false, make sure you use `:SessionSearch` to open the picker as it will initialize everything first
            load_on_setup = true,
            previewer = false,
            mappings = {
                delete_session = { "n", "<leader>ds" },
            },
            -- Can also set some Telescope picker options
            -- For all options, see: https://github.com/nvim-telescope/telescope.nvim/blob/master/doc/telescope.txt#L112
            theme_conf = {
                border = true,
                -- layout_config = {
                --   width = 0.8, -- Can set width and height as percent of window
                --   height = 0.5,
                -- },
            },
        },
        -- log_level = 'debug',
    }
}
