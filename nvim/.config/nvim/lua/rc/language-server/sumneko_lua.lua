local sumneko_binary_path = vim.fn.exepath('lua-language-server')
local sumneko_root_path = vim.fn.fnamemodify(sumneko_binary_path, ':h:h:h')

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

local setup = {
  cmd = { sumneko_binary_path, '-E', sumneko_root_path .. '/main.lua'};
  settings = {
    Lua ={
      runtime = {
        version = 'LuaJIT',
        path = runtime_path
      },
      diagnostics = {
        globals = { 'vim', 'hs' },
      },
      workspace = {
        library = {
          vim.api.nvim_get_runtime_file('', true),
          -- '/Applications/Hammerspoon.app/Contents/Resources/extensions/hs',
        }
      },
      telemetry = {
        enable = false
      },
    }
  }
}
return setup
