fun! s:DetectBASH()
  if getline(1) == '#!/usr/bin/env bash'
    set ft=sh
  endif
endfun

autocmd BufNewFile,BufRead * call s:DetectBASH()
