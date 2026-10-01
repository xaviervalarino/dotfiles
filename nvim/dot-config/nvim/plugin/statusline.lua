if vim.g.vscode then
    return
end

-- Statusline and winbar highlight groups
local function setup_highlights()
    local function fg_of(name)
        return vim.api.nvim_get_hl(0, { name = name }).fg
    end

    local sl = vim.api.nvim_get_hl(0, { name = "StatusLine" })
    local sl_fg = sl.fg or vim.api.nvim_get_hl(0, { name = "Normal" }).fg

    -- Git: colored text on transparent statusline bg
    local function dim(color)
        if not color then
            return sl_fg
        end
        local r = math.floor(bit.rshift(color, 16) * 0.7)
        local g = math.floor(bit.band(bit.rshift(color, 8), 0xFF) * 0.7)
        local b = math.floor(bit.band(color, 0xFF) * 0.7)
        return r * 65536 + g * 256 + b
    end
    vim.api.nvim_set_hl(0, "StGitAdd", { fg = dim(fg_of("Added")), bold = true })
    vim.api.nvim_set_hl(0, "StGitChange", { fg = dim(fg_of("Changed")), bold = true })
    vim.api.nvim_set_hl(0, "StGitDelete", { fg = dim(fg_of("Removed")), bold = true })

    -- Diagnostics: foreground colors on transparent statusline bg
    vim.api.nvim_set_hl(0, "StDiagError", { fg = fg_of("DiagnosticError"), bold = true })
    vim.api.nvim_set_hl(0, "StDiagWarn", { fg = fg_of("DiagnosticWarn"), bold = true })
    vim.api.nvim_set_hl(0, "StDiagHint", { fg = fg_of("DiagnosticHint"), bold = true })

    -- Git branch accent
    vim.api.nvim_set_hl(0, "StGitBranch", { fg = fg_of("Directory"), bold = true })

    -- Dimmed text on transparent statusline bg
    local dim_fg = fg_of("Comment") or sl_fg
    vim.api.nvim_set_hl(0, "StDim", { fg = dim_fg })
end

setup_highlights()
vim.api.nvim_create_autocmd("ColorScheme", { callback = setup_highlights })

local function git_status()
    local git = vim.b.minigit_summary
    if not git or not git.head_name or git.head_name == "" then
        return ""
    end

    local diff = vim.b.minidiff_summary
    local diff_parts = {}
    if diff then
        if (diff.add or 0) > 0 then
            table.insert(diff_parts, "%#StGitAdd#+" .. diff.add .. "%*")
        end
        if (diff.change or 0) > 0 then
            table.insert(diff_parts, "%#StGitChange#~" .. diff.change .. "%*")
        end
        if (diff.delete or 0) > 0 then
            table.insert(diff_parts, "%#StGitDelete#-" .. diff.delete .. "%*")
        end
    end
    local diff_str = #diff_parts > 0 and (" " .. table.concat(diff_parts, " ")) or ""

    return "%#StGitBranch# " .. git.head_name .. "%*" .. diff_str
end

local function diagnostics()
    local d = vim.diagnostic.count(0)
    local e = d[vim.diagnostic.severity.ERROR] or 0
    local w = d[vim.diagnostic.severity.WARN] or 0
    local i = (d[vim.diagnostic.severity.INFO] or 0) + (d[vim.diagnostic.severity.HINT] or 0)
    if e == 0 and w == 0 and i == 0 then
        return ""
    end
    local parts = {}
    if e > 0 then
        table.insert(parts, "%#StDiagError#E " .. e .. "%*")
    end
    if w > 0 then
        table.insert(parts, "%#StDiagWarn#W " .. w .. "%*")
    end
    if i > 0 then
        table.insert(parts, "%#StDiagHint#I " .. i .. "%*")
    end
    return table.concat(parts, " ")
end

local function buffer_counter()
    local bufs = vim.fn.getbufinfo({ buflisted = 1 })
    local total = #bufs
    local current_buf = vim.api.nvim_get_current_buf()
    local current_idx = nil
    for idx, b in ipairs(bufs) do
        if b.bufnr == current_buf then
            current_idx = idx
            break
        end
    end
    if not current_idx then
        return ""
    end
    return string.format(" %d/%d", current_idx, math.max(total, 1))
end

local function cwd_name()
    local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
    return "%#StDim# " .. vim.fn.pathshorten(cwd) .. "%*"
end

_G.Statusline = function()
    local left_parts = {}
    local git = git_status()
    if git ~= "" then
        table.insert(left_parts, git)
    end
    table.insert(left_parts, cwd_name())
    local left = " " .. table.concat(left_parts, "  ")

    local right_parts = {}
    local diag = diagnostics()
    if diag ~= "" then
        table.insert(right_parts, diag)
    end
    local buf_count = buffer_counter()
    if buf_count ~= "" then
        table.insert(right_parts, buf_count)
    end
    table.insert(right_parts, "%#StDim#%l:%c %P%*")
    local right = table.concat(right_parts, "  ") .. " "

    return left .. "%=" .. right
end

vim.o.statusline = "%!v:lua.Statusline()"

_G.Winbar = function()
    local buftype = vim.bo.buftype
    if buftype ~= "" then
        return ""
    end
    local name = vim.api.nvim_buf_get_name(0)
    if name == "" then
        return " %#WinbarFile#No Name%*"
    end

    local rel = vim.fn.fnamemodify(name, ":~:.")
    local dir = vim.fs.dirname(rel)
    local file = vim.fs.basename(rel)

    local icon_str = ""
    local has_icons, icons = pcall(require, "mini.icons")
    if has_icons then
        local icon, icon_hl = icons.get("file", file)
        if icon then
            if icon_hl then
                icon_str = "%#" .. icon_hl .. "#" .. icon .. "%* "
            else
                icon_str = icon .. " "
            end
        end
    end

    local mod = vim.bo.modified and " %#WinbarMod#[+]%*" or ""

    if not dir or dir == "." or dir == "" then
        return " " .. icon_str .. "%#WinbarFile#" .. file .. "%*" .. mod
    end

    -- Dynamic path truncation: only shorten directory path if window width is constrained
    local win = vim.g.statusline_winid
    local win_width = (win and win > 0 and vim.api.nvim_win_is_valid(win)) and vim.api.nvim_win_get_width(win)
        or vim.api.nvim_win_get_width(0)
    local full_path_len = #rel + 10
    local display_dir = dir
    if win_width < full_path_len + 15 then
        display_dir = vim.fn.pathshorten(dir)
    end

    -- %< marks the truncation point if space is too constrained for the path
    return " " .. icon_str .. "%#WinbarPath#%<" .. display_dir .. "/%*" .. "%#WinbarFile#" .. file .. "%*" .. mod
end

vim.o.winbar = "%!v:lua.Winbar()"

vim.api.nvim_create_autocmd("DiagnosticChanged", {
    callback = function()
        vim.cmd.redrawstatus()
    end,
})
