local luasnip_ok, luasnip = pcall(require, 'luasnip')
if not luasnip_ok then
  return
end

local cmp_ok, cmp = pcall(require, 'cmp')
if not cmp_ok then
  return
end

local ismap, nmap = require('rc.util').create_keymaps('is', 'n')

require('luasnip.loaders.from_vscode').lazy_load()
require('luasnip.loaders.from_lua').lazy_load()

luasnip.config.set_config {
  history = true,
  updateevents = 'TextChanged,TextChangedI',
  -- delete_check_events = 'TextChanged, InsertEnter',
  enable_autosnippets = true,
  ext_opts = {
    [require('luasnip.util.types').choiceNode] = {
      -- passive = { virt_text = { { '●', 'Comment' } } },
      active = { virt_text = { { '●', 'DiagnosticHint' } } },
    },
  },
}

ismap('<C-k>', function()
  if luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  end
end)
ismap('<C-j>', function()
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  end
end)
ismap('<C-l>', function()
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  end
end)
