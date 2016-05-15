# FISH plugins
fundle plugin 'edc/bass'
fundle plugin 'tuvistavie/oh-my-fish-core'
fundle plugin 'tuvistavie/fish-completion-helpers'
fundle plugin 'oh-my-fish/plugin-foreign-env'
fundle plugin 'tuvistavie/fish-nvm'
fundle plugin 'TheFuzzball/flash'
fundle init --profile

# Node Version manager
nvm use v5 > /dev/null ^ /dev/null &

# configure FZF to ignore files listed in various ignorefiles with ag.
set -gx FZF_DEFAULT_COMMAND='ag -g ""'