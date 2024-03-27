# Nushell Config File
#
# version = "0.89.0"


# Imports of custom modules from init to help keep my config file clean
use ~/.config/nushell/default_config.nu
use ~/.config/nushell/init.nu *

# $env.config = (default_config) # initialize the config record
# $env.config = ($env.config | merge (theme)) # merge in the theme record

# External completer example
# let carapace_completer = {|spans|
#     carapace $spans.0 nushell $spans | from json
# }


# Combine config records to create the final config
$env.config = (
    (default_config) | merge (theme) | merge (my_config)
)

# If atuin is installed, add it
source ~/.local/share/atuin/init.nu
# And lets do the same for zoxide
source ~/.config/nushell/zoxide.nu

# Finally, we run a system info fetch
sysfetch
