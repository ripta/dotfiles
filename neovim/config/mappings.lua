local function nnoremap(from, to)
  local opts = { noremap = true, silent = true }
  vim.keymap.set('n', from, to, opts)
end

local function nxnoremap(from, to)
  local opts = { noremap = true, silent = true }
  vim.keymap.set({ 'n', 'x' }, from, to, opts)
end

nnoremap('<leader><space>', ':nohl<cr>')
nnoremap(';', ':')

nnoremap('<leader>l', ':ls<cr>')
nnoremap('<leader>j', 'gqip')
nnoremap('<leader>s', '<C-w>v<C-w>l')
nnoremap('<leader>a', ':wa<cr>')
nnoremap('<leader>q', ':qa<cr>')
nnoremap('<leader>w', ':w<cr>')
nnoremap('<leader>m', ':!make<cr>')
nnoremap('<leader>t', ':wa <bar> :!clear && rake test <cr>')
nnoremap('<leader>f', 'zR')
nnoremap('<leader>n', ':set number!<cr>')
nnoremap('<leader>0', ':set relativenumber!<cr>')
nnoremap('<leader>c', ':w !pbcopy<cr>')

-- Reload configs without restarting
--- nnoremap('<leader>r', ':so %<cr>')

nnoremap('<C-h>', '<C-w>h')
nnoremap('<C-j>', '<C-w>j')
nnoremap('<C-k>', '<C-w>k')
nnoremap('<C-l>', '<C-w>l')

nxnoremap('H', '^')
nxnoremap('L', 'g_')

nnoremap('<leader>n', ':set number!<cr>')
nnoremap('<leader>0', ':set relativenumber!<cr>')

-- nnoremap('<leader>de', vim.diagnostic.open_float)
-- nnoremap('<leader>dp', vim.diagnostic.goto_prev)
-- nnoremap('<leader>dn', vim.diagnostic.goto_next)
-- nnoremap('<leader>dq', vim.diagonstic.setloclist)

-- Convenient find-and-replace of the word under the cursor
nnoremap('<C-s>', function()
  local line = ':%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>'
  local keys = vim.api.nvim_replace_termcodes(line, true, false, true)
  vim.api.nvim_feedkeys(keys, 'n', false)
end)
