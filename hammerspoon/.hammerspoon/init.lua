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
local detach_chrome_tab = switcher.detach_chrome_tab
local modes = Modes:new('ctrl', 'space')

-- Manage hammerspoon -----------------------------------------------
local mgmt = modes:create('h', 'hammerspoon')
mgmt:chord('c', hs.toggleConsole)
mgmt:chord('r', hs.reload)

-- App launcher -----------------------------------------------------
local app = modes:create('a', 'app launcher')
local work = hs.execute('uname -n'):find 'trax'

hs.hotkey.bind('shift-cmd', ',', app_select 'System Preferences')

app:chord('a', app_select 'Activity Monitor')
app:chord('c', app_select 'Google Chrome')
app:chord('x', app_select 'Firefox Developer Edition')
app:chord('f', app_select 'Figma')
app:chord('s', app_select 'Slack')
app:chord('i', app_select 'Miro')
app:chord('shift', 'f', app_select 'Finder')
app:chord('t', app_select 'iTerm')

app:chord('m', work and goto_chrome_tab 'mail.google.com' or app_select 'Mail')
app:chord('c', work and goto_chrome_tab 'calendar.google.com' or app_select 'Calendar')
app:chord('shift', 'm', goto_chrome_tab 'meet.google.com')
app:chord('o', goto_chrome_tab 'app.shortcut.com')
app:chord('d', goto_chrome_tab 'withabound.slite.com')
app:chord('n', goto_chrome_tab 'nts.live')

-- Manage windows ---------------------------------------------------
local wm = modes:create('w', 'window manager')

wm:chord('d', detach_chrome_tab)

wm:chord('c', function()
  hs.window.focusedWindow():centerOnScreen()
end)
wm:chord('m', function()
  hs.window.focusedWindow():maximize()
end)

wm:chord('n', function()
  local w = hs.window.focusedWindow()
  local screen = w:screen()
  w:move(w:frame():toUnitRect(screen:frame()), screen:next(), true, 0)
end)

wm:chord('w', function()
  hs.spaces.toggleMissionControl()
end)

-- https://github.com/jasonrudolph/keyboard/blob/main/hammerspoon/windows.lua
wm:chord('h', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

wm:chord('j', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.w = max.w
  f.y = max.y + (max.h / 2)
  f.h = max.h / 2
  win:setFrame(f)
end)

wm:chord('k', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.w = max.w
  f.y = max.y
  f.h = max.h / 2
  win:setFrame(f)
end)

wm:chord('l', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

wm:chord('c', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:fullFrame()

  f.x = max.x + (max.w / 5)
  f.w = max.w * 3 / 5
  f.y = max.y
  f.h = max.h
  win:setFrame(f)
end)

-- Handlers ---------------------------------------------------------
Thunderbolt = hs.usb.watcher.new(function(t)
  print('WATCHER ' .. t.eventType)
  if t.productName == 'USB 10/100/1000 LAN' then
    print('USB LAN ' .. t.eventType)
    hs.wifi.setPower(t.eventType == 'removed')

    -- pull all windows onto laptop monitor
    if t.eventType == 'removed' then
      (function()
        local ws = hs.window.allWindows()
        for _, w in ipairs(ws) do
          local screen = w:screen()
          w:move(w:frame():toUnitRect(screen:frame()), hs.screen.mainScreen(), true, 0)
        end
      end)()
    end
  end
end)
Thunderbolt:start()

---------------------------------------------------------------------
require('util').alert '🔨 loaded'
