export def 'exists' [ app ]: string -> bool {
    not (which $app | is-empty)
}

export def 'sysfetch' []: nothing -> nothing {
    if (exists fastfetch) {
        if (("kitty" in $env.TERM) or ("ghostty" in $env.TERM)) and ($"($env.HOME)/.config/fastfetch/kitty.jsonc" | path exists) {
            fastfetch --load-config $"($env.HOME)/.config/fastfetch/kitty.jsonc"
        } else {
            fastfetch
        }
    } else if (exists neofetch) {
        print "Why are you still using neofetch? It's deprecated!"
        neofetch
    } else if (exists screenfetch) {
        screenfetch
    } else if (exists archey) {
        archey
    } else if (exists lsb_release) {
        lsb_release -a
    } else if (exists uname) {
        uname
    }
}

export def 'register-plugins' []: nothing -> nothing {
    for plugin_dir in $env.NU_PLUGIN_DIRS {
        for plugin_path in (ls $"($env.NU_PLUGIN_DIRS.0)/nu_plugin_*").name {
            nu -c $"register ($plugin_path)"
        }
    }
}

export def 'build-plugins' []: nothing -> nothing {
    let curdir = pwd
    let plugin_dir = $env.NU_PLUGIN_DIRS.0
    cd $plugin_dir
    cargo build --release
    cd $curdir
    register-plugins
}

export def 'install-default-plugins' []: nothing -> nothing {
    [ nu_plugin_inc
      nu_plugin_polars
      # nu_plugin_gstat
      nu_plugin_formats
      nu_plugin_query
    ] | each { cargo install $in --locked } | ignore
}
