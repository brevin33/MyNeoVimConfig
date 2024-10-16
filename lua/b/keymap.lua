vim.g.mapleader = " "
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "<leader>g", '<CMD>tab Git<CR>')
local builtin = require('telescope.builtin')
vim.keymap.set('n', 'gf', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', 'gt', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', 'gb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', 'gg', builtin.git_files, { desc = 'Telescope git files' })
vim.keymap.set('n', 'gg', builtin.git_files, { desc = 'Telescope git files' })
vim.keymap.set('n', 'gw', "<CMD>TodoTelescope<CR>", { desc = 'Telescope Todo/Work' })
vim.keymap.set('n', '<leader>=', builtin.colorscheme, { desc = 'Telescope colorscheme' })
vim.keymap.set('n', 'J', 'jjjjj', { desc = 'big jump down' })
vim.keymap.set('n', 'K', 'kkkkk', { desc = 'big jump up' })
vim.keymap.set('v', 'J', "<CMD>m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', "<CMD>m '<-2<CR>gv=gv")
vim.keymap.set('x', 'p', "\"_dp")
vim.keymap.set('v', 'p', "\"_dp")
vim.keymap.set('n', '<leader><Tab>', '<CMD>vs<CR>')
vim.keymap.set('n', 'd<Tab>', '<C-w>c')
vim.keymap.set('n', '<leader>l', '<C-w>l')
vim.keymap.set('n', '<leader>h', '<C-w>h')
vim.keymap.set('n', '<leader>j', '<C-w>j')
vim.keymap.set('n', '<leader>k', '<C-w>k')
vim.keymap.set('n', '<CR>', 'nzz')
vim.keymap.set('n', '<leader>q', '<CMD>wa<CR><CMD>qa<CR>')
vim.keymap.set('n', '<leader>s', '<CMD>wa<CR>')

vim.keymap.set("n", "<leader>t", '<CMD>ToggleTerm<CR>i')
vim.keymap.set("t", "<Esc>", '<C-\\><C-n><CMD>ToggleTerm<CR>')
vim.keymap.set("n", " ", "<Nop>");
vim.keymap.set("t", "<S-Tab>", "<C-\\><C-n>")
vim.keymap.set("n", "<leader>!", "<CMD>SessionSave<CR>")


-- the goat of delete and paste
vim.keymap.set("n", "y", "\"+y")
vim.keymap.set("n", "p", "\"+p")
vim.keymap.set("n", "<leader>p", "\"dp")
vim.keymap.set("n", "d", "\"dd")
vim.keymap.set("n", "<leader>d", "\"+d")
vim.keymap.set("n", "x", "\"_x")

vim.keymap.set("v", "y", "\"+y")
vim.keymap.set("v", "p", "\"+p")
vim.keymap.set("v", "<leader>p", "\"dp")
vim.keymap.set("v", "d", "\"dd")
vim.keymap.set("v", "<leader>d", "\"+d")
vim.keymap.set("v", "x", "\"_x")

vim.keymap.set("x", "y", "\"+y")
vim.keymap.set("x", "p", "\"+p")
vim.keymap.set("x", "<leader>p", "\"dp")
vim.keymap.set("x", "d", "\"dd")
vim.keymap.set("x", "<leader>d", "\"+d")
vim.keymap.set("x", "x", "\"_x")


local lsp_zero = require('lsp-zero')

local lsp_attach = function(client, bufnr)
	local _ = client
	local opts = { buffer = bufnr }

	vim.keymap.set('n', 'L', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
	vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
	vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
	vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
	vim.keymap.set('n', 'gh', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
	vim.keymap.set('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
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

require("dapui").setup()
local dap, dapui = require("dap"), require("dapui")
dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end
require('mason').setup({
	ensure_installed = { 'clang-format', 'cpptools', 'lua_ls', 'clangd' }
})
require("mason-nvim-dap").setup({
	ensure_installed = { "codelldb" },
	automatic_installation = true,
	handlers = {},
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
		['<CR>'] = cmp.mapping.confirm({ select = false }),
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
	cmake_dap_configuration = { -- debug settings for cmake
		name = "cpp",
		type = "codelldb",
		request = "launch",
		stopOnEntry = false,
		runInTerminal = true,
		console = "integratedTerminal",
	},
}

local lspdir = vim.fn.getcwd() .. "/out/lsp"
local cwd = vim.fn.getcwd()
cwd = string.gsub(cwd, '\\', '/')
lspdir = string.gsub(lspdir, '\\', '/')

function CopyFile(src, destDir)
	-- Add a 3-second delay before starting the file copy
	vim.defer_fn(function()
		local infile = io.open(src, "rb") -- Open source file in read mode (binary)

		if infile then
			-- Extract the filename from the source path
			local filename = vim.fn.fnamemodify(src, ":t") -- Get the filename from the src path
			local dest = destDir .. "/" .. filename -- Construct the full destination path

			-- Open destination file in write mode (binary)
			local outfile = io.open(dest, "wb")

			if outfile then
				local content = infile:read("*all") -- Read the entire source file
				outfile:write(content)  -- Write the content to the destination file
				infile:close()          -- Close the source file
				outfile:close()         -- Close the destination file
				print("File copied from " .. src .. " to " .. dest)
			else
				print("Error opening destination file. Check the path!")
			end
		else
			print("Error opening source file. Check the path!")
		end
	end, 3000) -- 3000 milliseconds (3 seconds)
end

vim.keymap.set("n", "<leader>cl",
	'<CMD>CMakeGenerate -G Ninja -B ' ..
	lspdir ..
	' -DCMAKE_EXPORT_COMPILE_COMMANDS=ON<CR>' ..
	'<CMD>lua CopyFile("' .. lspdir .. '/compile_commands.json", "' .. cwd .. '")<CR>',
	{ noremap = true, silent = true }
)

vim.keymap.set("n", "<leader>cb", vim.cmd.CMakeBuild)
vim.keymap.set("n", "<leader>cr", vim.cmd.CMakeDebug)
vim.keymap.set("n", "<leader>cg", vim.cmd.CMakeGenerate)
vim.keymap.set("n", "<leader>cc", vim.cmd.CMakeSelectBuildType)
vim.keymap.set("n", "<leader>ce", vim.cmd.CMakeQuickStart)
vim.keymap.set("n", "<leader>cs", vim.cmd.CMakeSettings)
vim.keymap.set("n", "<leader>ci", vim.cmd.CMakeInstall)
vim.keymap.set("n", "<leader>ca", vim.cmd.CMakeLaunchArgs)
vim.keymap.set("n", "<leader>cp", vim.cmd.CMakeSelectLaunchTarget)
vim.keymap.set("n", "<leader>ct", vim.cmd.CMakeSelectBuildTarget)
