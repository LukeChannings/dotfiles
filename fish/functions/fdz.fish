function fdz
    fd --type f --hidden --follow --exclude .git --color=always | fzf --ansi --multi --preview='mcat {}'
end
