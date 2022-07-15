# Nushell Environment Config File

def create_left_prompt [] {
    let short_pwd = $"($env.PWD | str replace $env.HOME '~')"

    let path_segment = if (is-admin) {
        $"(ansi red_bold)($short_pwd)"
    } else {
        $"(ansi blue_bold)($short_pwd)"
    }

    $path_segment
}

def create_right_prompt [] {
  let git_status = (do -i { git status -s --ignore-submodules=dirty } | complete)
  let is_git? = $git_status.exit_code == 0
  let is_dirty? = ($git_status.stdout | str length) > 0

  if ($is_git?) {
    let git_branch = (git symbolic-ref HEAD | str replace 'refs/heads/' '' | str trim)
    let git_branch_color = (if ($is_dirty?) { ansi red_bold } else { ansi green_bold })

    $"($git_branch_color)($git_branch)(ansi reset)"
  } else {
    $""
  }
}

# Use nushell functions to define your right and left prompt
let-env PROMPT_COMMAND = { create_left_prompt }
let-env PROMPT_COMMAND_RIGHT = { create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
let-env PROMPT_INDICATOR = { " λ " }
let-env PROMPT_INDICATOR_VI_INSERT = { $" (ansi defb)λ(ansi reset) " }
let-env PROMPT_INDICATOR_VI_NORMAL = { $" (ansi rb)λ(ansi reset) " }
let-env PROMPT_MULTILINE_INDICATOR = { "::: " }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
let-env ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) }
    to_string: { |v| $v | path expand | str collect (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) }
    to_string: { |v| $v | path expand | str collect (char esep) }
  }
}

# Directories to search for scripts when calling source or use
#
# By default, <nushell-config-dir>/scripts is added
let-env NU_LIB_DIRS = [
    ($nu.config-path | path dirname | path join 'scripts')
]

# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
let-env NU_PLUGIN_DIRS = [
    ($nu.config-path | path dirname | path join 'plugins')
]

let homebrew_dir = (if $nu.os-info.arch != "x86_64" { '/opt/homebrew' } else { '/usr/local' })

let-env PATH = (
  $env.PATH
  | prepend [$"($homebrew_dir)/bin" $"($homebrew_dir)/sbin"]
  | append [$"($homebrew_dir)/opt/fzf/bin" /Users/luke/.cargo/bin]
)

let-env EDITOR = "vim"
let-env VISUAL = "vim"
