# Nushell Config File
#
# version = "0.103.1"
$env.config.color_config = {
    separator: white
    leading_trailing_space_bg: { attr: n }
    header: green_bold
    empty: blue
    bool: light_cyan
    int: white
    filesize: cyan
    duration: white
    datetime: purple
    range: white
    float: white
    string: white
    nothing: white
    binary: white
    cell-path: white
    row_index: green_bold
    record: white
    list: white
    closure: green_bold
    glob:cyan_bold
    block: white
    hints: dark_gray
    search_result: { bg: red fg: white }
    shape_binary: purple_bold
    shape_block: blue_bold
    shape_bool: light_cyan
    shape_closure: green_bold
    shape_custom: green
    shape_datetime: cyan_bold
    shape_directory: cyan
    shape_external: cyan
    shape_externalarg: green_bold
    shape_external_resolved: light_yellow_bold
    shape_filepath: cyan
    shape_flag: blue_bold
    shape_float: purple_bold
    shape_glob_interpolation: cyan_bold
    shape_globpattern: cyan_bold
    shape_int: purple_bold
    shape_internalcall: cyan_bold
    shape_keyword: cyan_bold
    shape_list: cyan_bold
    shape_literal: blue
    shape_match_pattern: green
    shape_matching_brackets: { attr: u }
    shape_nothing: light_cyan
    shape_operator: yellow
    shape_pipe: purple_bold
    shape_range: yellow_bold
    shape_record: cyan_bold
    shape_redirection: purple_bold
    shape_signature: green_bold
    shape_string: green
    shape_string_interpolation: cyan_bold
    shape_table: blue_bold
    shape_variable: purple
    shape_vardecl: purple
    shape_raw_string: light_purple
    shape_garbage: {
        fg: white
        bg: red
        attr: b
    }
}

source /nix/store/23qv958gdvmmpgqrcpqv2mqpq1l1fg2v-zoxide-nushell-config.nu

use /nix/store/psb7rbibyjhi11rzgfvz79z06q4whxk0-starship-nushell-config.nu

source /nix/store/nhw96j78155mhmwin7h3hzmarhrd03l4-atuin-nushell-config.nu

$env.config = ($env.config? | default {})
$env.config.hooks = ($env.config.hooks? | default {})
$env.config.hooks.pre_prompt = (
    $env.config.hooks.pre_prompt?
    | default []
    | append {||
        direnv export json
        | from json --strict
        | default {}
        | items {|key, value|
            let value = do (
                $env.ENV_CONVERSIONS?
                | default {}
                | get -i $key
                | get -i from_string
                | default {|x| $x}
            ) $value
            return [ $key $value ]
        }
        | into record
        | load-env
    }
)

alias "eza" = eza --icons auto
alias "la" = eza -a
alias "ll" = eza -l
alias "lla" = eza -la
alias "ls" = eza
alias "lt" = eza --tree
