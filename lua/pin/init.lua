local M = {}

local pin_state = {
    pinned_spots = {},
    cwd = vim.fn.getcwd(),
}

function M.state_folder()
    local state_folder = vim.fn.stdpath('data') .. '/pin'
    vim.fn.mkdir(state_folder, 'p')
    return state_folder
end

local function get_file_state()
    local line = vim.api.nvim_win_get_cursor(0)[1]
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local filepath = vim.api.nvim_buf_get_name(0)
    return { line = line, col = col, filepath = filepath }
end

local function load_file_state(state)
    local line = state.line
    local col = state.col
    local filepath = state.filepath
    local filepath_cur = vim.api.nvim_buf_get_name(0)
    if filepath == filepath_cur then
        return
    end
    vim.cmd('e ' .. filepath)
    vim.schedule(function() pcall(vim.api.nvim_win_set_cursor, 0, { line, col }) end)
end

local function save_state(cwd)
    local state_folder = M.state_folder()
    local dir_name = vim.fn.fnamemodify(cwd, ':t')
    local state_file = state_folder .. '/' .. dir_name .. '.pin'
    local file = io.open(state_file, "w")
    if not file then
        return
    end
    file:write(vim.fn.json_encode(pin_state.pinned_spots))
    file:close()
end

local function load_state(cwd)
    pin_state.cwd = cwd
    local state_folder = M.state_folder()
    local dir_name = vim.fn.fnamemodify(cwd, ':t')
    local state_file = state_folder .. '/' .. dir_name .. '.pin'
    if vim.fn.filereadable(state_file) ~= 1 then
        pin_state.pinned_spots = {}
        return
    end
    local file = io.open(state_file, "r")
    local content = file:read("*a")
    file:close()
    local state = vim.fn.json_decode(content)
    if state then
        pin_state.pinned_spots = state
    else
        print("failed to load state from " .. state_file)
    end
end

function M.setup(opts)
    vim.api.nvim_create_autocmd("BufEnter", {
        callback = function(args)
            local previous_buf = vim.fn.bufnr('#')
            if previous_buf ~= -1 then
                local previous_file = vim.api.nvim_buf_get_name(previous_buf)
                if previous_file ~= "" and vim.api.nvim_buf_is_valid(previous_buf) then
                    if vim.fn.filereadable(previous_file) == 1 then
                        local pos = vim.api.nvim_buf_get_mark(previous_buf, '"')
                        local line, col = pos[1], pos[2]
                        local state = { line = line, col = col, filepath = previous_file }
                        for _, pin in ipairs(pin_state.pinned_spots) do
                            if pin.filepath == state.filepath then
                                pin.line = state.line
                                pin.col = state.col
                            end
                        end
                    end
                end
            end
        end,
    })
    vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
            save_state(pin_state.cwd)
        end,
    })
    vim.api.nvim_create_autocmd("DirChanged", {
        callback = function(ev)
            save_state(pin_state.cwd)
            load_state(vim.fn.getcwd())
        end,
    })
    load_state(vim.fn.getcwd())
end

function M.pin(id)
    local state = get_file_state()
    pin_state.pinned_spots[id] = state
end

function M.unpin(id)
    local state = pin_state.pinned_spots[id]
    if state then
        pin_state.pinned_spots[id] = nil
    else
        print("No pin found for id: " .. id)
    end
end

function M.goto_pin(id)
    local state = pin_state.pinned_spots[id]
    if state then
        load_file_state(state)
    else
        print("No pin found for id: " .. id)
    end
end

return M
