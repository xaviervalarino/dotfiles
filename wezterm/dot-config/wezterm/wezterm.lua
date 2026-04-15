local wezterm = require("wezterm")

local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- Appearance --

-- get_appearance() returns "Light", "Dark", or *HighContrast variants.
if wezterm.gui.get_appearance():find("Light") then
    config.color_scheme = "NvimLight"
else
    config.color_scheme = "NvimDark"
end

config.font = wezterm.font("JetBrains Mono", { weight = "Book" })
config.font_size = 14.5
config.line_height = 1.25
config.force_reverse_video_cursor = true

-- Window --

config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"
config.window_content_alignment = {
    horizontal = "Center",
    vertical = "Bottom",
}
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

-- Drop padding for full-screen TUIs; otherwise fall back to config default.
wezterm.on("update-right-status", function(window, pane)
    if is_tui(pane) then
        window:set_config_overrides({
            window_padding = { left = 0, right = 0, top = 0, bottom = 0 },
        })
    else
        window:set_config_overrides({})
    end
end)

return config
