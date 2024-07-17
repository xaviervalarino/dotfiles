-- vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = '[r]e[n]ame' })
-- vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = '[c]ode [a]ction' })
-- vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'hover documentation' })
-- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = '[g]oto [d]eclaration' })

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end
    local builtin = require 'telescope.builtin'

    map('<leader>rn', vim.lsp.buf.rename, '[r]e[n]ame')
    map('<leader>ca', vim.lsp.buf.code_action, '[c]ode [a]ction')
    map('K', vim.lsp.buf.hover, 'hover documentation')
    map('gD', vim.lsp.buf.declaration, '[g]oto [d]eclaration')

    map('gd', require('telescope.builtin').lsp_definitions, '[g]oto [d]efinition')
    map('gr', builtin.lsp_references, '[g]oto [r]eferences')
    map('gI', builtin.lsp_implementations, '[g]oto [i]mplementation')
    map('<leader>D', builtin.lsp_type_definitions, 'type [d]efinition')
    -- Fuzzy find all the symbols in the current document.
    map('<leader>ds', builtin.lsp_document_symbols, '[d]ocument [s]ymbols')
    -- Fuzzy find all the symbols in the current workspace.
    map('<leader>ws', builtin.lsp_dynamic_workspace_symbols, '[w]orkspace [s]ymbols')

    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
      local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    -- The following autocommand is used to enable inlay hints in your
    -- code, if the language server you are using supports them

    -- This may be unwanted, since they displace some of your code
    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, '[t]oggle inlay [h]ints')
    end
  end,
})
