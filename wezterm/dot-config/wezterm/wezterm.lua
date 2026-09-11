local wezterm = require("wezterm")

local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- Appearance --

local function scheme_for_appearance(appearance)
    if appearance:find("Light") then
        return "Github"
    else
        return "GitHub Dark"
    end
end

local function get_effective_scheme(pane)
    local user_vars = pane and pane:get_user_vars() or {}
    local theme = user_vars.THEME
    if theme == "dark" then
        return "GitHub Dark"
    elseif theme == "light" then
        return "Github"
    else
        return scheme_for_appearance(wezterm.gui.get_appearance())
    end
end

config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())

config.font = wezterm.font("JetBrains Mono", { weight = "Book" })
config.font_size = 14.5
config.line_height = 1.25
config.force_reverse_video_cursor = true

-- Window --

config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"
-- config.window_content_alignment = {
--     horizontal = "Center",
--     vertical = "Bottom",
-- }
config.window_padding = {
    left = 36,
    right = 36,
    top = 32,
    bottom = 32,
}

-- Tabs --

config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false

-- Keys --

config.keys = {
    { key = "[", mods = "SUPER|CTRL", action = wezterm.action.MoveTabRelative(-1) },
    { key = "]", mods = "SUPER|CTRL", action = wezterm.action.MoveTabRelative(1) },
}

-- Event handlers --

--- Return true if any pattern in `patterns` matches anywhere in `haystack`.
--- @param haystack string|string[] String, or list of strings, to search in.
--- @param patterns string[] Lua patterns to test against the haystack.
--- @return boolean
local function find_any(haystack, patterns)
    local strs = type(haystack) == "string" and { haystack } or haystack --[[@as string[] ]]
    for _, str in ipairs(strs) do
        for _, p in ipairs(patterns) do
            if str:find(p) then
                return true
            end
        end
    end
    return false
end

-- Full-screen TUI apps that should run without window padding.
local tui_apps = { "nvim", "opencode" }

--- Detect whether the foreground process in `pane` is a full-screen TUI app.
--- Falls back to inspecting argv so apps wrapped by a runtime (e.g. opencode,
--- which is launched via a `node` script) are matched correctly.
--- @param pane table A wezterm pane object.
--- @return boolean
local function is_tui(pane)
    local process = pane:get_foreground_process_name()
    if find_any(process, tui_apps) then
        return true
    end
    local info = pane:get_foreground_process_info()
    if info and info.argv then
        return find_any(info.argv, tui_apps)
    end
    return false
end

-- Drop padding for full-screen TUIs; update color scheme dynamically
wezterm.on("update-right-status", function(window, pane)
    local overrides = window:get_config_overrides() or {}
    overrides.color_scheme = get_effective_scheme(pane)
    if is_tui(pane) then
        overrides.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
    else
        overrides.window_padding = nil
    end
    window:set_config_overrides(overrides)
end)

wezterm.on("user-var-changed", function(window, pane, name, _)
    if name == "THEME" then
        local overrides = window:get_config_overrides() or {}
        overrides.color_scheme = get_effective_scheme(pane)
        window:set_config_overrides(overrides)
    end
end)

return config
