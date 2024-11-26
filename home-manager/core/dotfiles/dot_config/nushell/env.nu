# Nushell Environment Config File
#
# version = "0.89.0"

use ~/.config/nushell/prompt.nu *

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# Variables that represent the state of the prompt
$env.PROMPT_INDICATOR = {|| "" }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| create_continuation_prompt }

$env.TRANSIENT_PROMPT_COMMAND = {|| create_transient_prompt_left }
$env.TRANSIENT_PROMPT_INDICATOR = {|| create_transient_prompt_indicator }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| "" }
# $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| "" }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts when calling source or use
# The default for this is $nu.default-config-dir/scripts
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join "scripts"), # add <nushell-config-dir>/scripts
]

# Directories to search for plugin binaries when calling register
# The default for this is $nu.default-config-dir/plugins
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join "plugins"), # add <nushell-config-dir>/plugins
]

# Personal env vars
$env.EDITOR = "nvim"
$env.GIT_EDITOR = "nvim"
$env.PIPENV_VERBOSITY = -1
$env.MAKEFLAGS = $"-j((nproc | into int) + 1)"
$env.JULIA_NUM_THREADS = $"(nproc)"
$env.BAT_THEME = "tokyonight_night"
$env.YAOURT_COLORS = "nb=1:pkg=1:ver=1;32:lver=1;45:installed=1;42:grp=1;34:od=1;41;5:votes=1;44:dsc=0:other=1;35"
$env.XDG_CONFIG_HOME = $"($env.HOME)/.config"
if $nu.os-info.name != "windows" {
    $env.GPG_TTY = $"(/usr/bin/env tty)"
}
$env.PASSWORD_STORE_DIR = $"($env.HOME)/.cache/password-store"
$env.GLAMOUR_STYLE = $"($env.XDG_CONFIG_HOME)/glamour/tokyo_night.json"
$env.RYE_HOME = $"($env.XDG_CONFIG_HOME)/.rye"
# Config for less
$env.LESS_TERMCAP_mb = (ansi --escape "01;31m")     # begin blinking
$env.LESS_TERMCAP_md = (ansi --escape "01;31m")     # begin bold
$env.LESS_TERMCAP_me = (ansi --escape "0m")         # end mode
$env.LESS_TERMCAP_so = (ansi --escape "01;44;36m")  # begin standout-mode (bottom of screen)
$env.LESS_TERMCAP_se = (ansi --escape "0m")         # end standout-mode
$env.LESS_TERMCAP_us = (ansi --escape "00;36m")     # begin underline
$env.LESS_TERMCAP_ue = (ansi --escape "0m")         # end underline
# Set a custom copy of TERM so that shells under multiplexors behave correctly
if not ("MAIN_TERM" in $env) {
    $env.MAIN_TERM = $env.TERM
}

# Finally, add session path variables
$env.PATH = (
    $env.PATH
    | split row (char esep)
    | append (
        open $"($nu.default-config-dir)/path.env"
        | from csv --noheaders --trim all
        | get "column0"
        | path expand --no-symlink
    )
)
