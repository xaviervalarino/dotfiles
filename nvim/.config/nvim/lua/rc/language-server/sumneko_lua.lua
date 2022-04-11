local M = {}
local buffer_path = vim.fn.expand '%:p'

-- Neovim config files
if buffer_path:match '.config/nvim' then
  M = require('lua-dev').setup()
end

-- Hammerspoon config files
-- make sure HS is running and IPC command is available
if buffer_path:match '.hammerspoon' and os.execute 'hs -a' == 0 then
  M = {
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
end

return M
