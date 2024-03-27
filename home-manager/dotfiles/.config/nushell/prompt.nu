export def create_left_prompt [] {
    (
        ^starship prompt
            --cmd-duration $env.CMD_DURATION_MS
            $"--status=($env.LAST_EXIT_CODE)"
            --terminal-width (term size).columns
    )
}

export def create_right_prompt [] {
    (
        ^starship prompt
            --right
            --cmd-duration $env.CMD_DURATION_MS
            $"--status=($env.LAST_EXIT_CODE)"
            --terminal-width (term size).columns
    )
}

export def create_continuation_prompt [] {
    (
        ^starship prompt
            --continuation
            --cmd-duration $env.CMD_DURATION_MS
            $"--status=($env.LAST_EXIT_CODE)"
            --terminal-width (term size).columns
    )
}

def parse_ms_to_human_readable [ms] {
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

export def create_transient_prompt_left [] {
    if $env.LAST_EXIT_CODE == 0 {
        $"(ansi green_bold)├(ansi reset)"
    } else {
        $"(ansi red_bold)┬(ansi reset)"
    }
}
export def create_transient_prompt_indicator [] {
    $"(ansi blue_bold) ⏲(parse_ms_to_human_readable $env.CMD_DURATION_MS) (if $env.LAST_EXIT_CODE == 0 { ansi green_bold } else { ansi red_bold })➜(ansi reset) "
}