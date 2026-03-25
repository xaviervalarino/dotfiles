local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.font = wezterm.font("JetBrains Mono", { weight = "Book" })
config.font_size = 14.5
config.line_height = 1.15

config.window_decorations = "RESIZE"
config.window_content_alignment = {
    horizontal = "Center",
    vertical = "Bottom",
}

config.force_reverse_video_cursor = true

config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false

local function scheme_for_appearance(appearance)
    if appearance:find("Light") then
        return "NvimLight"
    else
        return "NvimDark"
    end
end

config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())

local default_padding = {
    left = 36,
    right = 36,
    top = 32,
    bottom = 32,
}

-- Remove padding when editing inside nvim
wezterm.on("update-right-status", function(window, pane)
    local process = pane:get_foreground_process_name()

    if process:find("nvim") then
        window:set_config_overrides({
            window_padding = {
                left = 0,
                right = 0,
                top = 0,
                bottom = 0,
            },
        })
    else
        window:set_config_overrides({
            window_padding = default_padding,
        })
    end
end)

config.window_close_confirmation = "NeverPrompt"

config.keys = {
    { key = "[", mods = "SUPER|CTRL", action = wezterm.action.MoveTabRelative(-1) },
    { key = "]", mods = "SUPER|CTRL", action = wezterm.action.MoveTabRelative(1) },
}

return config
