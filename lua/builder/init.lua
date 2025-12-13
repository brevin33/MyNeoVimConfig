local M = {}

local settings = {
    config_file = nil,
}

function M.save_state()
    if (settings.config_file == nil) then
        return
    end
    local data_dir = vim.fn.stdpath('data')
    local config_dir = data_dir .. '/project_configs'
    vim.fn.mkdir(config_dir, "p")
    local cwd = vim.fn.getcwd()
    local dir_name = vim.fn.fnamemodify(cwd, ':t')
    local save_file = config_dir .. '/' .. dir_name .. '.save'
    local file = io.open(save_file, "w")
    if file then
        file:write(settings.config_file)
        file:close()
    else
        print("failed to write to file")
    end
end

function M.load_state()
    local data_dir = vim.fn.stdpath('data')
    local config_dir = data_dir .. '/project_configs'
    vim.fn.mkdir(config_dir, "p")
    local cwd = vim.fn.getcwd()
    local dir_name = vim.fn.fnamemodify(cwd, ':t')
    local save_file = config_dir .. '/' .. dir_name .. '.save'
    if vim.loop.fs_stat(save_file) == nil then
        return
    end
    local file = io.open(save_file, "r")
    local content = file:read("*a")
    file:close()
    print(content)
    settings.config_file = content
end

function M.get_config_file()
    local dir = vim.fn.fnamemodify(settings.config_file, ":h")
    local cwd = vim.fn.getcwd()
    local dir_name = vim.fn.fnamemodify(dir, ':t')
    local cwd_name = vim.fn.fnamemodify(cwd, ':t')
    if cwd_name ~= dir_name then
        settings.config_file = nil
    end
    return settings.config_file
end

function M.get_config_dir()
    local data_dir = vim.fn.stdpath('data')
    local cwd = vim.fn.getcwd()
    local dir_name = vim.fn.fnamemodify(cwd, ':t')
    local config_dir = data_dir .. '/project_configs'
    vim.fn.mkdir(config_dir, "p")
    local local_config_dir = config_dir .. '/' .. dir_name
    vim.fn.mkdir(local_config_dir, "p")
    return local_config_dir
end

function M.add_config(config_name)
    local config_dir = M.get_config_dir()
    local config_path = config_dir .. '/' .. config_name .. '.bat'
    settings.config_file = config_path
    vim.cmd('tabedit ' .. vim.fn.fnameescape(config_path))
end

function M.select_config(config_name)
    local config_dir = M.get_config_dir()
    local config_path = config_dir .. '/' .. config_name
    if vim.loop.fs_stat(config_path) == nil then
        vim.print("Config file does not exist")
        return
    end
    settings.config_file = config_path
end

function M.open_config()
    local config_path = M.get_config_file()
    if (config_path == nil) then
        vim.print("No config file selected")
        return
    end
    print(config_path)
    vim.cmd('tabedit ' .. vim.fn.fnameescape(config_path))
end

function M.run_config()
    local config_path = M.get_config_file()
    if (config_path == nil) then
        vim.print("No config file selected")
        return
    end
    config_path = config_path:gsub('\\', '/')

    -- Create a new scratch buffer for output
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    vim.cmd('botright 15split')
    vim.api.nvim_win_set_buf(0, buf)

    local line_count = 0
    local first_output = true

    vim.fn.jobstart({ config_path }, {
        stdout_buffered = false,
        stderr_buffered = false,
        on_stdout = function(_, data)
            if data then
                -- Remove carriage returns from each line
                for i, line in ipairs(data) do
                    data[i] = line:gsub('\r', '')
                end
                local last_line = vim.api.nvim_buf_line_count(buf) - 1
                local last_line_content = vim.api.nvim_buf_get_lines(buf, last_line, last_line + 1, false)[1] or ""
                local end_col = #last_line_content
                vim.api.nvim_buf_set_text(buf, last_line, end_col, last_line, end_col, data)

                -- Remove the first line after first output
                if first_output then
                    vim.api.nvim_buf_set_lines(buf, 0, 1, false, {})
                    first_output = false
                end
            end
        end,
        on_stderr = function(_, data)
            if data then
                -- Remove carriage returns from each line
                for i, line in ipairs(data) do
                    data[i] = line:gsub('\r', '')
                end
                local last_line = vim.api.nvim_buf_line_count(buf) - 1
                local last_line_content = vim.api.nvim_buf_get_lines(buf, last_line, last_line + 1, false)[1] or ""
                local end_col = #last_line_content

                vim.api.nvim_buf_set_text(buf, last_line, end_col, last_line, end_col, data)

                -- Remove the first line after first output
                if first_output then
                    vim.api.nvim_buf_set_lines(buf, 0, 1, false, {})
                    first_output = false
                end
            end
        end,
        on_exit = function(_, code)
            local last_line = vim.api.nvim_buf_line_count(buf) - 1
            local last_line_content = vim.api.nvim_buf_get_lines(buf, last_line, last_line + 1, false)[1] or ""
            local end_col = #last_line_content
            local message = "Build finished with exit code: " .. code
            vim.api.nvim_buf_set_text(buf, last_line, end_col, last_line, end_col, { message })
        end,
    })
end

return M
