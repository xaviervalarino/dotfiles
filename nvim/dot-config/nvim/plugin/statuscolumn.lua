if vim.g.vscode then
    return
end

-- Left-aligned line numbers with sign column on the right
function _G.statuscolumn()
    local win = vim.g.statusline_winid or 0
    local wo = vim.wo[win]
    if not wo.number and not wo.relativenumber then
        return "%s"
    end

    if vim.v.virtnum ~= 0 then
        return "%=%s "
    end

    local is_rel = wo.relativenumber
    local relnum = vim.v.relnum
    local is_current = relnum == 0
    local num = (is_current or not is_rel) and vim.v.lnum or relnum
    local hl = is_current and "%#CursorLineNr#" or "%#LineNr#"

    return hl .. num .. "%* %=%s "
end

vim.o.statuscolumn = "%!v:lua.statuscolumn()"
