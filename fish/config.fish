# ~/.config/fish/config.fish: DO NOT EDIT -- this file has been generated
# automatically by home-manager.

# Only execute this file once per shell.
set -q __fish_home_manager_config_sourced; and exit
set -g __fish_home_manager_config_sourced 1

source /nix/store/5hckcv3l6hnyrhwgfjq3vs8m7md1rbgm-hm-session-vars.fish



status is-login; and begin

    # Login shell initialisation


end

status is-interactive; and begin

    # Abbreviations


    # Aliases
    alias eza 'eza --icons auto'
    alias gh 'op plugin run -- gh'
    alias la 'eza -a'
    alias ll 'eza -l'
    alias lla 'eza -la'
    alias ls eza
    alias lt 'eza --tree'

    # Interactive shell initialisation
    zoxide init fish | source

    if test "$TERM" != dumb
        /home/luke/.nix-profile/bin/starship init fish | source

    end

    function __fish_command_not_found_handler --on-event fish_command_not_found
        /nix/store/3p87xh37wfcffqkmrm10gjcyz61n1cxv-command-not-found $argv
    end

    # add completions generated by Home Manager to $fish_complete_path
    begin
        set -l joined (string join " " $fish_complete_path)
        set -l prev_joined (string replace --regex "[^\s]*generated_completions.*" "" $joined)
        set -l post_joined (string replace $prev_joined "" $joined)
        set -l prev (string split " " (string trim $prev_joined))
        set -l post (string split " " (string trim $post_joined))
        set fish_complete_path $prev "/home/luke/.local/share/fish/home-manager_generated_completions" $post
    end

    atuin init fish | source

    direnv hook fish | source


end

status is-interactive; and begin
    enable_transience

    # Set QEMU=1 if we're in QEMU
    if command -q systemd-detect-virt; and [ $(systemd-detect-virt) = qemu ]
        set -x QEMU 1
    end
end
