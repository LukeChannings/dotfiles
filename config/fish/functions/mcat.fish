function mcat --description "display anything"
    if file --mime-type $argv | grep -qF image/
        chafa -f iterm -s $FZF_PREVIEW_COLUMNS"x"$FZF_PREVIEW_LINES $argv
    else
        bat --color always --style numbers --theme TwoDark --line-range :200 $argv
    end
end
