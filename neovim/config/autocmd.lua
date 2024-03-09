-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  pattern = '*',
  group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
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
