export def 'exists' [ app: string ] {
    not (which $app | is-empty)
}

export def 'sysfetch' [] {
    if (exists fastfetch) {
        if ("kitty" in $env.MAIN_TERM) and ($"($env.HOME)/.config/fastfetch/kitty.conf" | path exists) {
            fastfetch --load-config $"($env.HOME)/.config/fastfetch/kitty.conf"
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
        uname -a
    }
}

export def 'register-plugins' [] {
    for plugin_dir in $env.NU_PLUGIN_DIRS {
        for plugin_path in (ls $"($env.NU_PLUGIN_DIRS.0)/nu_plugin_*").name {
            nu -c $"register ($plugin_path)"
        }
    }
}

export def 'build-plugins' [] {
    let curdir = pwd
    let plugin_dir = $env.NU_PLUGIN_DIRS.0
    cd $plugin_dir
    cargo build --release
    cd $curdir
    register-plugins
}

