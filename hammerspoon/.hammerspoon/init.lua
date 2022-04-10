-- Load Hammerspoon annotations for Sumneko LSP
-- TODO: this doesn't need to be run on every startup
-- hs.loadSpoon 'EmmyLua'

-- allow Hammerspoon to be used through CLI
-- `hs` to start REPL
-- `hs -c "{lua cmd}"` to run commands
hs.ipc.cliInstall()

hs.hotkey.bind({ 'ctrl', 'shift' }, 'r', function()
  hs.reload()
end)
