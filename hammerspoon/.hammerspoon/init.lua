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

-- Window manager
WM = {}

function WM.left()
  hs.window.focusedWindow():moveToUnit { 0, 0, 0.5, 1 }
end

function WM.down()
  hs.window.focusedWindow():moveToUnit { 0, 0.5, 1, 0.5 }
end

function WM.up()
  hs.window.focusedWindow():moveToUnit { 0, 0, 1, 0.5 }
end

function WM.right()
  hs.window.focusedWindow():moveToUnit { 0.5, 0, 0.5, 1 }
end

function WM.center()
  hs.window.focusedWindow():moveToUnit { 0.1, 0.1, 0.8, 0.8 }
end

function WM.fill()
  hs.window.focusedWindow():maximize()
end

function WM.toggle_show_desktop()
  hs.spaces.toggleShowDesktop()
end

function WM.move_to_next_display()
  local w = hs.window.focusedWindow()
  local screen = w:screen()
  w:move(w:frame():toUnitRect(screen:frame()), screen:next(), true, 0)
end

local function mod_curr_win(callback)
  local win = hs.window.focusedWindow()
  local frame = win:frame()
  local max = win:screen():frame()
  win:setFrame(callback(frame, max), 0)
end

local function increment_mod_cur_win(callback)
  local timer
  return function(start)
    if start then
      timer = hs.timer.doEvery(0.05, function()
        mod_curr_win(callback)
      end)
    else
      timer:stop()
    end
  end
end

WM.grow_right = increment_mod_cur_win(function(frame, max)
  if frame.x + frame.w == max.w then
    frame.w = frame.w - 20
    frame.x = frame.x + 20
  else
    frame.w = frame.w + 20
  end
  return frame
end)

WM.grow_down = increment_mod_cur_win(function(frame, max)
  if frame.h >= max.h then
    frame.h = frame.h - 20
    frame.y = frame.y + 20
  else
    frame.h = frame.h + 20
  end
  return frame
end)

WM.grow_up = increment_mod_cur_win(function(frame, max)
  if frame.y <= max.y then
    frame.h = frame.h - 20
  else
    frame.y = frame.y - 20
  end
  return frame
end)

WM.grow_left = increment_mod_cur_win(function(frame, max)
  if frame.x == max.x then
    frame.w = frame.w - 20
  else
    frame.x = frame.x - 20
    frame.w = frame.w + 20
  end
  return frame
end)

Indicator = {}
Indicator.canvas = (function()
  local max = hs.screen.mainScreen():fullFrame()
  local canvas = hs.canvas.new { x = max.x, y = max.y, h = max.h, w = max.w }
  canvas:appendElements {
    type = 'rectangle',
    action = 'fill',
    fillColor = { red = 0, green = 0, blue = 0, alpha = 0.6 },
    frame = { x = max.x, y = max.y, h = max.h, w = max.w },
  }
  canvas:level 'normal'
  return canvas
end)()

Indicator.on = function()
  hs.window.focusedWindow():raise()
  Indicator.canvas:show(0.4)
end

Indicator.off = function()
  Indicator.canvas:hide(0.4)
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
