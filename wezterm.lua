local wezterm = require 'wezterm'

local act = wezterm.action
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

config.disable_default_key_bindings = true
config.keys = {
  { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
  { key = 'Tab', mods = 'SHIFT|CTRL', action = act.ActivateTabRelative(-1) },
  { key = 'Enter', mods = 'ALT', action = act.ToggleFullScreen },
  -- { key = '!', mods = 'CTRL', action = act.ActivateTab(0) },
  -- { key = '!', mods = 'SHIFT|CTRL', action = act.ActivateTab(0) },
  -- { key = '\"', mods = 'ALT|CTRL', action = act.SplitVertical{ domain =  'CurrentPaneDomain' } },
  -- { key = '\"', mods = 'SHIFT|ALT|CTRL', action = act.SplitVertical{ domain =  'CurrentPaneDomain' } },
  -- { key = '#', mods = 'CTRL', action = act.ActivateTab(2) },
  -- { key = '#', mods = 'SHIFT|CTRL', action = act.ActivateTab(2) },
  -- { key = '$', mods = 'CTRL', action = act.ActivateTab(3) },
  -- { key = '$', mods = 'SHIFT|CTRL', action = act.ActivateTab(3) },
  -- { key = '%', mods = 'CTRL', action = act.ActivateTab(4) },
  -- { key = '%', mods = 'SHIFT|CTRL', action = act.ActivateTab(4) },
  -- { key = '%', mods = 'ALT|CTRL', action = act.SplitHorizontal{ domain =  'CurrentPaneDomain' } },
  -- { key = '%', mods = 'SHIFT|ALT|CTRL', action = act.SplitHorizontal{ domain =  'CurrentPaneDomain' } },
  -- { key = '&', mods = 'CTRL', action = act.ActivateTab(6) },
  -- { key = '&', mods = 'SHIFT|CTRL', action = act.ActivateTab(6) },
  -- { key = '\'', mods = 'SHIFT|ALT|CTRL', action = act.SplitVertical{ domain =  'CurrentPaneDomain' } },
  -- { key = '(', mods = 'CTRL', action = act.ActivateTab(-1) },
  -- { key = '(', mods = 'SHIFT|CTRL', action = act.ActivateTab(-1) },
  -- { key = ')', mods = 'CTRL', action = act.ResetFontSize },
  -- { key = ')', mods = 'SHIFT|CTRL', action = act.ResetFontSize },
  -- { key = '*', mods = 'CTRL', action = act.ActivateTab(7) },
  -- { key = '*', mods = 'SHIFT|CTRL', action = act.ActivateTab(7) },
  { key = '+', mods = 'CTRL', action = act.IncreaseFontSize },
  { key = '+', mods = 'SHIFT|CTRL', action = act.IncreaseFontSize },
  -- { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
  -- { key = '-', mods = 'SHIFT|CTRL', action = act.DecreaseFontSize },
  { key = '-', mods = 'SUPER', action = act.DecreaseFontSize },
  { key = '0', mods = 'CTRL', action = act.ResetFontSize },
  { key = '0', mods = 'SHIFT|CTRL', action = act.ResetFontSize },
  { key = '0', mods = 'SUPER', action = act.ResetFontSize },
  { key = '1', mods = 'SHIFT|CTRL', action = act.ActivateTab(0) },
  { key = '1', mods = 'SUPER', action = act.ActivateTab(0) },
  { key = '2', mods = 'SHIFT|CTRL', action = act.ActivateTab(1) },
  { key = '2', mods = 'SUPER', action = act.ActivateTab(1) },
  { key = '3', mods = 'SHIFT|CTRL', action = act.ActivateTab(2) },
  { key = '3', mods = 'SUPER', action = act.ActivateTab(2) },
  { key = '4', mods = 'SHIFT|CTRL', action = act.ActivateTab(3) },
  { key = '4', mods = 'SUPER', action = act.ActivateTab(3) },
  { key = '5', mods = 'SHIFT|CTRL', action = act.ActivateTab(4) },
  { key = '5', mods = 'SHIFT|ALT|CTRL', action = act.SplitHorizontal{ domain =  'CurrentPaneDomain' } },
  { key = '5', mods = 'SUPER', action = act.ActivateTab(4) },
  { key = '6', mods = 'SHIFT|CTRL', action = act.ActivateTab(5) },
  { key = '6', mods = 'SUPER', action = act.ActivateTab(5) },
  { key = '7', mods = 'SHIFT|CTRL', action = act.ActivateTab(6) },
  { key = '7', mods = 'SUPER', action = act.ActivateTab(6) },
  { key = '8', mods = 'SHIFT|CTRL', action = act.ActivateTab(7) },
  { key = '8', mods = 'SUPER', action = act.ActivateTab(7) },
  { key = '9', mods = 'SHIFT|CTRL', action = act.ActivateTab(-1) },
  { key = '9', mods = 'SUPER', action = act.ActivateTab(-1) },
  { key = '=', mods = 'CTRL', action = act.IncreaseFontSize },
  { key = '=', mods = 'SHIFT|CTRL', action = act.IncreaseFontSize },
  { key = '=', mods = 'SUPER', action = act.IncreaseFontSize },
  { key = '@', mods = 'CTRL', action = act.ActivateTab(1) },
  { key = '@', mods = 'SHIFT|CTRL', action = act.ActivateTab(1) },
  { key = 'C', mods = 'CTRL', action = act.CopyTo 'Clipboard' },
  { key = 'C', mods = 'SHIFT|CTRL', action = act.CopyTo 'Clipboard' },
  { key = 'F', mods = 'CTRL', action = act.Search 'CurrentSelectionOrEmptyString' },
  { key = 'F', mods = 'SHIFT|CTRL', action = act.Search 'CurrentSelectionOrEmptyString' },
  { key = 'H', mods = 'CTRL', action = act.HideApplication },
  { key = 'H', mods = 'SHIFT|CTRL', action = act.HideApplication },
  { key = 'K', mods = 'CTRL', action = act.ClearScrollback 'ScrollbackOnly' },
  { key = 'K', mods = 'SHIFT|CTRL', action = act.ClearScrollback 'ScrollbackOnly' },
  { key = 'L', mods = 'CTRL', action = act.ShowDebugOverlay },
  { key = 'L', mods = 'SHIFT|CTRL', action = act.ShowDebugOverlay },
  { key = 'M', mods = 'CTRL', action = act.Hide },
  { key = 'M', mods = 'SHIFT|CTRL', action = act.Hide },
  { key = 'N', mods = 'CTRL', action = act.SpawnWindow },
  { key = 'N', mods = 'SHIFT|CTRL', action = act.SpawnWindow },
  -- { key = 'P', mods = 'CTRL', action = act.ActivateCommandPalette },
  { key = 'P', mods = 'SHIFT|CTRL', action = act.ActivateCommandPalette },
  { key = 'Q', mods = 'CTRL', action = act.QuitApplication },
  { key = 'Q', mods = 'SHIFT|CTRL', action = act.QuitApplication },
  { key = 'R', mods = 'CTRL', action = act.ReloadConfiguration },
  { key = 'R', mods = 'SHIFT|CTRL', action = act.ReloadConfiguration },
  { key = 'T', mods = 'CTRL', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'T', mods = 'SHIFT|CTRL', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'U', mods = 'CTRL', action = act.CharSelect{ copy_on_select = true, copy_to =  'ClipboardAndPrimarySelection' } },
  { key = 'U', mods = 'SHIFT|CTRL', action = act.CharSelect{ copy_on_select = true, copy_to =  'ClipboardAndPrimarySelection' } },
  { key = 'V', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
  { key = 'V', mods = 'SHIFT|CTRL', action = act.PasteFrom 'Clipboard' },
  { key = 'W', mods = 'CTRL', action = act.CloseCurrentTab{ confirm = true } },
  { key = 'W', mods = 'SHIFT|CTRL', action = act.CloseCurrentTab{ confirm = true } },
  -- { key = 'X', mods = 'CTRL', action = act.ActivateCopyMode },
  { key = 'X', mods = 'SHIFT|CTRL', action = act.ActivateCopyMode },
  { key = 'Z', mods = 'CTRL', action = act.TogglePaneZoomState },
  { key = 'Z', mods = 'SHIFT|CTRL', action = act.TogglePaneZoomState },
  -- { key = '[', mods = 'SHIFT|SUPER', action = act.ActivateTabRelative(-1) },
  -- { key = ']', mods = 'SHIFT|SUPER', action = act.ActivateTabRelative(1) },
  { key = '^', mods = 'CTRL', action = act.ActivateTab(5) },
  { key = '^', mods = 'SHIFT|CTRL', action = act.ActivateTab(5) },
  -- { key = '_', mods = 'CTRL', action = act.DecreaseFontSize },
  -- { key = '_', mods = 'SHIFT|CTRL', action = act.DecreaseFontSize },
  { key = 'c', mods = 'SHIFT|CTRL', action = act.CopyTo 'Clipboard' },
  { key = 'c', mods = 'SUPER', action = act.CopyTo 'Clipboard' },
  { key = 'f', mods = 'SHIFT|CTRL', action = act.Search 'CurrentSelectionOrEmptyString' },
  { key = 'f', mods = 'SUPER', action = act.Search 'CurrentSelectionOrEmptyString' },
  { key = 'h', mods = 'SHIFT|CTRL', action = act.HideApplication },
  { key = 'h', mods = 'SUPER', action = act.HideApplication },
  { key = 'k', mods = 'SHIFT|CTRL', action = act.ClearScrollback 'ScrollbackOnly' },
  { key = 'k', mods = 'SUPER', action = act.ClearScrollback 'ScrollbackOnly' },
  { key = 'l', mods = 'SHIFT|CTRL', action = act.ShowDebugOverlay },
  { key = 'm', mods = 'SHIFT|CTRL', action = act.Hide },
  { key = 'm', mods = 'SUPER', action = act.Hide },
  { key = 'n', mods = 'SHIFT|CTRL', action = act.SpawnWindow },
  { key = 'n', mods = 'SUPER', action = act.SpawnWindow },
  { key = 'p', mods = 'SHIFT|CTRL', action = act.ActivateCommandPalette },
  -- { key = 'q', mods = 'SHIFT|CTRL', action = act.QuitApplication },
  { key = 'q', mods = 'SUPER', action = act.QuitApplication },
  -- { key = 'r', mods = 'SHIFT|CTRL', action = act.ReloadConfiguration },
  { key = 'r', mods = 'SUPER', action = act.ReloadConfiguration },
  { key = 't', mods = 'SHIFT|CTRL', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 't', mods = 'SUPER', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'u', mods = 'SHIFT|CTRL', action = act.CharSelect{ copy_on_select = true, copy_to =  'ClipboardAndPrimarySelection' } },
  { key = 'v', mods = 'SHIFT|CTRL', action = act.PasteFrom 'Clipboard' },
  { key = 'v', mods = 'SUPER', action = act.PasteFrom 'Clipboard' },
  { key = 'w', mods = 'SHIFT|CTRL', action = act.CloseCurrentTab{ confirm = true } },
  { key = 'w', mods = 'SUPER', action = act.CloseCurrentTab{ confirm = true } },
  { key = 'x', mods = 'SHIFT|CTRL', action = act.ActivateCopyMode },
  { key = 'z', mods = 'SHIFT|CTRL', action = act.TogglePaneZoomState },
  -- { key = '{', mods = 'SUPER', action = act.ActivateTabRelative(-1) },
  -- { key = '{', mods = 'SHIFT|SUPER', action = act.ActivateTabRelative(-1) },
  -- { key = '}', mods = 'SUPER', action = act.ActivateTabRelative(1) },
  -- { key = '}', mods = 'SHIFT|SUPER', action = act.ActivateTabRelative(1) },
  { key = 'phys:Space', mods = 'SHIFT|CTRL', action = act.QuickSelect },
  -- { key = 'PageUp', mods = 'SHIFT', action = act.ScrollByPage(-1) },
  -- { key = 'PageUp', mods = 'CTRL', action = act.ActivateTabRelative(-1) },
  -- { key = 'PageUp', mods = 'SHIFT|CTRL', action = act.MoveTabRelative(-1) },
  -- { key = 'PageDown', mods = 'SHIFT', action = act.ScrollByPage(1) },
  -- { key = 'PageDown', mods = 'CTRL', action = act.ActivateTabRelative(1) },
  -- { key = 'PageDown', mods = 'SHIFT|CTRL', action = act.MoveTabRelative(1) },
  { key = 'LeftArrow', mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection 'Left' },
  { key = 'LeftArrow', mods = 'SHIFT|ALT|CTRL', action = act.AdjustPaneSize{ 'Left', 1 } },
  { key = 'RightArrow', mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection 'Right' },
  { key = 'RightArrow', mods = 'SHIFT|ALT|CTRL', action = act.AdjustPaneSize{ 'Right', 1 } },
  { key = 'UpArrow', mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection 'Up' },
  { key = 'UpArrow', mods = 'SHIFT|ALT|CTRL', action = act.AdjustPaneSize{ 'Up', 1 } },
  { key = 'DownArrow', mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection 'Down' },
  { key = 'DownArrow', mods = 'SHIFT|ALT|CTRL', action = act.AdjustPaneSize{ 'Down', 1 } },
  { key = 'UpArrow', mods = 'SHIFT', action = act.ScrollToPrompt(-1) },
  { key = 'DownArrow', mods = 'SHIFT', action = act.ScrollToPrompt(1) },
  { key = 'Copy', mods = 'NONE', action = act.CopyTo 'Clipboard' },
  { key = 'Paste', mods = 'NONE', action = act.PasteFrom 'Clipboard' },
}
config.mouse_bindings = {
  {
    event = {
      Down = { streak = 4, button = 'Left' },
    },
    action = act.SelectTextAtMouseCursor 'SemanticZone',
    mods = 'NONE',
  }
}

config.enable_scroll_bar = true
config.scrollback_lines = 20480

config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = false

config.show_new_tab_button_in_tab_bar = false

if wezterm.target_triple == 'aarch64-apple-darwin' or wezterm.target_triple == 'x86_64-apple-darwin' then
  config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
  -- config.tab_bar_at_bottom = true
end

return config
