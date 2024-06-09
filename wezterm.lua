local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'Catppuccin Latte'

config.font = wezterm.font('MesloLGS NF')
config.font_size = 13.0

config.initial_cols = 200
config.initial_rows = 40

config.window_padding = {
  bottom = 4,
  left = 2,
  right = 2,
}

return config
