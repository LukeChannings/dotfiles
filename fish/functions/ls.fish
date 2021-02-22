function ls --wraps=logo-ls --description 'alias ls=logo-ls'
  if test (command -v logo-ls)
        logo-ls $argv
    else
        /bin/ls $argv
    end
end
