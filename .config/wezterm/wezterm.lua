local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.enable_wayland = false
config.default_prog = { "nu" }
config.color_scheme = "Tokyo Night"
config.enable_kitty_keyboard = true
config.font_size = 16

return config
