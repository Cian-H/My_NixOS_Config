export def main [] {
    {
        show_banner: false # disable the welcome banner at startup
        # For some reason wezterm adds a newline every keypress
        shell_integration: {
            osc2: true
            osc7: true
            osc8: true
            # OSC9.9 causes swaync to notify end of every command under kitty
            osc9_9: (not (("TERM" in $env) and ("kitty" in $env.TERM)))
            osc133: true
            osc633: true
            reset_application_mode: true
        }
        # use kitty protocol when running inside kitty or wezterm
        use_kitty_protocol: (
            (
                ("TERM" in $env) and ("kitty" in $env.TERM)
            ) or (
                not ("WEZTERM_EXECUTABLE" in $env)
            )
        )
        history: {
            file_format: "sqlite"
        }
        render_right_prompt_on_last_line: true
        hooks: {
            env_change: {
                PWD: [
                    {|before, after| # This hook runs onefetch when the current directory is a git repository
                        if ".git\n" in ($after | ls -a | str join) {
                            print (^onefetch)
                        }
                    },
                    {||
                        if (exists direnv) {
                            direnv export json | from json | default {} | load-env
                        }
                    }
                ]
            }
        }
        cursor_shape: {
            emacs: line
            vi_normal: blink_block
            vi_insert: blink_line
        }
    }
}
