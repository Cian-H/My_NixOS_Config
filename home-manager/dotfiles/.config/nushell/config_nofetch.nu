# Imports of custom modules from init to help keep my config file clean
use ~/.config/nushell/default_config.nu
use ~/.config/nushell/init.nu *
# Combine config records to create the final config
$env.config = (
    (default_config) | merge (theme) | merge (my_config)
)
# Finally, initialise the completion plugins
source ~/.config/nushell/completions/atuin.nu
source ~/.config/nushell/completions/zoxide.nu
source ~/.config/nushell/completions/jj.nu
