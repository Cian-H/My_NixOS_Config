local wezterm = require "wezterm"
local config = wezterm.config_builder()

config.default_prog = { "nu" }
config.color_scheme = "Tokyo Night"
config.enable_kitty_keyboard = true

return config
