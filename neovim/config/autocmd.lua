-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  pattern = '*',
  group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(evt)
    vim.bo[evt.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local opts = { buffer = evt.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- vim.api.nvim_create_autocmd('BufWritePre', {
--   group = vim.api.nvim_create_augroup('LspFormat', {}),
--   callback = function()
--     require('plugins.lsp.formatting').format()
--   end,
-- })

-- vim.api.nvim_create_autocmd('BufWritePre', {
--   pattern = '*.go',
--   group = vim.api.nvim_create_augroup('GoFormat', {}),
--   callback = function()
--     require('go.format').goimport()
--   end,
-- })
