local M = {}

--- Get the desired theme ("dark" or "light") based on THEME env var or macOS appearance
function M.get_mode()
    local theme = vim.env.THEME
    if theme == "dark" or theme == "light" then
        return theme
    end

    -- Query macOS system appearance
    local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
    local style = handle and handle:read("*a")
    if handle then
        handle:close()
    end
    if style and style:find("Dark") then
        return "dark"
    end
    return "light"
end

--- Apply theme based on mode ("dark" or "light")
function M.apply_theme(mode)
    mode = mode or M.get_mode()
    vim.o.background = mode

    local scheme = mode == "dark" and "github_dark" or "github_light"
    local has_github_theme = pcall(vim.cmd.colorscheme, scheme)
    if not has_github_theme then
        -- Fallback to default Neovim scheme if github-theme is not yet installed
        pcall(vim.cmd.colorscheme, "default")
    end
end

function M.setup()
    M.apply_theme()

    -- User command: :Theme [dark|light|auto]
    vim.api.nvim_create_user_command("Theme", function(opts)
        local arg = vim.trim(opts.args:lower())
        if arg == "dark" or arg == "light" then
            vim.env.THEME = arg
            M.apply_theme(arg)
            -- Propagate back to WezTerm if running in WezTerm
            io.stdout:write("\027]1337;SetUserVar=THEME=" .. vim.base64.encode(arg) .. "\007")
            print("Theme set to " .. arg)
        elseif arg == "auto" or arg == "system" or arg == "reset" then
            vim.env.THEME = nil
            local detected = M.get_mode()
            M.apply_theme(detected)
            io.stdout:write("\027]1337;SetUserVar=THEME=" .. vim.base64.encode("auto") .. "\007")
            print("Theme reset to auto (macOS appearance: " .. detected .. ")")
        else
            print("Current theme: " .. (vim.env.THEME or ("auto (" .. M.get_mode() .. ")")))
            print("Usage: :Theme [dark|light|auto]")
        end
    end, {
        nargs = "?",
        complete = function()
            return { "dark", "light", "auto" }
        end,
        desc = "Set or reset Neovim theme (dark, light, auto)",
    })

    -- When returning focus to Neovim, if mode is auto, sync with macOS appearance
    vim.api.nvim_create_autocmd("FocusGained", {
        group = vim.api.nvim_create_augroup("ThemeSync", { clear = true }),
        callback = function()
            if not vim.env.THEME then
                M.apply_theme()
            end
        end,
    })
end

return M
