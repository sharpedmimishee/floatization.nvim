local M = {}

local function floatize()
    local buf = vim.api.nvim_get_current_buf();

    local endline = vim.api.nvim_buf_line_count(buf)
    local content = vim.api.nvim_buf_get_lines(buf, 0, endline, false)

    vim.notify(table.concat(content))
    vim.api.nvim_buf_delete(buf, {})
    -- vim.api.nvim_set_current_buf(First_buf)
    local new_buf = vim.api.nvim_create_buf(false, true);

    local checker = vim.fn.bufnr("floatization-float");
    if checker ~= -1 then
        vim.api.nvim_buf_delete(checker, {})
    end

    vim.api.nvim_buf_set_name(new_buf, 'floatization-float')
    vim.api.nvim_open_win(new_buf, true,
        { relative = 'win', row = 5, col = 3, width = 230, height = 40 })
    vim.api.nvim_buf_set_lines(new_buf, 0, 0, true, content);
end
local forkey
local created
local typed_key
local count_key = 0;

---@param typed string
---@param disappear integer
---@param anchor string
local function key_appear(typed, disappear, anchor)
    if count_key >= disappear then
        count_key = 0
        typed_key = nil
    end
    if typed_key == nil then typed_key = typed else typed_key = typed_key .. typed end
    count_key = count_key + 1

    if created ~= true then
        forkey = vim.api.nvim_create_buf(false, true);
        created = true
    end
    vim.api.nvim_buf_set_name(forkey, 'floatization-forkey')
    vim.api.nvim_open_win(forkey, false, {
        relative = 'win',
        focusable = false,
        row = 0, -- ウィンドウの上部からの距離
        col = 1000, -- ウィンドウの左端からの距離
        width = 100,
        height = 1,
        anchor = anchor
    })


    vim.api.nvim_buf_set_lines(forkey, 0, 1, true, { typed_key });
end

function M.setup(opts)
    local buffer = opts.buffer;
    local commands = opts.commands;
    local key = opts.key;
    local disappear = opts.disappear;
    local anchor = opts.anchor;
    if anchor == nil then anchor = "NE" end
    First_buf = -1
    Command = "";
    vim.api.nvim_create_autocmd("CmdLineLeave", {
        callback = function()
            Command = vim.fn.getcmdline()
            First_buf = vim.api.nvim_get_current_buf()
        end
    })
    if buffer == true then
        vim.api.nvim_create_autocmd({ "BufEnter" }, {
            callback = function()
                for k, _ in pairs(commands) do
                    if commands[k] == Command then
                        floatize()
                        Command = "";
                        break;
                    end
                end
            end
        })
    end
    if key == true then
        vim.on_key(function(_key, typed) key_appear(typed, disappear, anchor) end)
    end
end

-- M.setup({ key = true, disappear = 10, anchor = "NE" })
