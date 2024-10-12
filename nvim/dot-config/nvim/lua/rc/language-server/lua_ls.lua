-- make sure neodev is set up before lua language server
local noedev_ok, neodev = pcall(require, 'neodev')
if noedev_ok then
  neodev.setup {}
end

local M = {
  on_init = function(client)
    client.server_capabilities.documentFormattingProvider = false
  end,
  -- stop the "Do you need to configure your workspace as `luv`" prompt
  workspace = {
    checkThirdParty = false,
  },
}

local buffer_path = vim.fn.expand '%:p'

-- Hammerspoon config files
-- make sure HS is running and IPC command is available
if buffer_path:match '.hammerspoon' and os.execute 'which hs' == 0 then
  -- TODO: use coroutine to async loading this LSP while waiting for HS runtime info
  local hs_dev = {
    settings = {
      Lua = {
        runtime = {
          version = vim.fn.system('hs -A -c _VERSION'):gsub('[\n\r]', ''),
          path = vim.split(vim.fn.system('hs -c package.path'):gsub('[\n\r]', ''), ';'),
        },
        diagnostics = { globals = { 'hs' } },
        workspace = {
          library = {
            string.format('%s/.hammerspoon/Spoons/EmmyLua.spoon/annotations', os.getenv 'HOME'),
          },
        },
      },
    },
  }
  M = vim.tbl_deep_extend('keep', M, hs_dev)
end

return M
