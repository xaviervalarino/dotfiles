local ls = require 'luasnip'
local s = ls.s -- snippet
local i = ls.i -- insert node
local t = ls.t -- text node

local d = ls.dynamic_choice
local c = ls.choice_node
local f = ls.function_node
local sn = ls.snippet_node

local fmt = require('luasnip.extras.fmt').fmt
local rep = require('luasnip.extras').rep

local snippets, autosnippets = {}, {}

-- stylua: ignore start
local export = s( 'edf', fmt([[
export default function {}({}) {{
  return (
    {}
  )
}}]], {
  i(1, vim.api.nvim_buf_get_name(0):match('^.+/(.+)%..+$')),
  i(2, 'props'),
  i(0),
}))

local input = s('input', fmt([[
<label htmlFor='{}'>{}</label>
<input type='{}' id='{}' />
]], {
  i(1),
  rep(1),
  i(3,'text'),
  rep(1),
}))

-- stylua: ignore end
table.insert(autosnippets, export)
table.insert(snippets, input)

return snippets, autosnippets
