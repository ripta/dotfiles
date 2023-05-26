-- Append dotfiles location to avoid having to copy configs out of dotfiles.
vim.opt.rtp:append('~/.dotfiles/neovim/config')

local config_files = {
  'global.lua',
  'autocmd.lua',
  'mappings.lua',
  'options.vim',
  'plugins.lua',
}

for _, name in ipairs(config_files) do
  local path = string.format("~/.dotfiles/neovim/config/%s", name)
  local sourcer = "source " .. path
  vim.cmd(sourcer)
end
