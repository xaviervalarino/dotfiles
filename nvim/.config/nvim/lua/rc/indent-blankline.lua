require 'indent_blankline'.setup{
  char_hightlight = 'LineNr',
  use_treesitter = true,
  -- show_trailing_blankline_indent = false,
  -- show_end_of_line = true,
  buftype_exclude = { 'terminal', 'help', 'nofile' },
  show_current_context = true,
  show_current_context_start = true,
  show_first_indent_level = false,
  context_patterns = {
    'class',
    'function',
    'method',
    'element',
    '^if',
    '^while',
    '^for',
    '^object',
    '^table',
    'block',
    'arguments'
  }
}
