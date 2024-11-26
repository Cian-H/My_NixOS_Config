local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.enable_wayland = true
config.max_fps = 120
config.default_prog = { "nu" }
config.color_scheme = "Tokyo Night"
config.enable_kitty_keyboard = true
config.font = wezterm.font("MonaspiceNeNerdFontMono")
config.font_size = 16
config.use_fancy_tab_bar = false

return config
