vim.o.nu = true
vim.opt.termguicolors = true -- for init.lua
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.wrap = false
vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = "C:/vim/undodir"
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.completeopt = "menu,menuone,noinsert,noselect"

vim.g.undotree_WindowLayout = 3
vim.g.undotree_SplitWidth = math.floor(vim.o.columns / 2)

vim.cmd("colorscheme everblush") -- or whatever theme name

vim.opt.shell = "pwsh"
vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command /c"
vim.opt.shellquote = ""
vim.opt.shellxquote = ""

_G.enable_cmake_debug = true

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "solarized",
	-- group = ...,
	callback = function()
		vim.api.nvim_set_hl(0, "CopilotSuggestion", {
			fg = "#555555",
			ctermfg = 8,
			force = true,
		})
	end,
})

-- Remove italics from all highlight groups
local function disable_italics()
	local groups = vim.api.nvim_get_hl(0, {}) -- get all highlight groups
	for group, _ in pairs(groups) do
		local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group })
		if ok and hl.italic then
			hl.italic = false
			vim.api.nvim_set_hl(0, group, hl)
		end
	end
end

-- Apply after colorscheme is set
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = disable_italics,
})

-- Optionally run at startup for your current colorscheme
disable_italics()

vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.termguicolors = true
vim.o.scrolloff = 99999
vim.o.signcolumn = "no"
vim.o.updatetime = 50
vim.o.hls = true
vim.o.ruler = false
vim.o.spr = true
vim.o.aw = true
vim.o.awa = true

vim.o.laststatus = 0
vim.opt.fillchars = { eob = " " }
vim.o.sc = false
vim.o.stal = 0
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions"
vim.o.autoindent = true
vim.o.expandtab = false

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

require("telescope").load_extension("session-lens")
require("telescope").setup({
	defaults = {},
	pickers = {
		find_files = {
			hidden = true,
			theme = "dropdown",
			previewer = false,
		},
		live_grep = {
			theme = "dropdown",
			layout_config = {
				height = 0.5,
				width = 0.99,
				anchor = "S",
			},
		},
		buffers = {
			theme = "dropdown",
			layout_config = {
				height = 0.5,
				width = 0.99,
				anchor = "S",
			},
		},
		lsp_references = {
			theme = "dropdown",
			layout_config = {
				height = 0.5,
				width = 0.99,
				anchor = "S",
			},
		},
		["auto-session"] = {
			theme = "dropdown",
		},
	},
})

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		-- Only trigger if no files were passed in
		if vim.fn.argc() == 0 then
			vim.cmd("SessionSearch")
		end
	end,
})

vim.o.shell = "powershell.exe"
vim.o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
vim.o.shellquote = '"'
vim.o.shellxquote = ""

vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#144212", fg = "NONE" })
vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#4B0000", fg = "NONE" })

if vim.g.neovide then
	vim.o.guifont = "Roboto Mono:h16"
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

-- Copy highlights.scm for span from parser repo to Neovim queries directory on startup (Windows)
local function copy_span_highlights()
	local src = "C:/Users/brevi/dev/Span/tree-sitter-span/queries/highlights.scm"
	local dst_dir = vim.fn.stdpath("config") .. "/../nvim-data/lazy/nvim-treesitter/queries/span"
	-- check if directory exists
	if vim.fn.isdirectory(dst_dir) == 0 then
		print("Creating directory: " .. dst_dir)
		vim.fn.mkdir(dst_dir, "p")
	end
	local dst = dst_dir .. "/highlights.scm"
	print(dst)
	if vim.fn.filereadable(src) == 1 then
		if vim.fn.isdirectory(dst_dir) == 0 then
			vim.fn.mkdir(dst_dir, "p")
		end
		vim.fn.copy(src, dst)
	end
end
copy_span_highlights()

require("nvim-treesitter.parsers").get_parser_configs().span = {
	install_info = {
		url = "C:/Users/brevi/dev/Span/tree-sitter-span",
		files = { "src/parser.c", "src/scanner.c" },
		branch = "main",
	},
	filetype = "span",
}

vim.filetype.add({
	extension = {
		span = "span",
	},
})
--
-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
-- 	pattern = "*.tia",
-- 	command = "set filetype=c",
-- })
