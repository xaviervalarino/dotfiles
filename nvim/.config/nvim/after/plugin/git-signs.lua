local bufmap = require('rc.util').bufkeymap

require('gitsigns').setup {
  signs = {
    add = { text = '▎' },
    change = { text = '▎' },
  },
  numhl = false,
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local map = bufmap(bufnr)

    -- stylua: ignore start

    -- Navigation
    map.n(']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, { expr = true }, { desc = 'Go to next hunk'})

    map.n('[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true, desc = 'Go to previous hunk'})

    -- Actions
    map.nv('<leader>hs',  ':Gitsigns stage_hunk<CR>',                    { desc = 'Stage hunk' })
    map.nv('<leader>hr',  ':Gitsigns reset_hunk<CR>',                    { desc = 'Reset hunk' })
    map.n('<leader>hS',   gs.stage_buffer,                               { desc = 'Stage buffer' })
    map.n('<leader>hu',   gs.undo_stage_hunk,                            { desc = 'Undo stage hunk' })
    map.n('<leader>hR',   gs.reset_buffer,                               { desc = 'Reset all hunks in buffer' })
    map.n('<leader>hp',   gs.preview_hunk,                               { desc = 'Preview hunk' })
    map.n('<leader>hb',   function() gs.blame_line { full = true } end,  { desc = 'Blame line floating window' })
    map.n('<leader>tb',   gs.toggle_current_line_blame,                  { desc = 'Toggle line blame' })
    map.n('<leader>hd',   gs.diffthis,                                   { desc = 'Diff against ' })
    map.n('<leader>hD',   function() gs.diffthis '~' end,                { desc = 'Diff this' })
    map.n('<leader>td',   gs.toggle_deleted,                             { desc = 'Git sign - toggle deleted' })

    -- Text object
    map.ox('ih', ':<C-U>Gitsigns select_hunk<CR>')

    -- stylua ignore end
  end,
}
