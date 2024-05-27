export def main [] {
    {
        show_banner: false # disable the welcome banner at startup
        # For some reason wezterm adds a newline every keypress
        shell_integration: (not ("WEZTERM_EXECUTABLE" in $env)) # true # enable shell integration
        use_kitty_protocol: (("TERM" in $env) and ("kitty" in $env.TERM)) # use kitty protocol when running inside kitty
        history: {
            file_format: "sqlite"
        }
        render_right_prompt_on_last_line: true
        hooks: {
            env_change: {
                PWD: [
                    {|before, after| # This hook runs onefetch when the current directory is a git repository
                        if ".git\n" in ($after | ls -a | str join) {
                            ^onefetch
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
