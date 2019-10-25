function gitco -d "Fuzzy-find and checkout a branch"
  if test $argv[1] = '--'
    git reflog | egrep -io "moving from ([^[:space:]]+)" | awk '{ print $3 }' | awk ' !x[$0]++' | egrep -v '^[a-f0-9]{40}$' | fzf | xargs git checkout
  else if test $argv[1]
    git checkout $argv
  else
    git branch --all | grep -v '*' | string replace -r 'remotes/.*?/' '' | sort -u | fzf | xargs git checkout
  end
end
