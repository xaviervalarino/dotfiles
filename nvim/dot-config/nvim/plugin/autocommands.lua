if vim.g.vscode then
    return
end

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Distinguish fields/properties from plain variables (default colorscheme only)
local function apply_default_hl()
    if vim.g.colors_name == nil then
        vim.api.nvim_set_hl(0, "@variable.member", { link = "Constant" })
        vim.api.nvim_set_hl(0, "@lsp.type.property", { link = "Constant" })
    end
end
apply_default_hl()
autocmd("ColorScheme", {
    group = augroup("CustomHighlights", { clear = true }),
    callback = apply_default_hl,
})

-- Turn off relative line numbers for inactive windows
autocmd({ "WinEnter", "WinLeave" }, {
    group = augroup("LocalNumbers", { clear = true }),
    callback = function(ctx)
        local is_floating_win = #ctx.file > 0
        local is_help_file = vim.api.nvim_get_option_value("filetype", { buf = ctx.buf }) ~= "help"
        local is_rename = vim.endswith(ctx.file, "lsp:rename")

        if is_floating_win or is_help_file or is_rename then
            return
        end

        vim.opt_local.relativenumber = ctx.event == "WinEnter"
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

-- Git status to quickfix from cwd
vim.api.nvim_create_user_command("Gstatus", function()
    local toplevel = vim.trim(vim.fn.system("git rev-parse --show-toplevel"))
    local lines = vim.fn.systemlist("git status --porcelain -- .")
    local qflist = {}
    for _, line in ipairs(lines) do
        local filename = toplevel .. "/" .. vim.trim(line:sub(4))
        table.insert(qflist, { filename = filename, text = line:sub(1, 2) })
    end
    vim.fn.setqflist(qflist, "r")
    vim.cmd.copen()
end, { desc = "Git status to quickfix" })

-- yarn tsc errors to quickfix from cwd
vim.api.nvim_create_user_command("TsCheck", function()
    local lines = vim.fn.systemlist("yarn tsc --noEmit --pretty false 2>&1")
    local qflist = {}
    for _, line in ipairs(lines) do
        local file, lnum, col, severity, msg = line:match("^(.+)%((%d+),(%d+)%): (%a+) TS%d+: (.+)$")
        if file then
            table.insert(qflist, {
                filename = file,
                lnum = tonumber(lnum),
                col = tonumber(col),
                text = msg,
                type = severity == "error" and "E" or "W",
            })
        end
    end
    vim.fn.setqflist(qflist, "r")
    vim.cmd.copen()
end, { desc = "yarn tsc to quickfix" })

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
