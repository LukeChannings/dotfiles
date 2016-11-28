function gitco -d "Fuzzy-find and checkout a branch"
  git branch --all | grep -v '*' | string replace -r 'remotes/.*?/' '' | sort -u | fzf | xargs git checkout
end
