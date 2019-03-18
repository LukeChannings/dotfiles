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

