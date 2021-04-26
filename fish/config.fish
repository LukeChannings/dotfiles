# FISH plugins
fundle plugin 'edc/bass'
fundle plugin 'tuvistavie/oh-my-fish-core'
fundle plugin 'tuvistavie/fish-completion-helpers'
fundle plugin 'oh-my-fish/plugin-foreign-env'
fundle plugin 'tuvistavie/fish-nvm'
fundle plugin 'LukeChannings/theme-l'
fundle plugin 'brgmnn/fish-docker-compose'
fundle init

# settings
set -gx EDITOR vim
set -gx VISUAL vim
set -gx GIT_EDITOR vim
set -gx FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --glob "!{.git,node_modules}/*"'
set -gx fish_greeting
set -gx LESSOPEN "| "(which highlight)" --out-format xterm256 -s Zenburn --quiet --force %s"
set -gx LESS " -R -X -F "
set -gx SSH_AUTH_SOCK "~/.ssh/agent"

alias git-branch-name="git rev-parse --abbrev-ref HEAD"

export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES
export GPG_TTY=(tty)

source ~/.config/fish/iterm2_shell_integration.fish

alias k8s-show-ns="kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get --show-kind --ignore-not-found -n"

alias k="kubectl"

set -gx PATH /usr/local/bin /home/linuxbrew/.linuxbrew/bin /home/linuxbrew/.linuxbrew/sbin /usr/local/sbin /opt/homebrew/bin /opt/homebrew/sbin $GOPATH/bin $HOME/.krew/bin $HOME/.cargo/bin $HOME/.deno/bin $PATH

alias hass="hass-cli -s https://home-assistant.private.channings.me --token $HASS_TOKEN"

fish_vi_key_bindings
