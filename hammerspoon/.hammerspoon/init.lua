hs.console.clearConsole()

-- Load Hammerspoon annotations for Sumneko LSP
-- TODO: this doesn't need to be run on every startup
-- hs.loadSpoon 'EmmyLua'

-- allow Hammerspoon to be used through CLI
-- `hs` to start REPL
-- `hs -c "{lua cmd}"` to run commands

-- TODO: would be nice to look up $HOMEBREW_PREFIX location
-- os.getenv'HOMEBREW_PREFIX' and hs.execute'echo $HOMEBREW_PREFIX' are note working
hs.ipc.cliInstall '/opt/homebrew/'

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

-- Window manager
WM = {}

-- Inspired by: https://github.com/jasonrudolph/keyboard/blob/main/hammerspoon/windows.lua
local function manipulate_curr_window(callback)
  local win = hs.window.focusedWindow()
  local frame = win:frame()
  local max = win:screen():frame()
  win:setFrame(callback(frame, max))
end

function WM.left()
  manipulate_curr_window(function(frame, max)
    frame.x = max.x
    frame.y = max.y
    frame.w = max.w / 2
    frame.h = max.h
    return frame
  end)
end

function WM.down()
  manipulate_curr_window(function(frame, max)
    frame.x = max.x
    frame.w = max.w
    frame.y = max.y + (max.h / 2)
    frame.h = max.h / 2
    return frame
  end)
end

function WM.up()
  manipulate_curr_window(function(frame, max)
    frame.x = max.x
    frame.w = max.w
    frame.y = max.y
    frame.h = max.h / 2
    return frame
  end)
end

function WM.right()
  manipulate_curr_window(function(frame, max)
    frame.x = max.x + (max.w / 2)
    frame.y = max.y
    frame.w = max.w / 2
    frame.h = max.h
    return frame
  end)
end

function WM.center()
  manipulate_curr_window(function(frame, max)
    frame.x = max.x + (max.w / 5)
    frame.w = max.w * 3 / 5
    frame.y = max.y
    frame.h = max.h
    return frame
  end)
end

function WM.fill()
  hs.window.focusedWindow():maximize()
end

function WM.toggle_mission_control()
  hs.spaces.toggleMissionControl()
end

function WM.toggle_show_desktop()
  hs.spaces.toggleShowDesktop()
end

function WM.move_to_next_display()
  local w = hs.window.focusedWindow()
  local screen = w:screen()
  w:move(w:frame():toUnitRect(screen:frame()), screen:next(), true, 0)
end

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
