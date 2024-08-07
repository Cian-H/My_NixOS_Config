# Retrieve the theme settings
export def main [] {
    return {
        separator: '#ededed'
        leading_trailing_space_bg: { attr: 'n' }
        header: { fg: '#138034' attr: 'b' }
        empty: '#006bb3'
        bool: {|| if $in { '#5d504a' } else { 'light_gray' } }
        int: '#ededed'
        filesize: {|e|
            if $e == 0b {
                '#ededed'
            } else if $e < 1mb {
                '#384564'
            } else {{ fg: '#006bb3' }}
        }
        duration: '#ededed'
        date: {|| (date now) - $in |
            if $in < 1hr {
                { fg: '#d00e18' attr: 'b' }
            } else if $in < 6hr {
                '#d00e18'
            } else if $in < 1day {
                '#ffcb3e'
            } else if $in < 3day {
                '#138034'
            } else if $in < 1wk {
                { fg: '#138034' attr: 'b' }
            } else if $in < 6wk {
                '#384564'
            } else if $in < 52wk {
                '#006bb3'
            } else { 'dark_gray' }
        }
        range: '#ededed'
        float: '#ededed'
        string: '#ededed'
        nothing: '#ededed'
        binary: '#ededed'
        cell-path: '#ededed'
        row_index: { fg: '#138034' attr: 'b' }
        record: '#ededed'
        list: '#ededed'
        block: '#ededed'
        hints: 'dark_gray'
        search_result: { fg: '#d00e18' bg: '#ededed' }

        shape_and: { fg: '#6b2775' attr: 'b' }
        shape_binary: { fg: '#6b2775' attr: 'b' }
        shape_block: { fg: '#006bb3' attr: 'b' }
        shape_bool: '#5d504a'
        shape_custom: '#138034'
        shape_datetime: { fg: '#384564' attr: 'b' }
        shape_directory: '#384564'
        shape_external: '#384564'
        shape_externalarg: { fg: '#138034' attr: 'b' }
        shape_filepath: '#384564'
        shape_flag: { fg: '#006bb3' attr: 'b' }
        shape_float: { fg: '#6b2775' attr: 'b' }
        shape_garbage: { fg: '#FFFFFF' bg: '#FF0000' attr: 'b' }
        shape_globpattern: { fg: '#384564' attr: 'b' }
        shape_int: { fg: '#6b2775' attr: 'b' }
        shape_internalcall: { fg: '#384564' attr: 'b' }
        shape_list: { fg: '#384564' attr: 'b' }
        shape_literal: '#006bb3'
        shape_match_pattern: '#138034'
        shape_matching_brackets: { attr: 'u' }
        shape_nothing: '#5d504a'
        shape_operator: '#ffcb3e'
        shape_or: { fg: '#6b2775' attr: 'b' }
        shape_pipe: { fg: '#6b2775' attr: 'b' }
        shape_range: { fg: '#ffcb3e' attr: 'b' }
        shape_record: { fg: '#384564' attr: 'b' }
        shape_redirection: { fg: '#6b2775' attr: 'b' }
        shape_signature: { fg: '#138034' attr: 'b' }
        shape_string: '#138034'
        shape_string_interpolation: { fg: '#384564' attr: 'b' }
        shape_table: { fg: '#006bb3' attr: 'b' }
        shape_variable: '#6b2775'

        background: '#222225'
        foreground: '#ededed'
        cursor: '#ededed'
    }
}

# Update the Nushell configuration
export def --env "set color_config" [] {
    $env.config.color_config = (main)
}

# Update terminal colors
export def "update terminal" [] {
    let theme = (main)

    # Set terminal colors
    let osc_screen_foreground_color = '10;'
    let osc_screen_background_color = '11;'
    let osc_cursor_color = '12;'
        
    $"
    (ansi -o $osc_screen_foreground_color)($theme.foreground)(char bel)
    (ansi -o $osc_screen_background_color)($theme.background)(char bel)
    (ansi -o $osc_cursor_color)($theme.cursor)(char bel)
    "
    # Line breaks above are just for source readability
    # but create extra whitespace when activating. Collapse
    # to one line
    | str replace --all "\n" ''
    | print $in
}

export module activate {
    export-env {
        set color_config
        update terminal
    }
}

# Activate the theme when sourced
use activate