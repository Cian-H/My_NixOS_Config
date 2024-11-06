export def create_left_prompt [] -> string  {
    canonicalize_linefeeds (
        ^starship prompt
            --cmd-duration $env.CMD_DURATION_MS
            $"--status=($env.LAST_EXIT_CODE)"
            --terminal-width (term size).columns
    )
}

export def create_right_prompt [] -> string  {
    canonicalize_linefeeds (
        ^starship prompt
            --right
            --cmd-duration $env.CMD_DURATION_MS
            $"--status=($env.LAST_EXIT_CODE)"
            --terminal-width (term size).columns
    )
}

export def create_continuation_prompt [] -> string  {
    canonicalize_linefeeds (
        ^starship prompt
            --continuation
            --cmd-duration $env.CMD_DURATION_MS
            $"--status=($env.LAST_EXIT_CODE)"
            --terminal-width (term size).columns
    )
}

def parse_ms_to_human_readable [ms: string] -> string  {
    let $time_in_ms = $ms | into int;
    if $time_in_ms < 1000 {
        $"($time_in_ms | into string)ms"
    } else if $time_in_ms < 1000 * 60 {
        $"(($time_in_ms / 1000) | into string --decimals 2)s"
    } else if $time_in_ms < 1000 * 60 * 60 {
        $"(($time_in_ms / (1000 * 60)) | into string --decimals 2)m"
    } else if $time_in_ms < 1000 * 60 * 60 * 24 {
        $"(($time_in_ms / (1000 * 60 * 60)) | into string --decimals 2)h"
    } else {
        $"(($time_in_ms // (1000 * 60 * 60 * 24)) | into string)d/(parse_ms_to_human_readable ($time_in_ms mod (1000 * 60 * 60 * 24)))"
    } | into string
}

export def create_transient_prompt_left [] -> string  {
    if $env.LAST_EXIT_CODE == 0 {
        $"(ansi green_bold)├(ansi reset)"
    } else {
        $"(ansi red_bold)┬(ansi reset)"
    }
}
export def create_transient_prompt_indicator [] -> string {
    $"(ansi blue_bold) ⏲(parse_ms_to_human_readable $env.CMD_DURATION_MS) (if $env.LAST_EXIT_CODE == 0 { ansi green_bold } else { ansi red_bold })➜(ansi reset) "
}

def canonicalize_linefeeds (x: string) -> string {
    if ("OS" in $env) and ($env.OS == "Windows_NT") {
        $x | str replace "\n" "\r\n"
    } else {
        $x
    }
}
