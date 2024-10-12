local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'rose-pine-moon'
config.font = wezterm.font 'Iosevka Term'
config.font_size = 16
-- config.use_ime = false

config.window_decorations = 'RESIZE'
config.use_resize_increments = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
-- config.window_decorations = 'INTEGRATED_BUTTONS'

local default_window_padding = {
  left = '2cell',
  right = '2cell',
  top = '2cell',
  bottom = '2cell',
}

local nvim_window_padding = {
  left = '0cell',
  right = '0cell',
  top = '0cell',
  bottom = '0cell',
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

wezterm.on('user-var-changed', function(window, _, name, value)
  if name == 'NVIM_EVENT' then
    local enter_event = value == 'IN'
    set_padding(window, enter_event)
  end

  return false
end)

return config
