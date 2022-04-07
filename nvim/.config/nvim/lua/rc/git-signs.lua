local buf_keymaps = require('rc.util').buf_create_keymaps('n', 'nv', 'ox')

require('gitsigns').setup {
  signs = {},
  numhl = true,
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local nmap, nvmap, oxmap = buf_keymaps(bufnr)

    -- stylua: ignore start

    -- Navigation
    nmap(']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, { expr = true }, { desc = 'Go to next hunk'})

    nmap('[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true, desc = 'Go to previous hunk'})

    -- Actions
    nvmap('<leader>hs',  ':Gitsigns stage_hunk<CR>',                    { desc = 'Stage hunk' })
    nvmap('<leader>hr',  ':Gitsigns reset_hunk<CR>',                    { desc = 'Reset hunk' })
    nmap('<leader>hS',   gs.stage_buffer,                               { desc = 'Stage buffer' })
    nmap('<leader>hu',   gs.undo_stage_hunk,                            { desc = 'Undo stage hunk' })
    nmap('<leader>hR',   gs.reset_buffer,                               { desc = 'Reset all hunks in bufer' })
    nmap('<leader>hp',   gs.preview_hunk,                               { desc = 'Preview hunk' })
    nmap('<leader>hb',   function() gs.blame_line { full = true } end,  { desc = 'Blame line floating window' })
    nmap('<leader>tb',   gs.toggle_current_line_blame,                  { desc = 'Toggle line blame' })
    nmap('<leader>hd',   gs.diffthis,                                   { desc = 'Diff against ' })
    nmap('<leader>hD',   function() gs.diffthis '~' end,                { desc = 'Diff this' })
    nmap('<leader>td',   gs.toggle_deleted,                             { desc = 'Git sign - toggle deleted' })

    -- Text object
    oxmap('ih', ':<C-U>Gitsigns select_hunk<CR>')

    -- stylua ignore end
  end,
}
