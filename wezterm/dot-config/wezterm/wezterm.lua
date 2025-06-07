local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.font = wezterm.font("JetBrains Mono")
config.font_size = 15

config.window_decorations = "RESIZE"
config.window_content_alignment = {
    horizontal = "Center",
    vertical = "Bottom",
}

config.force_reverse_video_cursor = true

local kanso_ink_colors = {
    foreground = "#C5C9C7",
    background = "#14171d",

    cursor_bg = "#C5C9C7",
    cursor_fg = "#14171d",
    cursor_border = "#C5C9C7",

    selection_fg = "#C5C9C7",
    selection_bg = "#393B44",

    scrollbar_thumb = "#393B44",
    split = "#393B44",

    ansi = {
        "#14171d",
        "#C4746E",
        "#8A9A7B",
        "#C4B28A",
        "#8BA4B0",
        "#A292A3",
        "#8EA4A2",
        "#A4A7A4",
    },
    brights = {
        "#A4A7A4",
        "#E46876",
        "#87A987",
        "#E6C384",
        "#7FB4CA",
        "#938AA9",
        "#7AA89F",
        "#C5C9C7",
    },
    tab_bar = {
        background = "#14171d",
        active_tab = {
            bg_color = "#14171d",
            fg_color = "#7AA89F",
            intensity = "Bold",
        },

        inactive_tab = {
            bg_color = "#14171d",
            fg_color = "#A4A7A4",
            intensity = "Half",
        },
    },
}

config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false

local kanso_ink = {
    background = "#14171d",
    foreground = "#C5C9C7",
    muted = "#6E7370",
    highlight = "#393B44",
    faded = "#1A1C22",
}

-- TODO: set this up so that it switches with term theme
config.colors = kanso_ink_colors

local default_window_padding = {
    left = "2cell",
    right = "2cell",
    top = "2cell",
    bottom = "2cell",
}

local nvim_window_padding = {
    left = "0cell",
    right = "0cell",
    top = "0cell",
    bottom = "0cell",
}

config.window_padding = default_window_padding

local function set_padding(window, enter_event)
    local overrides = window:get_config_overrides() or {}

    if enter_event then
        overrides.window_padding = nvim_window_padding
    else
        overrides.window_padding = nil
    end

    window:set_config_overrides(overrides)
end

wezterm.on("user-var-changed", function(window, _, name, value)
    if name == "NVIM_EVENT" then
        local enter_event = value == "IN"
        set_padding(window, enter_event)
    end

    return false
end)

return config
