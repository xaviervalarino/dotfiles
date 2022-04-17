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

hs.hotkey.bind({ 'ctrl', 'shift' }, 'c', function()
  hs.window.focusedWindow():centerOnScreen()
end)

hs.alert 'Hammerspoon loaded'
