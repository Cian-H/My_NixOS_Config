# tempus-night
use ./nu_scripts/themes/nu-themes/tempus-night.nu
export def main [] { { color_config: (tempus-night) } }
# $env.config = ($env.config | merge {color_config: (tempus-night)})