local M = {
  on_init = function(client)
    client.resolved_capabilities.document_formatting = false
  end,
}

local buffer_path = vim.fn.expand '%:p'

-- Neovim config files
if buffer_path:match '.config/nvim' then
  local lua_dev = require('lua-dev').setup()
  M = vim.tbl_deep_extend('keep', M, lua_dev)
end

-- Hammerspoon config files
-- make sure HS is running and IPC command is available
if buffer_path:match '.hammerspoon' and os.execute 'hs -a' == 0 then
  local hs_dev = {
    settings = {
      Lua = {
        runtime = {
          version = vim.fn.system('hs -c _VERSION'):gsub('[\n\r]', ''),
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
