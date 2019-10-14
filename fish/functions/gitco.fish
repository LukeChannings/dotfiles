function gitco -d "Fuzzy-find and checkout a branch"
  if test $argv[1]
    git checkout $argv
  else
    git branch --all | grep -v '*' | string replace -r 'remotes/.*?/' '' | sort -u | fzf | xargs git checkout
  end
end
