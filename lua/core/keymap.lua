vim.g.mapleader = " "
vim.keymap.set("n", " ", "<Nop>")

-- quit vim
vim.keymap.set("n", "<leader>q", function()
	vim.cmd(":wa!")
	vim.fn.jobstart({ "taskkill", "/F", "/PID", tostring(vim.fn.getpid()) })
end, { desc = "Save all and quit, or force quit on failure" })

vim.keymap.set("n", "<leader>f", ":w<cr>")

vim.keymap.set("n", "<leader>ft", function()
	print(vim.bo.filetype)
end, { desc = "Print filetype" })

-- git
vim.keymap.set("n", "gg", "<CMD>Neogit<CR>")

vim.keymap.set("n", "gs", "<cmd>SessionSearch<cr>")

vim.keymap.set("n", "gF", require("telescope").extensions.whaler.whaler)

-- oil set working directory
vim.api.nvim_create_autocmd("FileType", {
	pattern = "oil",
	callback = function()
		vim.keymap.set("n", "<leader>w", function()
			local oil_dir = require("oil").get_current_dir()
			vim.cmd("cd " .. oil_dir)
			print("Changed directory to: " .. oil_dir)
		end, { buffer = true, desc = "Set working directory to Oil dir" })
	end,
})

-- open tree sitter tree
vim.keymap.set("n", "<leader>i", "<cmd>InspectTree<cr>", { desc = "Open tree sitter tree" })

-- single line copilot accept
--vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.copilot_accept_single_line()", { expr = true, silent = true })
--vim.keymap.set("i", "<S-Tab>", "copilot#AcceptLine()", { expr = true, silent = true })
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
vim.keymap.set("n", "<leader>ai", function()
	vim.cmd("CopilotChatReset")
	vim.cmd("CopilotChatToggle")
	if vim.bo.filetype == "copilot-chat" then
		vim.cmd("startinsert")
	end
end, { desc = "Toggle Copilot Chat" })
vim.keymap.set("n", "<leader>am", "<CMD>CopilotChatModels<CR>", { desc = "Toggle Copilot Chat" })
vim.keymap.set("n", "<leader>aa", "<CMD>CopilotChatAgents<CR>", { desc = "Toggle Copilot Chat" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "undotree", -- or your actual filetype here
	callback = function()
		vim.keymap.set("n", "<Esc>", "<Cmd>UndotreeToggle<CR>", { buffer = true, noremap = true, silent = true })
	end,
})

-- undotree
vim.api.nvim_create_autocmd("FileType", {
	pattern = "copilot-chat", -- or your actual filetype here
	callback = function()
		vim.keymap.set("n", "<Esc>", "<Cmd>q<CR>", { buffer = true, noremap = true, silent = true })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "NeogitStatus", -- or your actual filetype here
	callback = function()
		vim.keymap.set("n", "<Esc>", "<Cmd>q<CR>", { buffer = true, noremap = true, silent = true })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown", -- or your actual filetype here
	callback = function()
		vim.keymap.set("n", "<Esc>", "<Cmd>q<CR>", { buffer = true, noremap = true, silent = true })
	end,
})

vim.keymap.set("n", "<Esc>", "<Cmd>DiffviewClose<CR>")

vim.api.nvim_create_autocmd("FileType", {
	pattern = "qf",    -- or your actual filetype here
	callback = function()
		vim.cmd("resize 20") -- Set to desired height
		vim.keymap.set("n", "<Esc>", "<Cmd>q<CR>", { buffer = true, noremap = true, silent = true })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "query", -- or your actual filetype here
	callback = function()
		vim.keymap.set("n", "<Esc>", "<Cmd>q<CR>", { buffer = true, noremap = true, silent = true })
	end,
})

-- session management
vim.keymap.set("n", "<leader>s", "<CMD>SessionSave<CR>", { desc = "Toggle Copilot Chat" })

function _G.copilot_accept_single_line()
	return vim.fn["copilot#Accept"](""):gsub("\n.*", "") -- remove everything after the first newline
end

-- debug
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "dap-view", "dap-view-term", "dap-repl" }, -- dap-repl is set by `nvim-dap`
	callback = function(evt)
		vim.keymap.set("n", "<Esc>", "<C-w>k", { buffer = evt.buf })
	end,
})

-- the goat of delete and paste
vim.keymap.set("n", "y", '"+y')
vim.keymap.set("n", "p", '"+p')
vim.keymap.set("n", "P", '"dp')
vim.keymap.set("n", "d", '"dd')
vim.keymap.set("n", "<leader>d", '"+d')
vim.keymap.set("n", "x", '"_x')

vim.keymap.set("v", "y", '"+y')
vim.keymap.set("v", "p", '"+p')
vim.keymap.set("v", "P", '"dp')
vim.keymap.set("v", "d", '"dd')
vim.keymap.set("v", "<leader>d", '"+d')
vim.keymap.set("v", "x", '"_x')

vim.keymap.set("x", "y", '"+y')
vim.keymap.set("x", "p", '"+p')
vim.keymap.set("x", "P", '"dp')
vim.keymap.set("x", "d", '"dd')
vim.keymap.set("x", "<leader>d", '"+d')
vim.keymap.set("x", "x", '"_x')

-- movement
vim.keymap.set("n", "J", "5j")
vim.keymap.set("n", "K", "5k")
vim.keymap.set("x", "J", "5j")
vim.keymap.set("x", "K", "5k")
vim.keymap.set("v", "J", "5j")
vim.keymap.set("v", "K", "5k")
vim.keymap.set("n", "O", "o<Esc>")

-- oil
vim.keymap.set("n", "<BS>", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- terminal
vim.keymap.set("n", "<leader>t", function()
	vim.cmd("tabnew | term")
	vim.cmd("startinsert")
end, { desc = "Open terminal and return to previous window on close" })
vim.api.nvim_create_autocmd("TermOpen", {
	callback = function()
		vim.keymap.set("n", "<Esc>", "<CMD>q<CR>", { buffer = true, desc = "Close terminal in normal mode" })
	end,
})
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "gf", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "gt", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "gb", builtin.buffers, { desc = "Telescope buffers" })

-- cmake
vim.keymap.set("n", "<leader>cb", function()
	vim.cmd.CMakeBuild()
	vim.cmd("wincmd w") -- Jump to quickfix window
end, { desc = "CMake Build and jump to quickfix" })

vim.keymap.set("n", "<leader>cg", vim.cmd.CMakeGenerate)
vim.keymap.set("n", "<leader>cc", vim.cmd.CMakeSelectBuildType)
vim.keymap.set("n", "<leader>ce", vim.cmd.CMakeQuickStart)
vim.keymap.set("n", "<leader>cs", vim.cmd.CMakeSettings)
vim.keymap.set("n", "<leader>ci", vim.cmd.CMakeInstall)
--vim.keymap.set("n", "<leader>ca", vim.cmd.CMakeLaunchArgs)
vim.keymap.set("n", "<leader>cp", vim.cmd.CMakeSelectLaunchTarget)
vim.keymap.set("n", "<leader>ct", vim.cmd.CMakeSelectBuildTarget)

-- window movement
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to below window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to above window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- ect
vim.api.nvim_set_keymap("n", "<leader>bn", ":bnext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>bp", ":bprev<CR>", { noremap = true, silent = true })

local cmp = require("cmp")

vim.keymap.set("i", "<Esc>", function()
	if cmp.visible() then
		cmp.select_next_item()
	end
	vim.cmd("stopinsert")
end, { noremap = true, silent = true })

local harpoon = require("harpoon")

local function index_of(items, length, element, config)
	local index = -1
	for i = 1, length do
		local itemCon = items[i]
		local item
		if itemCon == nil then
			item = nil
		else
			item = itemCon.value
		end
		if element == item then
			index = i
			break
		end
	end

	return index
end

vim.keymap.set("n", "<leader>m", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end)

vim.keymap.set("n", "M", function()
	local list = harpoon:list()
	local items = list.items
	local length = #items
	local current = list.config.create_list_item(list.config).value
	local idx = index_of(items, length, current, list.config)
	if idx ~= -1 then
		harpoon:list():remove_at(idx)
		items = list.items
		for i = 1, length do
			if list.items[i] == nil then
				if i < length then
					local item = list.items[i + 1]
					list:replace_at(i, item)
					list:remove_at(i + 1)
				end
			end
		end
	else
		harpoon:list():add()
	end
end)

vim.keymap.set("n", "m", function()
	local list = harpoon:list()
	local items = list.items
	local length = #items
	local current = list.config.create_list_item(list.config).value
	local idx = index_of(items, length, current, list.config)
	local selectIdx = idx + 1
	if idx == -1 then
		selectIdx = 1
	end
	if selectIdx > length then
		selectIdx = 1
	end
	harpoon:list():select(selectIdx)
end)

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
