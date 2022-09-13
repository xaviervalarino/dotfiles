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

-- App launcher -----------------------------------------------------
local app = modes:create('a', 'app launcher')
local work = hs.execute('uname -n'):find 'trax'

app:chord('m', work and goto_chrome_tab 'mail.google.com' or app_select 'Mail')
app:chord('c', work and goto_chrome_tab 'calendar.google.com' or app_select 'Calendar')
app:chord('shift', 'm', goto_chrome_tab 'meet.google.com')
app:chord('o', goto_chrome_tab 'app.shortcut.com')
app:chord('d', goto_chrome_tab 'withabound.slite.com')
app:chord('n', goto_chrome_tab 'nts.live')

-- Manage windows ---------------------------------------------------
local wm = modes:create('w', 'window manager')

wm:chord('d', detach_chrome_tab)

WM = require 'window-manager'
Indicator = require 'focused-window-indicator'

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
