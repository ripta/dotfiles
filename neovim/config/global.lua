local u = require('utils')

-- Disable built-in providers we won't be using
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- Require that python3 is installed
if u.is_executable('python3') then
  vim.g.python3_host_prog = vim.fn.exepath('python3')
else
  vim.api.nvim_err_writeln('python3 executable is missing from PATH')
  return
end

-- Disable tutorials
vim.g.loaded_tutor_mode_plugin = 1

-- Set my preferred leader
vim.g.mapleader = ','

-- Disable mouse
vim.opt.mouse = ''

-- Keep a five-line offset in view when scrolling
vim.opt.scrolloff = 5

-- Enable line highlight
vim.opt.cursorline = true

-- Mark column 120
vim.opt.colorcolumn = "120"

-- Enable clipboard
vim.opt.clipboard:append { 'unnamedplus' }

vim.opt.joinspaces = false

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Enable 24-bit color
vim.opt.termguicolors = true
