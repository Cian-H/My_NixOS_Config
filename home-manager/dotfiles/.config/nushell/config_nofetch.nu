# Imports of custom modules from init to help keep my config file clean
use ~/.config/nushell/default_config.nu
use ~/.config/nushell/init.nu *

# Combine config records to create the final config
$env.config = (
    (default_config) | merge (theme) | merge (my_config)
)

# If atuin is installed, add it
source ~/.local/share/atuin/init.nu
# And lets do the same for zoxide
source ~/.config/nushell/zoxide.nu
