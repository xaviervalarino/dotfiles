hs.console.clearConsole()

-- Load Hammerspoon annotations for Sumneko LSP
-- TODO: this doesn't need to be run on every startup
-- hs.loadSpoon 'EmmyLua'

-- allow Hammerspoon to be used through CLI
-- `hs` to start REPL
-- `hs -c "{lua cmd}"` to run commands
hs.ipc.cliInstall()

local Modes = require 'keymodes'
local switcher = require 'switcher'

local app_select = switcher.app_select
local goto_chrome_tab = switcher.goto_chrome_tab
local modes = Modes:new('ctrl', 'space')

-- Manage hammerspoon -----------------------------------------------
local mgmt = modes:create('h', 'hammerspoon')
mgmt:chord('c', hs.toggleConsole)
mgmt:chord('r', hs.reload)

-- App launcher -----------------------------------------------------
local app = modes:create('a', 'app launcher')

app:chord('a', app_select 'Activity Monitor')
app:chord('c', app_select 'Google Chrome')
app:chord('x', app_select 'Firefox Developer Edition')
app:chord('f', app_select 'Figma')
app:chord('s', app_select 'Slack')
app:chord('i', app_select 'Miro')
app:chord('shift', 'f', app_select 'Finder')
app:chord('t', app_select 'iTerm')

app:chord('m', goto_chrome_tab 'mail.google.com')
app:chord('c', goto_chrome_tab 'calendar.google.com')
app:chord('shift', 'm', goto_chrome_tab 'meet.google.com')
app:chord('o', goto_chrome_tab 'app.shortcut.com')
app:chord('n', goto_chrome_tab 'nts.live')

-- Manage windows ---------------------------------------------------
local wm = modes:create('w', 'window manager')

wm:chord('c', function()
  hs.window.focusedWindow():centerOnScreen()
end)
wm:chord('m', function()
  hs.window.focusedWindow():maximize()
end)

wm:chord('w', function()
  hs.spaces.toggleMissionControl()
end)

---------------------------------------------------------------------
require('util').alert '🔨 loaded'
