if vim.g.vscode then
    return
end

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Turn off relative line numbers for inactive windows
autocmd({ "WinEnter", "WinLeave" }, {
    group = augroup("LocalNumbers", { clear = true }),
    callback = function(ctx)
        -- Don't target float windows (which don't have `file` named) or Help docs
        if #ctx.file > 0 and vim.api.nvim_get_option_value("filetype", { buf = ctx.buf }) ~= "help" then
            vim.opt_local.relativenumber = ctx.event == "WinEnter"
        end
    end,
})

-- Turn off cursorline for inactive windows
autocmd({ "WinEnter", "WinLeave" }, {
    group = augroup("CursorLineFocus", { clear = true }),
    callback = function(ctx)
        vim.opt_local.cursorline = ctx.event == "WinEnter"
    end,
})

if not vim.o.cursorline then
    vim.api.nvim_del_augroup_by_name("CursorLineFocus")
end

-- Create directory if it doesn't exist when saving file
-- https://github.com/jdhao/nvim-config/blob/78baf8d015695c2b795ac6f955550f5e96104845/lua/custom-autocmd.lua#L53-L67
autocmd("BufWritePre", {
    group = augroup("auto_create_dir", { clear = true }),
    callback = function(ctx)
        vim.fn.mkdir(vim.fn.fnamemodify(ctx.file, ":p:h"), "p")
    end,
})

-- Save when exiting insert mode
autocmd("InsertLeave", {
    group = augroup("AutoSave", { clear = true }),
    callback = function(ctx)
        local buf = ctx.buf
        local name = vim.api.nvim_buf_get_name(buf)

        local unnamed_buffer = name == ""
        local is_unmodified = not vim.bo[buf].modified
        local non_normal_buffer = vim.bo[buf].buftype ~= ""
        local is_oil_or_term = vim.startswith(name, "oil:") or vim.startswith(name, "term:")

        if unnamed_buffer or is_unmodified or non_normal_buffer or is_oil_or_term then
            return
        end

        vim.cmd(":update")
    end,
})
