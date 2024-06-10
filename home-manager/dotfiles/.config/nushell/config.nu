# Imports of custom modules from init to help keep my config file clean
use ~/.config/nushell/default_config.nu
use ~/.config/nushell/init.nu *
# Combine config records to create the final config
$env.config = (
    (default_config) | merge (theme) | merge (my_config)
)
# Add shell extra utilities, if present
source ~/.config/nushell/atuin.nu
source ~/.config/nushell/zoxide.nu
# Finally, we run a system info fetch
sysfetch
